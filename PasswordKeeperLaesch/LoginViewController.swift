//
//  LoginViewController.swift
//  Password Keeper
//
//  Created by David Fisher on 4/11/18.
//  Copyright © 2018 David Fisher. All rights reserved.
//

import UIKit
import Material
import Firebase
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    let roseFireRegistryToken = "0c55b705-8540-48f8-b45f-09caa7853bb7"
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var emailPasswordCard: Card!
  @IBOutlet weak var emailPasswordCardContent: UIView!
  @IBOutlet weak var emailTextField: TextField!
  @IBOutlet weak var passwordTextField: TextField!

  @IBOutlet weak var rosefireLoginButton: RaisedButton!
//  @IBOutlet weak var googleLoginButton: UIView!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!


  override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()
    
    GIDSignIn.sharedInstance().uiDelegate = self
  }

  func prepareView() {
    self.view.backgroundColor = Color.indigo.base
    titleLabel.font = RobotoFont.thin(with: 36)

    // Email / Password
    prepareEmailPasswordCard()

    // Rosefire
    rosefireLoginButton.title = "Rosefire Login"
    rosefireLoginButton.titleColor = .white
    rosefireLoginButton.titleLabel!.font = RobotoFont.medium(with: 18)
    rosefireLoginButton.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.9)
    rosefireLoginButton.pulseColor = .white

    // Google OAuth
        googleLoginButton.style = .wide

  }

  func prepareEmailPasswordCard() {
    emailPasswordCard.contentView = emailPasswordCardContent

    emailTextField.placeholder = "Email"
    emailTextField.isClearIconButtonEnabled = true
    emailTextField.placeholderActiveColor = Color.grey.darken2

    passwordTextField.placeholder = "Password"
    passwordTextField.clearButtonMode = .whileEditing
    passwordTextField.isVisibilityIconButtonEnabled = true
    passwordTextField.placeholderActiveColor = Color.grey.darken2

    let bottomBar = Bar()
    let signUpBtn: FlatButton = FlatButton()
    signUpBtn.pulseColor = Color.blue.lighten1
    signUpBtn.setTitle("Sign up", for: .normal)
    signUpBtn.setTitleColor(Color.blue.darken1, for: .normal)
    signUpBtn.addTarget(self,
                        action: #selector(handleEmailPasswordSignUp),
                        for: .touchUpInside)
    bottomBar.leftViews = [signUpBtn]

    let loginBtn: FlatButton = FlatButton()
    loginBtn.pulseColor = Color.blue.lighten1
    loginBtn.setTitle("Login", for: .normal)
    loginBtn.setTitleColor(Color.blue.darken1, for: .normal)
    loginBtn.addTarget(self,
                       action: #selector(handleEmailPasswordLogin),
                       for: .touchUpInside)
    bottomBar.rightViews = [loginBtn]
    emailPasswordCard.bottomBar = bottomBar

    emailPasswordCard.toolbarEdgeInsetsPreset = .square3
    emailPasswordCard.toolbarEdgeInsets.bottom = 0
    emailPasswordCard.toolbarEdgeInsets.right = 8
    emailPasswordCard.contentViewEdgeInsetsPreset = .wideRectangle3
    emailPasswordCard.bottomBarEdgeInsetsPreset = .wideRectangle2
  }

  // MARK: - Login Methods
    func loginCompletionCallback(_ user: User?, _ error: Error?) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
            let ac = UIAlertController(title: "Login Failed",
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            appDelegate.handleLogin()
        }
    }

  @objc func handleEmailPasswordSignUp() {
    Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: loginCompletionCallback)
  }


  @objc func handleEmailPasswordLogin() {
    Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: loginCompletionCallback)
  }


  @IBAction func rosefireLogin(_ sender: Any) {
    Rosefire.sharedDelegate().uiDelegate = self
    Rosefire.sharedDelegate().signIn(registryToken: roseFireRegistryToken) { (error, result) in
        if let error = error {
            print("Error communicating with Rosefire \(error.localizedDescription)")
            return
        }
        print("You are signed in with RoseFire! username: \(result!.username)")
        Auth.auth().signIn(withCustomToken: result!.token, completion: self.loginCompletionCallback)
    }
  }

}
