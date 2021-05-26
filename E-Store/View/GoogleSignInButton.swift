//
//  GoogleSignInButton.swift
//  E-Store
//
//  Created by user191131 on 5/22/21.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

enum AuthError: Error {
    case failedToAuthenticate
}

struct GoogleSignInButton: UIViewRepresentable {

    var showAuthAlert: Binding<Bool>
    var authError: Binding<Error?>
    var onCompletion: ((AuthCredential?) -> Void)

    // Here I am using FirebaseAuth for Authetication mechanism, feel free you use your own & just replace type.
    init(showAuthAlert: Binding<Bool>, authError: Binding<Error?>, onCompletion: @escaping ((AuthCredential?) -> Void)) {
        self.showAuthAlert = showAuthAlert
        self.authError = authError
        self.onCompletion = onCompletion
    }
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignInButton>) {
    }

    func makeUIView(context: Context) -> GIDSignInButton {

        // Create instance
        let googleSigninButton = GIDSignInButton()

        // Set style as wide, you are free here to use your choice
        googleSigninButton.style = .standard

        // Maksure that there must be a presenting controller as a container
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController

        // Below created `Coordinator` type will be delegating object for GIDSignIn
        GIDSignIn.sharedInstance()?.delegate = context.coordinator

        // & finally return it, because function expectes it.
        return googleSigninButton
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
class Coordinator: NSObject, GIDSignInDelegate {

    // To hold pointer to SwiftUI value type
    var control:GoogleSignInButton

    init(_ control:GoogleSignInButton) {
        self.control = control
    }

    // If there is any configuration error, such as config in .plist, then error will be thrown in below delegate function,
    // else GIDGoogleUser will be given in it.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            // On error, Update Binding varible so that UI can be updated
            control.authError.wrappedValue = error
            control.showAuthAlert.wrappedValue = true
            return
        }
        
        // Safe Unwrap to avoid crash, incase of any problem show Error Alert on UI
        guard let authentication = user.authentication else {
          control.authError.wrappedValue = AuthError.failedToAuthenticate
          control.showAuthAlert.wrappedValue = true
          return
        }

        // Validate with GoogleAuthProvider
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        // onCompletion send back instance of AuthCredential as promised in constructor of GoogleSignInButton, so that further auth can be carried out
        control.onCompletion(credential)
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      
        signIn.disconnect()
        if error != nil {
          // On error, Update Binding varible so that UI can be updated
          control.authError.wrappedValue = error
          control.showAuthAlert.wrappedValue = true
        }
    }
}
