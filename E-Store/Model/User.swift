//
//  User.swift
//  E-Store
//
//  Created by AccedoADM on 25/05/21.
//

import Foundation
import Combine
import FirebaseAuth

class User: ObservableObject {
    @Published var user: FirebaseAuth
}
