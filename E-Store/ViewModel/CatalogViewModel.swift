//
//  ViewModel.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//
import Combine
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import UIKit
import SwiftUI


class CatalogViewModel: ObservableObject { // (1)
//    @Published var showSort: Bool = false
    
    @Published var cartItems: [CartItem] = []

    let firebaseAuth = Auth.auth()
    @Published var user: User?

    
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
            update()
        }
    }
    
    @Published var products = [Product]()
    let db = Firestore.firestore()
    var myQuery: Query
    var myOrderedQuery: Query
    var previousDoc: DocumentSnapshot!
    @Published var hist: [DocumentSnapshot] = []
    
    init() {
        user = firebaseAuth.currentUser
        self.myQuery = db.collection("products").limit(to: 7)
        self.myOrderedQuery = db.collection("products").limit(to: 7)
        update()
        
        if let user = firebaseAuth.currentUser{
            let cart = db.collection("users").document(user.uid)
            cart.getDocument{ (document, error) in
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    if let cart = document?.get("cart"){
                        let items = cart as! [Any]
                        
                        items.forEach{ item in
                            let parseItem = item as! [String: Any]
                            let product = parseItem["item"] as! [String: Any]
                        
                            let parseProduct = Product(id: product["id"] as? String,name: product["name"] as! String, price: product["price"] as! Float, description: product["description"] as! String, image: product["image"] as! String, rating: product["rating"] as! Float)
                            
                            self.cartItems.append(CartItem(item: parseProduct, quantity: parseItem["quantity"] as! Int))
                        }
                    }
                    
                }
                
            }
        }
        
    }

    func next(){
        myOrderedQuery.start(afterDocument: previousDoc).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firestore error: ", err)
            } else if querySnapshot!.isEmpty {
                return
            } else {
                self.products = querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Product.self)
                }
                self.hist.append(self.previousDoc)
                self.previousDoc = querySnapshot!.documents.last
            }
        }
    }
    func previous(){
        let tmp = self.previousDoc
        let end = hist.popLast()!
        var tmpQuery: Query
        if hist.isEmpty {
            tmpQuery = myOrderedQuery.end(atDocument: end)
        }else{
            tmpQuery = myOrderedQuery.start(afterDocument: hist.last!).end(atDocument: end)
        }
        tmpQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firestore error: ", err)
                self.previousDoc = tmp
            } else if querySnapshot!.isEmpty {
                return
            } else {
                self.products = querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Product.self)
                }
                self.previousDoc = querySnapshot!.documents.last
            }
        }
    }
    func update(){
        self.hist = []
        myOrderedQuery = myQuery.order(by: self.field, descending: self.descending)
        myOrderedQuery.getDocuments() { (querySnapshot, err) in
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
    func search(text: String){
        if (text != ""){
            myQuery = db.collection("products")
            for word in text.lowercased().components(separatedBy: " "){
                if(word != ""){
                    myQuery = myQuery.whereField("keywords.\(word)", isEqualTo: true)
                }
            }
            myQuery = myQuery.limit(to: 7)
        }else{
            myQuery = db.collection("products").limit(to: 7)
        }
        update()
    }
    func signOut(){
        do {
            try firebaseAuth.signOut()
            self.user = firebaseAuth.currentUser
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func signIn(credential: AuthCredential){
        firebaseAuth.signIn(with: credential) { (authResult, error) in
          if let error = error {
            print ("Error signing in: %@", error)
          } else{
            self.user = self.firebaseAuth.currentUser
          }
        }
    }
    
    func addToCart(product: Product) {
        let item = CartItem(id: product.id,item: product, quantity: 1)
        if !cartItems.contains(item) {
            cartItems.append(item)
        }
        
        updateCartData()
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
        
        updateCartData()
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
    
    func updateCartData(){
        if let user = Auth.auth().currentUser?.uid {
            var details : [[String : Any]] = []
            
            self.cartItems.forEach{ (cart) in
                
                details.append([
                    "id": cart.id ?? "",
                    "item": [
                        "name": cart.item.name,
                        "price": cart.item.price,
                        "description": cart.item.description,
                        "image": cart.item.image,
                        "rating": cart.item.rating
                    ],
                    "quantity": cart.quantity
                ])
            }
        
            db.collection("users").document(user).setData([
                "cart": details
            ], merge: false){ (err) in
            if err != nil{
                return
            }
                print("Success!! Order was uploaded")
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

