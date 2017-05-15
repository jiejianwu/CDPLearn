//
//  CardsManagerViewController.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/21.
//  Copyright © 2017年 wjj. All rights reserved.
//

import UIKit

class CardsManagerViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var person: Person?
    var bankCards: [BankCard]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView()
        self.title = person?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bankCards = person?.bankCards?.allObjects as? [BankCard]
        tableview.reloadData()
        
    }
    
    @IBAction func newPersonButtonTouched(_ sender: UIButton) {
        performSegue(withIdentifier: R.segue.cardsManagerViewController.segue_push_card, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewCardTableViewController {
            vc.person = person
        }
    }

}

extension CardsManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankCards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.personTableViewCell.identifier, for: indexPath) as! PersonTableViewCell
        cell.setup(bankCard: bankCards![indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { [unowned self](action, index) in
            let card = self.bankCards![index.row]
            BankCard.deleteBankCard(card)
            self.bankCards?.remove(at: index.row)
            tableView.deleteRows(at: [index], with: UITableViewRowAnimation.fade)
        }
        
        return [action]
    }

}
