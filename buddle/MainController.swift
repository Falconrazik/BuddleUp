//
//  ViewController.swift
//  buddle
//
//  Created by Vu Quang Huy on 10/11/2021.
//

import UIKit
import FirebaseAuth
import Firebase


class MainController: UIViewController {

    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in

            // if authenticated
            if user != nil {
                // print message
                print("User is already logged in")

                // automatically switch to chat view
                self.switchToHomeVC()
            } else {
                print("User not Logged In.")
            }
        })
        
        // Customize Sign In Buttons
        styledLoginButton()
        styledSignUpButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is already logged in
    }
    
    @IBAction func LogInButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "LogInVC", sender: sender)
    }
    
    @IBAction func SignUpButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "SignUpVC", sender: sender)
    }
    
    func styledLoginButton() {
        LogInButton.backgroundColor = UIColor.white
        LogInButton.layer.cornerRadius = 22
        LogInButton.layer.borderWidth = 1
        LogInButton.layer.cornerCurve = .continuous
    }
    
    func styledSignUpButton() {
        SignUpButton.layer.cornerRadius = 22
        SignUpButton.layer.borderWidth = 1
        SignUpButton.layer.cornerCurve = .continuous
    }
    
    func switchToHomeVC() {
        let HomeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
        self.view.window?.rootViewController = HomeVC
        self.view.window?.makeKeyAndVisible()
    }
    
    func switchToCreateAccountVC() {
        let createAccountVC = self.storyboard?.instantiateViewController(identifier: "CreateAccountVC") as? CreateAccountVC
        self.view.window?.rootViewController = createAccountVC
        self.view.window?.makeKeyAndVisible()
    }

}

