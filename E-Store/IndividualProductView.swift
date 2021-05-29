//
//  IndividualProductView.swift
//  E-Store
//
//  Created by user188304 on 5/24/21.
//

import SwiftUI

struct IndividualProductView: View {
    
    @ObservedObject var product: IndividualProduct = IndividualProduct(productUid: "CDO4lOJ5NAkyfBF4nwZR")
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            VStack {
                Text("\(String(product.product.name))").font(
                    .system(size: 18, weight: .bold)).padding(.bottom, 2)
                Text("$\(String(product.product.price)) USD")
                    .font(.system(size: 24)).padding(.bottom, 5)
                Text("\(String(product.product.description))")
                    .font(.system(size: 18, weight: .light)).padding(.bottom, 5)
                Text("Envio en 24 horas").font(
                    .system(size: 12, weight: .bold))
            }
            VStack {
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Comprar").font(
                        .system(size: 18, weight: .bold)).foregroundColor(.white)
                }
                .padding(.vertical, 18.0).padding(.horizontal, 54)
                .background(Color(red: 0.83, green: 0.18, blue: 0.18))
                .clipShape(Capsule())
            }.padding(.bottom, 8)
        }
    }
}

struct IndividualProductView_Previews: PreviewProvider {
    static var previews: some View {
        IndividualProductView()
    }
}


