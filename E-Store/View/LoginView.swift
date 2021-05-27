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
    @State var user: User? = Auth.auth().currentUser
    
  
    var body: some View {
        if user != nil {
            let current = Auth.auth().currentUser
            VStack{
                HStack{
                    Button("Log out"){
                        let firebaseAuth = Auth.auth()
                      do {
                        try firebaseAuth.signOut()
                        self.user = Auth.auth().currentUser
                      } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                      }
                    }
                }
                .frame(alignment: .trailing)
                Text((current?.displayName)!)
                Text((current?.email)!)
            }
        } else {
            VStack{
                Text("Login").font(.title).bold().foregroundColor(.red)
                Spacer(minLength: 20)
                GoogleSignInButton(showAuthAlert: $showAuthAlert, authError: $authError) { (authCredential) in
                    if let credential = authCredential{
                        Auth.auth().signIn(with: credential) { (authResult, error) in
                          if let error = error {
                            print(error)
                          } else{
                            self.user = Auth.auth().currentUser
                          }
                        }
                        
                    }
                    else{
                        self.authError = AppError.CredentailError
                        self.showAuthAlert = true
                        return
                    }
                    
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
