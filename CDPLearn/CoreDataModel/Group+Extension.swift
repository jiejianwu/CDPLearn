//
//  Group+Extension.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/22.
//  Copyright © 2017年 wjj. All rights reserved.
//

import Foundation
import CoreData

extension Group {
    
    class func getAll() -> [Group]? {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        
        do {
            return try DataBaseManager.shareInstance.objectContext?.fetch(request)
        } catch let err {
            print("\(err.localizedDescription)")
            return nil
        }
    }
    
    class func createNewGroup(by person: Person, name: String) -> Group {
        let group = Group(context: DataBaseManager.shareInstance.objectContext!)
        return updateGroup(group: group, name: name, person: person)
    }
    
    class func updateGroup(group: Group, name: String, person: Person) -> Group {
        group.name = name
        group.leader = person
        do {
            try DataBaseManager.shareInstance.objectContext?.save()
        } catch let err {
            print("\(err.localizedDescription)")
        }
        return group
    }
    
}
