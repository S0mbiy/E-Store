//
//  PaymentCard.swift
//  E-Store
//
//  Created by AccedoADM on 30/05/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PaymentCard: Codable, Identifiable, Equatable{
    @DocumentID var id: String?
    let cardNumber: Int
    let owner: String
    let cvv: Int
    let expirationDate: Date
    
    static func ==(lhs: PaymentCard, rhs: PaymentCard) -> Bool{
        return lhs.cardNumber == rhs.cardNumber
    }

}
