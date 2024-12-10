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
}
