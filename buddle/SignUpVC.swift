//
//  SignUpVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 15/11/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpErrorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styledSignUpButton()
        
        // declare delegates
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // observe text fields to enable sign up button when appropriate
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // initialize content of error message as an empty string
        signUpErrorMessage.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // immediately make fullNameTF first responder
        emailTF.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // resign first responder fo all text fields
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    // disable automatic keyboard dismissal
    override var disablesAutomaticKeyboardDismissal: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backgroundTouched(_ sender: Any) {
        self.emailTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
    }
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "LogInVC", sender: sender)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        handleSignUp()
    }
    
    // Styling
    func styledSignUpButton() {
        signUpButton.layer.cornerRadius = 22
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.cornerCurve = .continuous
    }
    
    // move to other text fields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        // if return email text field, go to password text field
        case emailTF:
            emailTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
            break
        // if return password text field, go call handle sign up function
        case passwordTF:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    // enable sign up button
    func enableSignUpButton(enabled:Bool) {
        // if enabled
        if enabled {
            // if sign up button is enabled
            // set alpha too 100% and set bool isEnabled to true
            signUpButton.alpha = 1.0
            signUpButton.isEnabled = true
        } else {
            // else if sign up button is disabled
            // reduce alpha and set bool isEnabled to false
            signUpButton.alpha = 0.5
            signUpButton.isEnabled = false
        }
    }
    
    // enable the sign up button if none of the text fields are empty
    @objc func textFieldChanged(_ target:UITextField) {
        // check if form is filled (bool)
        let formFilled = emailTF.text != nil && emailTF.text != "" && passwordTF.text != nil && passwordTF.text != ""
        
        // enable sign up if form is filled
        enableSignUpButton(enabled: formFilled)
    }
    
    @objc func handleSignUp() {
        print("Sign Up Tapped!")
        
        guard let email = emailTF.text else { return }
        guard let pass = passwordTF.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            // if user is not nil and error is nil
            if error == nil && result != nil {
                
                // print status
                print("User created successfully")
                
                // post to user database
                let db = Firestore.firestore()
                let project = [String]()
                
                db.collection("users").document(result!.user.uid).setData([
                    "uid": result!.user.uid,
                    "email": email,
                    "project": project
                ])
                
                
                // resign first responder
                self.emailTF.resignFirstResponder()
                self.passwordTF.resignFirstResponder()
                self.switchToCreateAccountVC()
                
            } else {
                // print error
                print("Error: \(error!.localizedDescription)")
                
                // display error
                self.signUpErrorMessage.text = error!.localizedDescription
            }
        }
        
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    func switchToCreateAccountVC() {
        let createAccountVC = self.storyboard?.instantiateViewController(identifier: "CreateAccountVC") as? CreateAccountVC
        self.view.window?.rootViewController = createAccountVC
        self.view.window?.makeKeyAndVisible()
    }
    
}
