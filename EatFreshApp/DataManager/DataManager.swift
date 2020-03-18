//
//  DataManager.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 14/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    private override init() {
    }
    
    // MARK: - Managed Object Context
    
    /// Returns the Main Context
    /// - returns: Main Context
    private func getMainContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        return context
        
    }
    
    /// Creates and Returns the Child Context
    /// - returns: Child Context
    private func getBackgroundContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = context
        return privateManagedObjectContext
    }
    
    /// Saves the objects in Main Context to persistent store
    /// - returns: Main Context
    public func saveMainContext()
    {
        do {
            try self.getMainContext().save()
        } catch let error {
            print(error)
        }
    }
    
    /// Deletes the enties stored
    public func clearStorage() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Eatery")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.getMainContext().execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
    }

    // MARK: - Fetch Eateries Data

    /// Returns Array of Eateries saved
    /// - returns: Array of Eateries
    func fetchEateries() -> [Eatery]
    {
        var eateries = [Eatery]()
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Eatery")
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "rating", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            eateries = try getMainContext().fetch(fetchRequest) as! [Eatery]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return eateries
    }
}

