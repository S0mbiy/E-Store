//
//  ReviewViewModel.swift
//  E-Store
//
//  Created by user188304 on 6/7/21.
//

import Foundation
import Firebase

class ReviewViewModel: ObservableObject {
    
    
    @Published var reviews: [Review] = []
    private var db = Firestore.firestore()
    @Published var review: Review = Review(title: "", review: "")
    private var idProduct: String = ""
    
    func loadReviews(idProduct: String) {
        self.idProduct = idProduct
        print("\(idProduct)")
        if (self.idProduct != ""){
            print("getting  info")
            db.collection("products/\(idProduct)/reviews").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    self.reviews = []
                } else {
                    self.reviews = []
                    for document in querySnapshot!.documents {
                        self.reviews.append(Review(id: document.documentID, title: document.data()["title"] as? String ?? "", review: document.data()["review"] as? String ?? ""))
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
        }
    }
    
    func addReview(review: Review) {
        do {
            let _ = try db.collection("products/\(self.idProduct)/reviews").addDocument(from: review)
        } catch {
            print(error)
        }
    }
        
    func save() {
        addReview(review: review)
    }
    
    
}


