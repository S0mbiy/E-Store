//
//  E_StoreApp.swift
//  E-Store
//
//  Created by user191131 on 5/17/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct E_StoreApp: App {
    
    init() {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID =  "704983942237-o6ua7ts633knv56ai472gqlk73ovpnlp.apps.googleusercontent.com"
    }
    
    var body: some Scene {
        WindowGroup {
            Catalog()
        }
    }
}
