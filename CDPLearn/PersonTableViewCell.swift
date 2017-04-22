//
//  PersonTableViewCell.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/20.
//  Copyright © 2017年 wjj. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pkLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    func setup(person: Person) {
        pkLabel.text = "\(person.pk)"
        nameLabel.text = person.name
        sexLabel.text = person.sexType.desc
        ageLabel.text = "\(person.age)"
    }
    
    func setup(bankCard: BankCard) {
        nameLabel.text = bankCard.cardNumber
        sexLabel.text = bankCard.bankName
        ageLabel.text = "\(bankCard.balance)"
    }
    
    func setup(group: Group) {
        nameLabel.text = group.name
        sexLabel.text = group.leader?.name
        ageLabel.text = "\(group.members?.count ?? 0)"
    }
    
}
