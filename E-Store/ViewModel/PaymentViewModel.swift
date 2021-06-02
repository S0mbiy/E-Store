//
//  PaymentViewModel.swift
//  E-Store
//
//  Created by AccedoADM on 30/05/21.
//

import Combine
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import UIKit
import SwiftUI

class PaymentViewModel: ObservableObject{
    @Published var subtotal: Int
    @ObservedObject var homeData: CatalogViewModel
    @Published var total: Int = 0
    
    @Published var cardNumber: String = ""
    @Published var errorCardNumber: String = ""
    
    @Published var ownerName: String = ""
    @Published var errorName: String = ""
    
    @Published var cvv: String = ""
    @Published var errorCvv: String = ""
    
    @Published var expirationMonth = ""
    @Published var expirationYear = ""
    @Published var errorDate: String = ""
    
    @Published var alert: Bool = false
    
    let shipmentFee: Int = 89
    let firebaseAuth = Auth.auth()
    
    init(subtotal:Int, homeData: CatalogViewModel) {
        self.subtotal = subtotal
        self.homeData = homeData
    }
    
    func calculateTotal(){
        self.total = subtotal + shipmentFee
    }
    
    func validateData() -> Bool{
        var isValid = true
        if cardNumber.count < 13 || cardNumber.count > 18 {
            errorCardNumber = "There are numbers missing"
            isValid = false
        }
        else {
            errorCardNumber = ""
        }
        if cvv.count != 3 {
            errorCvv = "There are numbers missing"
            isValid = false}
        else{
            errorCvv = ""
        }
        if ownerName.isEmpty {
            errorName = "Name must not be empty"
            isValid = false
            
        }else{
            errorName = ""
        }
        if expirationMonth.count != 2 || Int(expirationMonth)! < 1 || Int(expirationMonth)! > 12 {
            errorDate = "Date not valid"
            isValid = false
            
        }else{
            errorDate = ""
        }
        if expirationYear.count != 2 || Int(expirationYear)! < 20 || Int(expirationYear)! > 99{
            errorDate = "Date not valid"
            isValid = false
            
        } else {
            errorDate = ""
        }
        
        return isValid
    }
    
    func makeOrder(){
        if let user = firebaseAuth.currentUser{
            let db = Firestore.firestore()
            let orders = db.collection("users").document(user.uid)
            orders.getDocument{ (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    if let cart = document?.get("cart"){
                        orders.setData([
                            "orders": cart,
                            "cart" : []
                        ])
                        self.alert = true
                    }
                }
                    
            }
                
        }
    }
    
    func clearCart(){
        homeData.clearCart()
    }
    
}
