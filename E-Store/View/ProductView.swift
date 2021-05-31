//
//  ProductView.swift
//  E-Store
//
//  Created by user188304 on 5/29/21.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    var catalog: CatalogViewModel
    var showProduct: Binding<Bool>
    var body: some View {
        VStack(alignment: .center) {
                    Spacer()
                    VStack {
                        AsyncImage(
                            url: URL(string: product.image)!,
                            placeholder: {Text("Loading ...")}
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        Text("\(String(product.name))").font(
                            .system(size: 18, weight: .bold)).padding(.bottom, 2)
                        Text("$\(String(product.price)) USD")
                            .font(.system(size: 24)).padding(.bottom, 5)
                        Text("\(String(product.description))")
                            .font(.system(size: 18, weight: .light)).padding(.bottom, 5)
                        Text("Envio en 24 horas").font(
                            .system(size: 12, weight: .bold)).padding(.bottom, 5)
                    }
                    VStack {
                        Button(action: {
                            print("added")
                            catalog.addToCart(product: product)
                            showProduct.wrappedValue = false
                        }, label: {
                            Text("Comprar")
                                .font(
                                .system(size: 18, weight: .bold))
                                .background(Color(red: 0.83, green: 0.18, blue: 0.18))
                                            .foregroundColor(Color.white)
                        })
                        .padding(.vertical, 18.0).padding(.horizontal, 54)
                        .background(Color(red: 0.83, green: 0.18, blue: 0.18))
                        .clipShape(Capsule())
                    }.padding(.bottom, 16)
                }
        
    }
}
