//
//  Persistence.swift
//  SerenePath
//
//  Created by Kushal Pagolu on 4/6/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()

    let container: NSPersistentCloudKitContainer
    func addSampleDataIfNeeded() {
        // Check if sample data is already added
        let fetchRequest: NSFetchRequest<Therapist> = Therapist.fetchRequest()
        let count = try? container.viewContext.count(for: fetchRequest)
        guard let entityCount = count, entityCount == 0 else { return }

        // Add sample data
        let sampleEntity = Therapist(context: container.viewContext)
        sampleEntity.firstName = "Dr. Dan"
        sampleEntity.lastName = "Sanders"
        // Set other properties as needed

        // Save the context
        do {
            try container.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "AppModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        // Load JSON data from data.json
     /*      if let jsonData = loadJSONData(filename: "data") {
               do {
                   try saveJSONDataToCoreData(jsonData: jsonData, context: container.viewContext)
               } catch {
                   print("Error saving JSON data to Core Data: \(error)")
               }
           } */
       // addSampleDataIfNeeded()
    }
}

var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    // Add sample data for the preview
    for i in 1...5 {
        let user = User(context: viewContext)
        user.id = UUID()
        user.username = "user\(i)"
        user.password = "password\(i)"
    }

    do {
        try viewContext.save()
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }

    return result
}()





/*
struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "SerenePath")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}


*/
