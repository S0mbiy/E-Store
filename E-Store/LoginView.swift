//
//  LoginView.swift
//  E-Store
//
//  Created by user191131 on 5/22/21.
//

import SwiftUI

enum AppError: Error{
    case CredentailError
}

struct LoginView: View {
  
    @State var showAuthAlert: Bool = false
    @State var authError: Error?
    @Binding var user: Bool
  
    var body: some View {
        VStack{
            Text("Login").font(.title).bold().foregroundColor(.red)
            Spacer(minLength: 20)
            GoogleSignInButton(showAuthAlert: $showAuthAlert, authError: $authError) { (authCredential) in
                
                if let credential = authCredential{
                    self.user = true
                }
                else{
                    self.authError = AppError.CredentailError
                    self.showAuthAlert = true
                    self.user = false
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
