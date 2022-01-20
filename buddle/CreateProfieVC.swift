//
//  CreateProfieVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 21/11/2021.
//

import UIKit
import Firebase

class CreateProfieVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // IB Outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var bioTV: UITextView!
    @IBOutlet weak var skill1TF: UITextField!
    @IBOutlet weak var skill2TF: UITextField!
    @IBOutlet weak var skill3TF: UITextField!
    @IBOutlet weak var skill4TF: UITextField!
    @IBOutlet weak var skill5TF: UITextField!
    @IBOutlet weak var linkedInTF: UITextField!
    @IBOutlet weak var instaTF: UITextField!
    @IBOutlet weak var fbTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styling()
        enableSubmitButton(enabled: false)
        
        skill1TF.delegate = self
        skill2TF.delegate = self
        skill3TF.delegate = self
        skill4TF.delegate = self
        skill5TF.delegate = self
        bioTV.delegate = self
        linkedInTF.delegate = self
        instaTF.delegate = self
        fbTF.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        avatar.addGestureRecognizer(tapGR)
        avatar.isUserInteractionEnabled = true
        
        skill1TF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        skill2TF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        skill3TF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        skill4TF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        skill5TF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        linkedInTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        instaTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        fbTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // immediately make fullNameTF first responder
        bioTV.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // resign first responder fo all text fields
        bioTV.resignFirstResponder()
        skill1TF.resignFirstResponder()
        skill2TF.resignFirstResponder()
        skill3TF.resignFirstResponder()
        skill4TF.resignFirstResponder()
        skill5TF.resignFirstResponder()
        linkedInTF.resignFirstResponder()
        instaTF.resignFirstResponder()
        fbTF.resignFirstResponder()
    }
    
    override var disablesAutomaticKeyboardDismissal: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backgroundTouched(_ sender: Any) {
        bioTV.resignFirstResponder()
        skill1TF.resignFirstResponder()
        skill2TF.resignFirstResponder()
        skill3TF.resignFirstResponder()
        skill4TF.resignFirstResponder()
        skill5TF.resignFirstResponder()
        linkedInTF.resignFirstResponder()
        instaTF.resignFirstResponder()
        fbTF.resignFirstResponder()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        switchToCreateAccountVC()
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            pickPhoto()
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        handleSubmit()
    }
    
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in self.takePhotoWithCamera() })
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in self.choosePhotoFromLibrary() })
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        avatar.image = newImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("Cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool {
        
        if string == "\n" {  // the same as tapping the next button
            bioTV.resignFirstResponder()
            skill1TF.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        // if return fullName text field, go to email university field
        case skill1TF:
            skill1TF.resignFirstResponder()
            skill2TF.becomeFirstResponder()
            break
        // if return age text field, go to email university field
        case skill2TF:
            skill2TF.resignFirstResponder()
            skill3TF.becomeFirstResponder()
            break
        // if return university text field, go to year text field
        case skill3TF:
            skill3TF.resignFirstResponder()
            skill4TF.becomeFirstResponder()
            break
        // if return year text field, go to major text field
        case skill4TF:
            skill4TF.resignFirstResponder()
            skill5TF.becomeFirstResponder()
            break
        // if return major text field, go to password text field
        case skill5TF:
            skill5TF.resignFirstResponder()
            linkedInTF.becomeFirstResponder()
            break
        // if return major text field, go to password text field
        case linkedInTF:
            linkedInTF.resignFirstResponder()
            instaTF.becomeFirstResponder()
            break
        case instaTF:
            instaTF.resignFirstResponder()
            fbTF.becomeFirstResponder()
            break;
        case fbTF:
            fbTF.resignFirstResponder()
            break;
        default:
            break
        }
        return true
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        // check if form is filled (bool)
        let formFilled = skill1TF.text != "" && skill2TF.text != "" && skill3TF.text != "" && skill3TF.text != "" && skill4TF.text != "" && skill5TF.text != "" && linkedInTF.text != "" && instaTF.text != "" && fbTF.text != ""
        
        // enable sign up if form is filled
        enableSubmitButton(enabled: formFilled)
    }
    
    func styling() {
        avatar.layer.cornerRadius = avatar.layer.bounds.width/2
        avatar.clipsToBounds = true
        
        bioTV.layer.cornerRadius = 15
        bioTV.layer.borderWidth = 1
        bioTV.layer.cornerCurve = .continuous
        
        submitButton.layer.cornerRadius = 20
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerCurve = .continuous
    }
    
    func enableSubmitButton(enabled:Bool) {
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
    
    @objc func handleSubmit() {
        print("Submit Tapped!")
        
        guard let bio = bioTV.text else { return }
        guard let skill1 = skill1TF.text else { return }
        guard let skill2 = skill2TF.text else { return }
        guard let skill3 = skill3TF.text else { return }
        guard let skill4 = skill4TF.text else { return }
        guard let skill5 = skill5TF.text else { return }
        guard let linkedInURL = linkedInTF.text else { return }
        guard let instaURL = instaTF.text else { return }
        guard let fbURL = fbTF.text else { return }
        
        var skillArray = [String] ()
        skillArray.append(skill1)
        skillArray.append(skill2)
        skillArray.append(skill3)
        skillArray.append(skill4)
        skillArray.append(skill5)
        
        
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let currentUID = currentUser?.uid as! String
        let curUser = db.collection("users").document(currentUID)
        
        // Get user email
        let userEmail = currentUser?.email as! String
        let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        let profilePictureFilename = "\(safeEmail)_profile_picture.png"
        
        
        // Upload profile picture to Firebase storage
        guard let avatar = self.avatar.image, let data = avatar.pngData() else {
            return
        }
        let fileName = profilePictureFilename
        StorageManager.shared.uploadProfilePicture(with: data, filename: fileName, completion: { result in
            switch result {
            case .success(let downloadUrl):
                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                print("download_URL: \(downloadUrl)")
            case .failure(let error):
                print("Storage manager error: \(error)")
            }
        })
        
        curUser.updateData([
            "bio": bio,
            "skills": skillArray,
            "linkedInURL": linkedInURL,
            "instaURL": instaURL,
            "fbURL": fbURL,
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        bioTV.resignFirstResponder()
        skill1TF.resignFirstResponder()
        skill2TF.resignFirstResponder()
        skill3TF.resignFirstResponder()
        skill4TF.resignFirstResponder()
        skill5TF.resignFirstResponder()
        linkedInTF.resignFirstResponder()
        instaTF.resignFirstResponder()
        fbTF.resignFirstResponder()
        
        self.switchToHomeVC()
    }
    
    func switchToCreateAccountVC() {
        let createAccountVC = self.storyboard?.instantiateViewController(identifier: "CreateAccountVC") as? CreateAccountVC
        self.view.window?.rootViewController = createAccountVC
        self.view.window?.makeKeyAndVisible()
    }
    
    func switchToHomeVC() {
        let homeVC = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
        self.view.window?.rootViewController = homeVC
        self.view.window?.makeKeyAndVisible()
    }
    
}
