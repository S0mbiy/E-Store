//
//  ViewModel.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//
import Combine
import Foundation
import Firebase
import FirebaseFirestoreSwift
import UIKit


class CatalogViewModel: ObservableObject { // (1)
    @Published var products = [Product]()
    let db = Firestore.firestore()
    var myQuery: Query
    var previousDoc: DocumentSnapshot!
    
    init() {
//        for _ in [1,2,3,4,5]{
//            db.collection("products").addDocument(data: ["name": "Nike Hat", "price": 9.99, "description": "Great hat", "image": "https://encrypted-tbn2.gstatic.com/shopping?q=tbn:ANd9GcSvYunDzux2reJBgICiV0b2CLzUT1LyUwADURKVeGzNFSEElhGGseEjRetYx7T4E6BVhpNe86ISbw&usqp=CAc", "rating": 5, "keywords": ["nike": true, "hat": true]]){ err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Document added")
//                }
//            }
//        }
        myQuery = db.collection("products").order(by: "rating", descending: true).limit(to: 10)
        myQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firestore error: ", err)
            } else {
                self.products = querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Product.self)
                }
                self.previousDoc = querySnapshot!.documents.last
            }
        }
    }
    func next(){
        myQuery = myQuery.start(afterDocument: previousDoc)
        myQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firestore error: ", err)
            } else if querySnapshot!.isEmpty {
                return
            } else {
                self.products += querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Product.self)
                }
                self.previousDoc = querySnapshot!.documents.last
            }
        }
    }
//    func previous(){
//
//    }
    func search(text: String){
        if (text != ""){
            myQuery = db.collection("products")
            for word in text.lowercased().components(separatedBy: " "){
                myQuery = myQuery.whereField("keywords.\(word)", isEqualTo: true)
            }
            myQuery = myQuery.limit(to: 10)
            myQuery.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Firestore error: ", err)
                } else {
                    self.products = querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Product.self)
                    }
                    self.previousDoc = querySnapshot!.documents.last
                }
            }
        }else{
            myQuery = db.collection("products").order(by: "rating", descending: true).limit(to: 10)
            myQuery.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Firestore error: ", err)
                } else {
                    self.products = querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Product.self)
                    }
                    self.previousDoc = querySnapshot!.documents.last
                }
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL

    init(url: URL) {
        self.url = url
    }
    
    private var cancellables = Set<AnyCancellable>()

    func load() {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
            .store(in: &cancellables)
    }
}
