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
    
    @Published var cartItems: [CartItem] = []
    
    
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
    
    func addToCart(product: Product) {
        let item = CartItem(id: product.id!, item: product, quantity: 1)
        if !cartItems.contains(item) {
            cartItems.append(item)
        }
    }
    
    func getCartIndex(cart: CartItem) -> Int{
        
        let index = self.cartItems.firstIndex{ (cart1) -> Bool in
            
                return cart.id == cart1.id
        } ?? 0
       return index
    }
    
    func deleteFromCart(cart: CartItem) {
        let index = getCartIndex(cart: cart)
        cartItems.remove(at: index)
    }
    
    func getTotal() -> String {
        var price : Double = 0
        
        cartItems.forEach{ (item) in
            price += Double(Double(truncating: NSNumber(value: item.quantity)) * Double(truncating: NSNumber(value: item.item.price)))
            
        }
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        let string = format.string(from: NSNumber(value: price)) ?? ""
        return "$\(String(string))"
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

