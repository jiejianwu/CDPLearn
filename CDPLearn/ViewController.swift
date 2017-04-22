//
//  ViewController.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/19.
//  Copyright © 2017年 wjj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var persons: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        persons = Person.getPersons()
        tableview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newPersonButtonTouched(_ sender: UIButton) {
        performSegue(withIdentifier: "segue_push_person", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewPersonTableViewController {
            vc.person = sender as? Person
        } else if let vc = segue.destination as? CardsManagerViewController {
            vc.person = sender as? Person
        } else if let vc = segue.destination as? GroupManagerViewController {
            vc.person = sender as? Person
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as! PersonTableViewCell
        cell.setup(person: persons![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionSheet = UIAlertController(title: "what you wanna do", message: "touch it", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Update Infomation", style: UIAlertActionStyle.default, handler: { (action) in
            self.performSegue(withIdentifier: "segue_push_person", sender: self.persons![indexPath.row])
        }))
        actionSheet.addAction(UIAlertAction(title: "Manager Cards", style: UIAlertActionStyle.default, handler: { (action) in
            self.performSegue(withIdentifier: "segue_push_cards", sender: self.persons![indexPath.row])
        }))
        actionSheet.addAction(UIAlertAction(title: "Manager Groups", style: UIAlertActionStyle.default, handler: { (action) in
            self.performSegue(withIdentifier: "segue_push_group", sender: self.persons![indexPath.row])
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { [unowned self](action, index) in
            let person = self.persons![index.row]
            Person.deletePerson(person)
            self.persons?.remove(at: index.row)
            tableView.deleteRows(at: [index], with: UITableViewRowAnimation.fade)
        }
        
        return [action]
    }
    
}
