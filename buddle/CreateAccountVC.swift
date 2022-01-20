//
//  CreateAccountVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 15/11/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateAccountVC: UIViewController, UITextFieldDelegate {

    // IB Outlets
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var universityTF: UITextField!
    @IBOutlet weak var yearSC: UISegmentedControl!
    @IBOutlet weak var majorTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var signUpErrorMessage: UILabel!
    
    // Variables
    var year = "Freshman"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styledSubmitButton()
        enableSignUpButton(enabled: false)
        
        // declare delegates
        fullNameTF.delegate = self
        ageTF.delegate = self
        universityTF.delegate = self
        majorTF.delegate = self
        genderTF.delegate = self
        cityTF.delegate = self
        
        // observe text fields to enable sign up button when appropriate
        fullNameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        ageTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        universityTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        majorTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        genderTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cityTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        signUpErrorMessage.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // immediately make fullNameTF first responder
        fullNameTF.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // resign first responder fo all text fields
        fullNameTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        universityTF.resignFirstResponder()
        majorTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        cityTF.resignFirstResponder()
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
        fullNameTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        universityTF.resignFirstResponder()
        majorTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        cityTF.resignFirstResponder()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        switchToCreateProfileVC()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
         handleSubmit()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        // if return fullName text field, go to email university field
        case fullNameTF:
            fullNameTF.resignFirstResponder()
            ageTF.becomeFirstResponder()
            break
        // if return age text field, go to email university field
        case ageTF:
            ageTF.resignFirstResponder()
            universityTF.becomeFirstResponder()
            break
        // if return university text field, go to year text field
        case universityTF:
            universityTF.resignFirstResponder()
            majorTF.becomeFirstResponder()
            break
        case majorTF:
            majorTF.resignFirstResponder()
            genderTF.becomeFirstResponder()
            break
        case genderTF:
            genderTF.resignFirstResponder()
            cityTF.becomeFirstResponder()
            break
        case cityTF:
            handleSubmit()
            break;
        default:
            break
        }
        return true
    }
    
    // Styling
    func styledSubmitButton() {
        submitButton.layer.cornerRadius = 22
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerCurve = .continuous
    }
    // enable sign up button
    func enableSignUpButton(enabled:Bool) {
        // if enabled
        if enabled {
            // if sign up button is enabled
            // set alpha too 100% and set bool isEnabled to true
            submitButton.alpha = 1.0
            submitButton.isEnabled = true
        } else {
            // else if sign up button is disabled
            // reduce alpha and set bool isEnabled to false
            submitButton.alpha = 0.5
            submitButton.isEnabled = false
        }
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        // check if form is filled (bool)
        let formFilled = fullNameTF.text != "" && ageTF.text != "" && universityTF.text != "" && majorTF.text != "" && genderTF.text != "" && cityTF.text != ""
        
        // enable sign up if form is filled
        enableSignUpButton(enabled: formFilled)
    }
    
    
    @IBAction func selectYear(_ sender: UISegmentedControl) {
        let yearIndex = yearSC.selectedSegmentIndex
        year = yearSC.titleForSegment(at: yearIndex) ?? "Freshman"
        
    }
    
    @objc func handleSubmit() {
        print("Submit Tapped!")
        
        // get text from text fields
        guard let fullName = fullNameTF.text else { return }
        guard let age = ageTF.text else { return }
        guard let university = universityTF.text else { return }
        guard let gender = genderTF.text else { return }
        guard let major = majorTF.text else { return }
        guard let city = cityTF.text else { return }
        
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let currentUID = currentUser?.uid as! String
        let curUser = db.collection("users").document(currentUID)
        
        curUser.updateData([
            "fullName": fullName,
            "age": age,
            "university": university,
            "year": year,
            "gender": gender,
            "major": major,
            "city": city
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        fullNameTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        universityTF.resignFirstResponder()
        majorTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        cityTF.resignFirstResponder()
        
        self.switchToCreateProfileVC()
    }
    
    func switchToCreateProfileVC() {
        let createProfileVC = self.storyboard?.instantiateViewController(identifier: "createProfileVC") as? CreateProfieVC
        self.view.window?.rootViewController = createProfileVC
        self.view.window?.makeKeyAndVisible()
    }

}
