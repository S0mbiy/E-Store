//
//  LoginView.swift
//  E-Store
//
//  Created by user191131 on 5/22/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

enum AppError: Error{
    case CredentailError
}

struct LoginView: View {
  
    @State var showAuthAlert: Bool = false
    @State var authError: Error?
    @ObservedObject var catalog: CatalogViewModel
  
    var body: some View {
        if catalog.user != nil {
            VStack(spacing: 10){
                AsyncImage(
                    url: (catalog.user?.photoURL)!,
                    placeholder: {Text("User image")}
                )
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .cornerRadius(40)
                Text((catalog.user?.displayName) ?? "Missing name").font(.system(size: 20))
                Text((catalog.user?.email) ?? "Missing email").font(.system(size: 20))
                Spacer()
                Button(action: {
                    catalog.signOut()
                }){
                    Text("Log out").font(.system(size: 20))
                        .bold()
                        .padding(10)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                }
            }
        } else {
            VStack{
                Text("Login").font(.title).bold().foregroundColor(.red)
                Spacer(minLength: 20)
                GoogleSignInButton(showAuthAlert: $showAuthAlert, authError: $authError) { (authCredential) in
                    guard let credential = authCredential else{
                        self.authError = AppError.CredentailError
                        self.showAuthAlert = true
                        return
                    }
                    catalog.signIn(credential: credential)
                    
                   // Your further auth logic goes here (eg: FirebaseAuth)
                }.padding()
                .cornerRadius(15)
                
            }
            .alert(isPresented: $showAuthAlert) {
                
                Alert(title: Text("Login Failed"),
                      message: Text("\(self.authError?.localizedDescription ?? "Unknown Reason")"),
                      dismissButton: .default(Text("OK"), action: {
                        self.showAuthAlert = false
                      }))
            }
        }
        
    }
}
