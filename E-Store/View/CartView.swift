//
//  CartView.swift
//  E-Store
//
//  Created by AccedoADM on 24/05/21.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var homeData: CatalogViewModel
    @Environment(\.presentationMode) var present
    @State var selection: Int? = nil
    
    var body: some View {
        VStack{
            Spacer()
            HStack(spacing: 20){
                Button(action: {present.wrappedValue.dismiss()}){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Your cart")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
                Spacer()
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(spacing: 0){
                    Text(homeData.cartItems.count > 0 ? "Items in your car:" : "Cart is empty")
                    
                    ForEach(homeData.cartItems){ cart in
                        HStack(spacing: 10){
                            AsyncImage(
                                url: URL(string: cart.item.image)!,
                                placeholder: {Text("Loading ...")}
                            )
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: 20){
                                Text(String(cart.item.name))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                Text("$\(String(cart.item.price))")
                                    .font(.system(size:10))
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 15){
                                    
                                    //Add - Sub Button
                                    
                                    Button(action: {
                                        if cart.quantity > 1 {
                                            homeData.cartItems[homeData.getCartIndex(cart: cart)].quantity -= 1
                                            homeData.updateCartData()
                                        }
                                        
                                    }){
                                        Image(systemName: "minus")
                                            .font(.system(size: 14, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color.black.opacity(0.06))
                                    
                                    Button(action: {
                                        if cart.quantity < 10 {
                                            homeData.cartItems[homeData.getCartIndex(cart: cart)].quantity += 1
                                            homeData.updateCartData()
                                        }
                                        
                                    }){
                                        Image(systemName: "plus")
                                            .font(.system(size: 14, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                    Button(action: {
                                        homeData.deleteFromCart(cart: cart)
                                    }){
                                        Image(systemName: "trash")
                                            .font(.system(size: 14, weight: .heavy))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding()
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            }
            if(homeData.cartItems.count>0){
                VStack{
                    HStack{
                        Text("Total")
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(homeData.getTotal())
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                    }
                    .padding([.top, .horizontal])
                    
                    NavigationLink(destination: PaymentView(vm: PaymentViewModel(subtotal: Int(homeData.getTotal()) ?? 0 , homeData: homeData)), tag: 1, selection: $selection){
                        Button(action: {
                            self.selection = 1
                        }){
                            Text( "Check out")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 30)
                                .background(
                                    LinearGradient(gradient: .init(colors: [Color.blue, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(15)
                        }
                    }
                    
                }
                .background(Color.white)
            }
            
            
            //  Spacer(minLength: 0)
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct CartView_Previews: PreviewProvider {
    
    static var previews: some View {
        let catalog: CatalogViewModel = CatalogViewModel()
        
        CartView(homeData: catalog)
    }
}
