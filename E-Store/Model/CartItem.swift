//
//  CartItem.swift
//  E-Store
//
//  Created by AccedoADM on 25/05/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CartItem: Codable, Identifiable, Equatable{
    @DocumentID var id: String?
    let item: Product
    var quantity: Int
    
    static func ==(lhs: CartItem, rhs: CartItem) -> Bool{
        return lhs.item.id == rhs.item.id
    }

}
