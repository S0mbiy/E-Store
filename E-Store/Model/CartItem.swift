//
//  CartItem.swift
//  E-Store
//
//  Created by AccedoADM on 25/05/21.
//

import SwiftUI

struct CartItem: Identifiable, Equatable{
    var id: String?
    var item: Product
    var quantity: Int
    
    static func ==(lhs: CartItem, rhs: CartItem) -> Bool{
        return lhs.item.id == rhs.item.id
    }
}
