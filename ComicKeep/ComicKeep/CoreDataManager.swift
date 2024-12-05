//
//  CoreDataManager.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/14/24.
//

import UIKit
import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - CRUD Operations

    // Create
    func createComic(title: String, issueNumber: Int16, notes: String?, variant: Bool, keyIssue: Bool, coverImage: Data?, acquired: Bool=true, price: Double?, wishlist:Bool=false) {
        let comic = Comic(context: context)
        comic.title = title
        comic.issueNumber = issueNumber
        comic.notes = notes
        comic.variant = variant
        comic.keyIssue = keyIssue
        comic.coverImage = coverImage
        comic.acquired = acquired
        comic.wishlist = wishlist
        comic.dateAdded = Date()
        comic.price = NSDecimalNumber(value: price ?? 0.0)

        do {
            try context.save()
        } catch {
            print("Failed to save comic: \(error)")
        }
    }

    // Read
    func fetchComics(acquired: Bool? = nil, wishlist: Bool? = nil) -> [Comic]? {
        let fetchRequest: NSFetchRequest<Comic> = Comic.fetchRequest()

        var predicates = [NSPredicate]()

        if let acquired = acquired {
            predicates.append(NSPredicate(format: "acquired == %@", NSNumber(value: acquired)))
        }

        if let wishlist = wishlist {
            predicates.append(NSPredicate(format: "wishlist == %@", NSNumber(value: wishlist)))
        }

        if !predicates.isEmpty {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        do {
            let comics = try context.fetch(fetchRequest)
            return comics
        } catch {
            print("Failed to fetch comics: \(error)")
            return nil
        }
    }

    // Update
    func updateComic(comic: Comic) -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Failed to update comic: \(error)")
            return false
        }
    }

    // Delete
    func deleteComic(comic: Comic) -> Bool {
        context.delete(comic)
        do {
            try context.save()
            return true
        } catch {
            print("Failed to delete comic: \(error)")
            return false
        }
    }
    
    // MARK: TESTING
    
    func addDummyComics() {
            let dummyComics = [
                ("Spider-Man", 1, false, true, "First appearance of Spider-Man", 3.99),
                ("Batman", 50, true, false, "Anniversary issue", 4.99),
                ("Superman", 75, false, true, "Death of Superman", 2.99),
                ("X-Men", 1, false, true, "First issue of X-Men", 5.99),
                ("Wonder Woman", 750, false, false, "Milestone issue", 4.99),
                ("The Flash", 123, true, true, "First appearance of Earth-Two", 3.50),
                ("Green Lantern", 76, false, true, "Start of the Green Lantern/Green Arrow series", 6.00),
                ("Iron Man", 55, false, true, "First appearance of Thanos", 5.50),
                ("Fantastic Four", 1, false, true, "First Marvel superhero team", 7.99)
            ]
            
            for comicData in dummyComics {
                let coverImage = UIImage(named: "placeholder")?.jpegData(compressionQuality: 1.0)
                self.createComic(
                    title: comicData.0,
                    issueNumber: Int16(comicData.1),
                    notes: comicData.4,
                    variant: comicData.2,
                    keyIssue: comicData.3,
                    coverImage: coverImage,
                    acquired: false,
                    price: comicData.5,
                    wishlist: true
                )
            }
        }
}
