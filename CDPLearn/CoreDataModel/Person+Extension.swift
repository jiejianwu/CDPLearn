//
//  Person+Extension.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/19.
//  Copyright © 2017年 wjj. All rights reserved.
//

import Foundation
import CoreData

enum Sex: Int {
    
    case Male = 0
    case Female = 1
    
    var desc: String {
        return self == .Male ? "male" : "female"
    }
}

extension Person {
    
    var sexType: Sex {
        return self.sex == 0 ? .Male : .Female
    }
    
    class func getPersons() -> [Person]? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            return try DataBaseManager.shareInstance.objectContext?.fetch(request)
        } catch let err {
            print("request error: \(err.localizedDescription)")
            return nil
        }
    }
    
    class func getPerson(by pk: Int32) -> Person? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "pk = %d", pk)
        do {
            return try DataBaseManager.shareInstance.objectContext?.fetch(request).first
        } catch let err {
            print("request error: \(err.localizedDescription)")
            return nil
        }
    }
    
    class func insertNewPerson(name: String, age: Int, sex: Sex) -> Person? {
        let person = Person(context: DataBaseManager.shareInstance.objectContext!)
        return updatePerson(person, name: name, age: age, sex: sex)
    }
    
    class func updatePerson(_ person: Person, name: String, age: Int, sex: Sex) -> Person? {
        person.name = name
        person.age = Int32(age)
        person.sex = Int32(sex.rawValue)
        let key = "pk_index"
        var index = UserDefaults.standard.integer(forKey: key)
        index += 1
        person.pk = Int32(index)
        if DataBaseManager.shareInstance.save() {
            UserDefaults.standard.set(index, forKey: key)
            return person
        }
        return nil
    }
    
    class func deletePersons(_ persons:[Person]) {
        for person in persons {
            deletePerson(person)
        }
    }
    
    class func deletePerson(_ person: Person) {
        DataBaseManager.shareInstance.objectContext?.delete(person)
    }

    func joinGroup(_ group: Group) {
        self.groups = self.groups!.adding(group) as NSSet
        _ = DataBaseManager.shareInstance.save()
    }
    
    func quitGroup(_ group: Group) {
        let groups: NSMutableSet = self.groups!.mutableCopy() as! NSMutableSet
        groups.remove(group)
        self.groups = groups.copy() as? NSSet
        _ = DataBaseManager.shareInstance.save()
    }
    
}

