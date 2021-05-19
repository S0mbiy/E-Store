//
//  ContentView.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Catalog(catalog: CatalogViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
