//
//  GroupManagerViewController.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/22.
//  Copyright © 2017年 wjj. All rights reserved.
//

import UIKit

class GroupManagerViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var person: Person?
    var ownGroups: [Group]?
    var memberGroups: [Group]?
    var otherGroups: [Group]?
    var allGroups: [Group]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView()
        prepareData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GroupMemberViewController {
            vc.group = sender as? Group
        }
    }
    
    func prepareData() {
        ownGroups = person?.ownGroups?.allObjects as? [Group]
        memberGroups = person?.groups?.allObjects as? [Group]
        allGroups = Group.getAll()
        guard let own = ownGroups, let member = memberGroups, let all = allGroups else {
            return
        }
        
        otherGroups = all.filter {
            return !own.contains($0) && !member.contains($0)
        }

    }
    
    @IBAction func newGroupButtonTouched(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "New Group", message: "once group is created, you are the leader", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            guard let name = alertController.textFields?.first?.text else {
                return
            }
            _ = Group.createNewGroup(by: self.person!, name: name)
            self.prepareData()
            self.tableview.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertController.addTextField { (textField) in
            textField.placeholder = "input the group name"
            textField.borderStyle = .roundedRect
        }
        self.present(alertController, animated: true, completion: nil)
        
        guard let container = alertController.textFields?.first?.superview else {
            return
        }
        guard let effectView = container.superview?.subviews[0] as? UIVisualEffectView else {
            return
        }
        
        container.backgroundColor = UIColor.clear
        effectView.removeFromSuperview()
        
    }
    
    
}


extension GroupManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Owned Groups", "In Groups", "Other Groups"][section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return max(ownGroups?.count ?? 1, 1)
        case 1:
            return max(memberGroups?.count ?? 1, 1)
        case 2:
            return max(otherGroups?.count ?? 1, 1)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groups = [ownGroups, memberGroups, otherGroups][indexPath.section]
        guard let gs = groups, gs.count > 0 else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Group"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupTableViewCell", for: indexPath) as! PersonTableViewCell
        cell.setup(group: gs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        var g: Group?
        switch indexPath.section {
        case 0:
            if let o = ownGroups, o.count > 0 {
                g = o[indexPath.row]
            }
        case 1:
            if let m = memberGroups, m.count > 0 {
                g = m[indexPath.row]
            }
        case 2:
            if let o = otherGroups, o.count > 0 {
                g = o[indexPath.row]
            }
        default:
            g = nil
        }
        
        guard let selectGroup = g else {
            return
        }
        
        performSegue(withIdentifier: "segue_push_member", sender: selectGroup)

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        switch indexPath.section {
        case 0:
            return false
        case 1:
            return memberGroups?.count ?? 0 > 0
        case 2:
            return otherGroups?.count ?? 0 > 0
        default:
            return false
        }

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        switch indexPath.section {
        case 1:
            actions.append(UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Quit", handler: { (action, ip) in
                let group = self.memberGroups![ip.row]
                self.person?.quitGroup(group)
                self.prepareData()
                self.tableview.reloadData()
            }))
        case 2:
            actions.append(UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Join", handler: { (action, ip) in
                let group = self.otherGroups![ip.row]
                self.person?.joinGroup(group)
                self.prepareData()
                self.tableview.reloadData()
            }))

        default:
            break
        }
        return actions
    }
    
}

