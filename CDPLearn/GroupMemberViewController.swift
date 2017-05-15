//
//  GroupMemberViewController.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/24.
//  Copyright © 2017年 wjj. All rights reserved.
//

import UIKit

class GroupMemberViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var group: Group? {
        didSet {
            members = group?.members?.allObjects as? [Person]
        }
    }
    var members: [Person]?
    
}


extension GroupMemberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return group == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : max(members?.count ?? 0, 1)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Owner" : "Members"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 0 && (members == nil || members!.count == 0) {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Member"
            return cell
        }
        
        let cell = tableview.dequeueReusableCell(withIdentifier: R.reuseIdentifier.personTableViewCell.identifier, for: indexPath) as! PersonTableViewCell
        
        if indexPath.section == 0 {
            cell.setup(person: group!.leader!)
        } else {
            cell.setup(person: members![indexPath.row])
        }
        
        return cell
    }
    
}
