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

    init() {
        db.collection("products").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Firestore error: ", err)
            } else {
                self.products = querySnapshot!.documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Product.self)
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
