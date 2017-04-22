//
//  NewPersonTableViewController.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/20.
//  Copyright © 2017年 wjj. All rights reserved.
//

import UIKit

class NewPersonTableViewController: UITableViewController {
    
    var person: Person?
    var isNew: Bool {
        return person == nil
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setup()
    }
    
    func setup() {
        self.title = isNew ? "New Person" : "Update Person"
        if let p = person {
            self.nameTextField.text = p.name
            self.ageTextField.text = "\(p.age)"
            sexSegment.selectedSegmentIndex = p.sexType.rawValue
        }
    }
    
    @IBAction func submitButtonTouched(_ sender: UIButton) {
        guard let name = nameTextField.text, let ageStr = ageTextField.text, let age = Int(ageStr) else {
            return
        }
        
        var tmp: Person?
        let sex = Sex(rawValue: sexSegment.selectedSegmentIndex)!
        if isNew {
            tmp = Person.insertNewPerson(name: name, age: age, sex: sex)
        } else {
            tmp = Person.updatePerson(person!, name: name, age: age, sex: sex)
        }
        if let _ = tmp {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}
