//
//  LogInVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 15/11/2021.
//

import UIKit
import FirebaseAuth

class LogInVC: UIViewController, UITextFieldDelegate {
    
    // IBOutlets
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var logInErrorMessage: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Styling
        styledLogInButton()
        
        // disable log in button by default
        enableLogInButton(enabled: false)
        
        // declare delegates
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // observe text fields to enable log in button when appropriate
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // initialize content of error message as an empty string
        logInErrorMessage.text = ""
    }
    
    // view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is already logged in
        
        Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            
            // if authenticated
            if user != nil {
                // print message
                print("User is already logged in")
                
                // automatically switch to chat view
                self.switchToHomeVC()
            } else {
                print("Not logged in.")
            }
        })
    }
    
    func styledLogInButton() {
        logInButton.layer.cornerRadius = 22
        logInButton.layer.borderWidth = 1
        logInButton.layer.cornerCurve = .continuous
    }
    
    @IBAction func backgroundTouched(_ sender: Any) {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    @IBAction func loginWithPasswordTapped(_ sender: Any) {
        // Implement
        //handleSignIn()
        
        // dismiss keyboard
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // enable the log in button if none of the text fields are empty
    @objc func textFieldChanged(_ target:UITextField) {
        
        // check if form is filled (bool)
        let formFilled = emailTF.text != nil && emailTF.text != "" && passwordTF.text != nil && passwordTF.text != ""
        
        // enable sign up if form is filled
        enableLogInButton(enabled: formFilled)
    }
    
    // move to other text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        // if return email text field, go to email text field
        case emailTF:
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
            break
        // if return password text field, go call handle sign up function
        case passwordTF:
            handleLogIn()
            break
        default:
            break
        }
        return true
    }
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "mainVC", sender: sender)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SignUpVC", sender: sender)
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        handleLogIn()
        // dismiss keyboard
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    
    // enable or disable the sign up button
    func enableLogInButton(enabled:Bool) {
        
        // if enabled
        if enabled {
            // if sign up button is enabled
            // set alpha too 100% and set bool isEnabled to true
            logInButton.alpha = 1.0
            logInButton.isEnabled = true
        } else {
            // else if sign up button is disabled
            // reduce alpha and set bool isEnabled to false
            logInButton.alpha = 0.5
            logInButton.isEnabled = false
        }
    }
    
    @objc func handleLogIn() {
        print("Log In Tapped!")
        
        // get the text from text fields (if any)
        guard let email = emailTF.text else { return }
        guard let pass = passwordTF.text else { return }
        
        // log in with password
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            // if login is not successful (error != nil)
            if error != nil {
                // print error
                print(error!.localizedDescription)
                
                // display error
                self.logInErrorMessage.text = error!.localizedDescription
                
                // return
                return
            } else {
                // switch to success view
                self.switchToHomeVC()
            }
        }
        
    }
    
    func switchToHomeVC() {
        let homeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
        self.view.window?.rootViewController = homeVC
        self.view.window?.makeKeyAndVisible()
    }
    
}
