//
//  CoreDataManager.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/14/24.
//

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

    // MARK: - CRUD Operations

    // Create
    func createComic(title: String, issueNumber: Int16, notes: String?, variant: Bool, keyIssue: Bool, coverImage: Data?, price: Double?) -> Comic? {
        let comic = Comic(context: context)
        comic.title = title
        comic.issueNumber = issueNumber
        comic.notes = notes
        comic.variant = variant
        comic.keyIssue = keyIssue
        comic.coverImage = coverImage
        comic.acquired = true
        comic.wishlist = false
        comic.dateAdded = Date()
        comic.price = NSDecimalNumber(value: price ?? 0.0)

        do {
            try context.save()
            return comic
        } catch {
            print("Failed to save comic: \(error)")
            return nil
        }
    }

    // Read
    func fetchComics() -> [Comic]? {
        let fetchRequest: NSFetchRequest<Comic> = Comic.fetchRequest()

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
