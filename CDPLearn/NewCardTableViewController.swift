//
//  NewCardTableViewController.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/21.
//  Copyright © 2017年 wjj. All rights reserved.
//

import UIKit

class NewCardTableViewController: UITableViewController {
    
    
    var person: Person?
    
    @IBOutlet weak var bankNumberField: UITextField!
    @IBOutlet weak var bankNameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func submitButtonTouched(_ sender: UIButton) {
        guard let cardNumber = bankNumberField.text, let bankName = bankNameField.text else {
            return
        }
        
        if let _ = BankCard.insertNewBankCard(balance: 0, bankName: bankName, cardNumber: cardNumber, owner: person!) {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}
