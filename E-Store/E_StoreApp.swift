//
//  E_StoreApp.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//

import SwiftUI
import Firebase

@main
struct E_StoreApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
