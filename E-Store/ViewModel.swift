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
import SwiftUI


class CatalogViewModel: ObservableObject { // (1)
//    @Published var showSort: Bool = false
    
    var field = "rating"
    var descending = true
    var selection: String = "Rating descending"{
        didSet {
//            print("Selection changed to \(selection)")
//            showSort = false
            switch selection{
            case "Rating descencing":
                self.field = "rating"
                self.descending = true
            case "Rating ascending":
                self.field = "rating"
                self.descending = false
            case "Name desceniding":
                self.field = "name"
                self.descending = true
            case "Name ascending":
                self.field = "name"
                self.descending = false
            case "Price descending":
                self.field = "price"
                self.descending = true
            case "Price ascending":
                self.field = "price"
                self.descending = false
            default:
                print("AppError: Unknown selection made")
            }
            updateOccurred = true
            let tmp = self.products
            self.products = tmp
        }
    }
    
    var updateOccurred = false
    @Published var products = [Product]() {
        didSet {
            if updateOccurred{
                updateOccurred = false
                switch field{
                case "rating":
                    products = descending ? products.sorted(by: { $0.rating > $1.rating }) : products.sorted(by: { $0.rating < $1.rating })
                case "price":
                    products = descending ? products.sorted(by: { $0.price > $1.price }) : products.sorted(by: { $0.price < $1.price })
                case "name":
                    products = descending ? products.sorted(by: { $0.name > $1.name }) : products.sorted(by: { $0.name < $1.name })
                default:
                    print("AppError: Missing sort logic")
                }
            }
        }
    }
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
        myQuery = db.collection("products").limit(to: 7)
        myQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firestore error: ", err)
            } else {
                self.updateOccurred = true
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
                self.updateOccurred = true
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
                if(word != ""){
                    myQuery = myQuery.whereField("keywords.\(word)", isEqualTo: true)
                }
            }
            myQuery = myQuery.limit(to: 7)
            myQuery.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Firestore error: ", err)
                } else {
                    self.updateOccurred = true
                    self.products = querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Product.self)
                    }
                    self.previousDoc = querySnapshot!.documents.last
                }
            }
        }else{
            myQuery = db.collection("products").limit(to: 7)
            myQuery.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Firestore error: ", err)
                } else {
                    self.updateOccurred = true
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

class IndividualProduct: ObservableObject {

    let db = Firestore.firestore()
    var productUid: String
    @Published var product = Product()
    
    init(productUid: String) {
        self.productUid = productUid
        let myQuery = db.collection("products").document(productUid)
        
        myQuery.getDocument {
            (document, error) in
            let result = Result {
                try document?.data(as: Product.self)
            }
            
            switch result {
                case .success(let product):
                    if let product = product {
                        // A `City` value was successfully initialized from the DocumentSnapshot.
                        print("City: \(product)")
                        self.product = product
                    } else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        print("Document does not exist")
                    }
                case .failure(let error):
                    // A `City` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding city: \(error)")
                }
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
        [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

