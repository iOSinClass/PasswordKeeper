//
//  Password.swift
//  Password Keeper
//
//  Created by David Fisher on 4/11/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class Password: NSObject {

  var service: String
  var username: String
  var password: String
    var id: String?

  init(service: String, username: String, password: String) {
    self.service = service
    self.username = username
    self.password = password
  }
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.service = data["service"] as! String
        self.username = data["username"] as! String
        self.password = data["password"] as! String
    }
    
    var data: [String: Any] {
        return ["service": self.service,
                "username": self.username,
                "password": self.password]
    }
}
