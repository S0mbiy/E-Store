//
//  ProductViewModel.swift
//  E-Store
//
//  Created by user188304 on 5/29/21.
//

import Foundation


class ProductViewModel: ObservableObject { // (1)
//    @Published var showSort: Bool = false
    
    @Published var product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    
}
