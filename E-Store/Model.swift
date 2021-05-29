//
//  Model.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Product: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let price: Float
    let description: String
    let image: String
    let rating: Float
    
    init() {
        name = "Some product"
        price = 0.0
        description = "Any description"
        image = ""
        rating = 0.0
    }

}
