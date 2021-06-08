//
//  Review.swift
//  E-Store
//
//  Created by user188304 on 6/7/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Review: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    let title: String
    let review: String
    
    static func ==(lhs: Review, rhs: Review) -> Bool{
        return lhs.id == rhs.id
    }
}

