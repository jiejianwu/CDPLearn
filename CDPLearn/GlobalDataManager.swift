//
//  GlobalDataManager.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/19.
//  Copyright © 2017年 wjj. All rights reserved.
//

import CoreData

final class DataBaseManager {
    
    static let shareInstance = DataBaseManager()
    
    lazy var objectContext: NSManagedObjectContext? = {
        guard let url = Bundle.main.url(forResource: "CDPLearn", withExtension: "momd"), let model = NSManagedObjectModel(contentsOf: url) else {
            return nil
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory")
        }
        let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: ["NSMigratePersistentStoresAutomaticallyOption": true, "NSInferMappingModelAutomaticallyOption": true])
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        return context
    }()
    
    func save() -> Bool {
        do {
            try objectContext?.save()
            return true
        } catch let err {
            print("\(err)")
            return false
        }
    }
}
