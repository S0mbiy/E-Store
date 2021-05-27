//
//  Catalog.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//

import SwiftUI

struct Catalog: View {
    @State private var searchText = ""
    @StateObject var catalog: CatalogViewModel = CatalogViewModel()
    @State var showAuth = false
    @State var selection: Int? = nil
    
    let sorts = ["Rating descencing", "Rating ascending", "Name desceniding", "Name ascending", "Price descending", "Price ascending"]
    
    
    var body: some View {
       
        VStack{
            NavigationLink(destination: LoginView(), isActive: $showAuth) {
                                EmptyView()
            }.hidden()
            
            HStack{
                Button(action:{
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.showAuth = true
                    }
                }){
                    Image(systemName: "person.fill").font(.system(size: 30.0)).foregroundColor(.red)
                }
                Spacer()
                Text("E-Store")
                    .font(.system(size: 50.0)).bold().foregroundColor(.red)
                Spacer()
                NavigationLink(destination: CartView(homeData: catalog), tag: 1, selection: $selection) {
                    Button(action:{
                        self.selection = 1
                    }){
                        Text("Cart")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                }
                
            }.padding()
        
            
            HStack{
                SearchBar(text: $searchText, catalog: catalog)
                Section {
                    Picker("sort", selection: $catalog.selection) {
                        ForEach(sorts, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) //SegmentedPickerStyle
                }
                .padding(EdgeInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 15)))
//                Button(action: {catalog.showSort.toggle()}, label: {Text("sort")}).padding()
            }
            
//            if catalog.showSort{
//                Picker space
//            }
            
            
            List{
                ForEach(catalog.products) { item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.system(size: 20))
                            Spacer()
                            
                            HStack{
                                Text("$\(String(item.price))")
                                    .font(.system(size: 18)).bold()
                                    .padding(.bottom)
                                Spacer()
                                Text("\(String(item.rating))⭐")
                                    .font(.system(size: 18)).bold()
                                    .padding(.bottom)
                            }
                        }
                        Spacer()
                        AsyncImage(
                            url: URL(string: item.image)!,
                            placeholder: {Text("Loading ...")}
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        Button(action: {
                            catalog.addToCart(product:item)
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                Rectangle().hidden().onAppear {
                    if !catalog.products.isEmpty{
                        catalog.next()
                        print("Reached the end")
                    }
                }
            }.listStyle(PlainListStyle())
//            HStack(spacing: 30){
//                Button(action: {catalog.previous()}){
//                                    Image(systemName: "chevron.left")
//                                        .font(.system(size: 25, weight: .heavy))
//                                        .foregroundColor(.black)
//                                }
//                Button(action: {catalog.next()}){
//                                    Image(systemName: "chevron.right")
//                                        .font(.system(size: 25, weight: .heavy))
//                                        .foregroundColor(.black)
//                                }
//            }
            
        }
    }
}

struct Catalog_Previews: PreviewProvider {
    static var previews: some View {
        Catalog()
    }
}
