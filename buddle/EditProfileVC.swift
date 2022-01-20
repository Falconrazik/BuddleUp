//
//  EditProfileVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 21/11/2021.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UITextFieldDelegate {
    
    // IBOutlets
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var universityTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var majorTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var bioTF: UITextField!
    @IBOutlet weak var skill1TF: UITextField!
    @IBOutlet weak var skill2TF: UITextField!
    @IBOutlet weak var skill3TF: UITextField!
    @IBOutlet weak var skill4TF: UITextField!
    @IBOutlet weak var skill5TF: UITextField!
    @IBOutlet weak var linkedInTF: UITextField!
    @IBOutlet weak var instaTF: UITextField!
    @IBOutlet weak var fbTF: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    // variables
    var skillsArray = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styling
        styling()
        
        fullnameTF.delegate = self
        ageTF.delegate = self
        universityTF.delegate = self
        yearTF.delegate = self
        majorTF.delegate = self
        cityTF.delegate = self
        bioTF.delegate = self
        skill1TF.delegate = self
        skill2TF.delegate = self
        skill3TF.delegate = self
        skill4TF.delegate = self
        skill5TF.delegate = self
        linkedInTF.delegate = self
        instaTF.delegate = self
        fbTF.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        handleUpdate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTouched(_ sender: Any) {
        resign()
    }
    
    func handleUpdate() {
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let UID = currentUser?.uid as! String
        let user = db.collection("users").document(UID)
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User skills
                self.skillsArray = document.get("skills") as! [String]
                
                let skill1 = self.skill1TF.text
                if skill1 != "" {
                    self.skillsArray[0] = skill1 ?? ""
                    user.updateData(["skills": self.skillsArray])
                }
                let skill2 = self.skill2TF.text
                if skill2 != "" {
                    self.skillsArray[1] = skill2 ?? ""
                    user.updateData(["skills": self.skillsArray])
                }
                let skill3 = self.skill3TF.text
                if skill3 != "" {
                    self.skillsArray[2] = skill3 ?? ""
                    user.updateData(["skills": self.skillsArray])
                }
                let skill4 = self.skill4TF.text
                if skill4 != "" {
                    self.skillsArray[3] = skill4 ?? ""
                    user.updateData(["skills": self.skillsArray])
                }
                let skill5 = self.skill5TF.text
                if skill5 != "" {
                    self.skillsArray[4] = skill5 ?? ""
                    user.updateData(["skills": self.skillsArray])
                }
            } else {
                print("Skills data does not exist")
            }
        }
        
        let fullname = fullnameTF.text
        if fullname != "" {
            user.updateData(["fullName": fullname])
        }
        let university = universityTF.text
        if university != "" {
            user.updateData(["university": university])
        }
        let city = cityTF.text
        if city != "" {
            user.updateData(["city": city])
        }
        let major = majorTF.text
        if major != "" {
            user.updateData(["major": major])
        }
        let year = yearTF.text
        if year != "" {
            user.updateData(["year": year])
        }
        let age = ageTF.text
        if age != "" {
            user.updateData(["age": age])
        }
        let bio = bioTF.text
        if bio != "" {
            user.updateData(["bio": bio])
        }
        let linkedInURL = linkedInTF.text
        if linkedInURL != "" {
            user.updateData(["linkedInURL": linkedInURL])
        }
        let instaURL = instaTF.text
        if instaURL != "" {
            user.updateData(["instaURL": instaURL])
        }
        let fbURL = fbTF.text
        if fbURL != "" {
            user.updateData(["fbURL": fbURL])
        }
        
        resign()
    }
    
    func resign() {
        fullnameTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        universityTF.resignFirstResponder()
        yearTF.resignFirstResponder()
        majorTF.resignFirstResponder()
        cityTF.resignFirstResponder()
        bioTF.resignFirstResponder()
        skill1TF.resignFirstResponder()
        skill2TF.resignFirstResponder()
        skill3TF.resignFirstResponder()
        skill4TF.resignFirstResponder()
        skill5TF.resignFirstResponder()
        linkedInTF.resignFirstResponder()
        instaTF.resignFirstResponder()
        fbTF.resignFirstResponder()
    }
    
    func styling() {
        updateButton.layer.borderColor = UIColor.black.cgColor
        updateButton.layer.cornerRadius = 5
        updateButton.layer.borderWidth = 1
        updateButton.layer.cornerCurve = .continuous
    }
    
}
