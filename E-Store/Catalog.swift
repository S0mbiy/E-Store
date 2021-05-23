//
//  Catalog.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//

import SwiftUI

struct Catalog: View {
    @State private var searchText = ""
    @ObservedObject var catalog: CatalogViewModel = CatalogViewModel()
    @State var showAuth = false
    @State var user: Bool = false
    
    var body: some View {
       
        VStack{
            NavigationLink(destination: LoginView(user: $user), isActive: $showAuth) {
                                EmptyView()
            }.hidden()
            
            HStack{
                Text("E-Store")
                    .font(.system(size: 56.0)).bold().foregroundColor(.red)
                    
                Spacer()
                
                Button(action:{
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.showAuth = true
                    }
                }){
                    Image(systemName: "person.fill").font(.system(size: 40.0)).foregroundColor(.red)
                }
                
            }.padding()
        
            SearchBar(text: $searchText, catalog: catalog)
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
