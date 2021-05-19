//
//  Catalog.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//

import SwiftUI

struct Catalog: View {
    @State private var searchText = ""
    @ObservedObject var catalog: CatalogViewModel
    
    var body: some View {
        VStack{
            SearchBar(text: $searchText)
 
            List(catalog.products.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { item in
                HStack(spacing: 60){
                    VStack(alignment: .leading){
                        Text(item.name)
                            .font(.title)
                        Text("Price: "
                             + String(item.price))
                            .bold()
                    }
                    AsyncImage(
                        url: URL(string: item.image)!,
                        placeholder: {Text("Loading ...")}
                    )
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .trailing)
                }
                
            }
        }
    }
}

struct Catalog_Previews: PreviewProvider {
    static var previews: some View {
        Catalog(catalog: CatalogViewModel())
    }
}
