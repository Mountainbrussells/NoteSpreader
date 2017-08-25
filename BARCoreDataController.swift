//
//  BARCoreDataController.swift
//  NoteSpreader
//
//  Created by BenRussell on 8/24/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import Foundation
import CoreData

let containerName = "NoteSpreader"

class BARCoreDataController:NSObject, NSFetchedResultsControllerDelegate {
    
    let container: NSPersistentContainer!
    
    class var sharedInstance: BARCoreDataController {
        struct Static {
            static let instance: BARCoreDataController = BARCoreDataController()
        }
        return Static.instance
    }
    
    override init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (storeDEscription, error) in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        super.init()
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
}

