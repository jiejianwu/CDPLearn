//
//  BankCard+Extension.swift
//  CDPLearn
//
//  Created by wjj on 2017/4/21.
//  Copyright © 2017年 wjj. All rights reserved.
//

import CoreData

extension BankCard {
    
//    class func getBankCards(by person: Person) -> [BankCard]? {
//        let request: NSFetchRequest<BankCard> = BankCard.fetchRequest()
//        request.predicate = NSPredicate(format: "owner.pk = %d", person.pk)
//        do {
//            return try DataBaseManager.shareInstance.objectContext?.fetch(request)
//        } catch let err {
//            print("request error: \(err.localizedDescription)")
//            return nil
//        }
//    }
    
    class func getBankCard(by number: String) -> BankCard? {
        let request: NSFetchRequest<BankCard> = BankCard.fetchRequest()
        request.predicate = NSPredicate(format: "cardNumber = %d", number)
        do {
            return try DataBaseManager.shareInstance.objectContext?.fetch(request).first
        } catch let err {
            print("request error: \(err.localizedDescription)")
            return nil
        }
    }
    
    class func insertNewBankCard(balance: Int, bankName: String, cardNumber: String, owner: Person) -> BankCard? {
        let bankCard = BankCard(context: DataBaseManager.shareInstance.objectContext!)
        return updateBankCard(bankCard, balance: balance, bankName: bankName, cardNumber: cardNumber, owner: owner)
    }
    
    private class func updateBankCard(_ bankCard: BankCard, balance: Int, bankName: String, cardNumber: String, owner: Person) -> BankCard? {
        bankCard.balance = Int32(balance)
        bankCard.bankName = bankName
        bankCard.cardNumber = cardNumber
        bankCard.owner = owner
        
        do {
            try DataBaseManager.shareInstance.save()
            return bankCard
        } catch let err {
            print("save error: \(err.localizedDescription)")
            return nil
        }
    }
    
    class func deleteBankCards(_ bankCards:[BankCard]) {
        for bankCard in bankCards {
            deleteBankCard(bankCard)
        }
    }
    
    class func deleteBankCard(_ bankCard: BankCard) {
        DataBaseManager.shareInstance.objectContext?.delete(bankCard)
    }
    
}
