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
    @ObservedObject var reviewViewModel: ReviewViewModel
    @Environment(\.presentationMode) var present
    @State var title: String = ""
    @State var review: String = ""
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
        }
        ScrollView() {
            VStack {
                AsyncImage(
                    url: URL(string: product.image)!,
                    placeholder: {Text("Loading ...")}
                )
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                Text("\(String(product.name))").font(
                    .system(size: 18, weight: .bold)).padding(.bottom, 2)
                Text(String(repeating: "⭐", count: Int(product.rating))).font(
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
            VStack(alignment: .leading) {
                HStack() {
                    Text("Reviews").font(
                        .system(size: 18, weight: .bold)).padding(.bottom, 2)
                    Spacer()
                }
                HStack {
                    VStack {
                        ForEach(0..<reviewViewModel.reviews.count, id: \.self) { i in
                            HStack {
                                VStack {
                                    Text(reviewViewModel.reviews[i].title).bold()
                                    Text(reviewViewModel.reviews[i].review).italic()
                                }
                                Spacer()
                            }.padding().border(Color.black, width: 2)
                        }
                    }
                    Spacer()
                }
                
                HStack() {
                    Text("Add review").font(
                        .system(size: 16, weight: .bold)).padding(.vertical, 4)
                    Spacer()
                }
                HStack {
                    VStack {
                        VStack(alignment: .leading) {
                            
                            Text("Titulo")
                            TextField("", text:$title).textFieldStyle(RoundedBorderTextFieldStyle())
                            Text("Review")
                            TextEditor(text: $review)
                                
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(red: 0.90, green: 0.90, blue: 0.90), lineWidth: 1)
                                )
                        }
                        Button(
                            action: {
                                self.reviewViewModel.review = Review(title: title, review: review)
                                reviewViewModel.save()
                                showProduct.wrappedValue = false
                            }, label: {
                                Text("Enviar review").font(
                                    .system(size: 18, weight: .bold))
                                    .background(Color(red: 0.83, green: 0.18, blue: 0.18))
                                    .foregroundColor(Color.white)
                            }
                        ).padding().foregroundColor(.white).background(Color(red: 0.83, green: 0.18, blue: 0.18))
                        .clipShape(Capsule())
                    }
                    Spacer()
                }
                
                
            }.padding(.all, 10)
            
        }
        
    }
}
