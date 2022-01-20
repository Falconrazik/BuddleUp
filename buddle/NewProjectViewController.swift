//
//  NewProjectViewController.swift
//  buddle
//
//  Created by Vu Quang Huy on 21/11/2021.
//

import UIKit
import Firebase

class NewProjectViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // IBOutlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var overviewTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var role1TF: UITextField!
    @IBOutlet weak var role1DescriptionTF: UITextField!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var roleExperienceTF: UITextField!
    
    // variables
    let projectModel = ProjectModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Styling
        styling()
        
        enablePostButton(enabled: false)
        
        nameTF.delegate = self
        overviewTF.delegate = self
        descriptionTV.delegate = self
        role1TF.delegate = self
        role1DescriptionTF.delegate = self
        roleExperienceTF.delegate = self
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        projectImage.addGestureRecognizer(tapGR)
        projectImage.isUserInteractionEnabled = true
        
        nameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        overviewTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        role1TF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        role1DescriptionTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        roleExperienceTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // immediately make fullNameTF first responder
        nameTF.becomeFirstResponder()
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
        projectImage.image = newImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            pickPhoto()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("Cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        case nameTF:
            nameTF.resignFirstResponder()
            break
        case overviewTF:
            overviewTF.resignFirstResponder()
            break
        case role1TF:
            role1TF.resignFirstResponder()
            break
        case roleExperienceTF:
            roleExperienceTF.resignFirstResponder()
            break
        case role1DescriptionTF:
            role1DescriptionTF.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func enablePostButton(enabled:Bool) {
        // if enabled
        if enabled {
            // if sign up button is enabled
            // set alpha too 100% and set bool isEnabled to true
            postButton.tintColor = UIColor.black.withAlphaComponent(1)
            postButton.isEnabled = true
        } else {
            // else if sign up button is disabled
            // reduce alpha and set bool isEnabled to false
            postButton.tintColor = UIColor.black.withAlphaComponent(0.7)
            postButton.isEnabled = false
        }
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        // check if form is filled (bool)
        let formFilled = nameTF.text != "" && overviewTF.text != "" && role1TF.text != "" && role1DescriptionTF.text != "" && roleExperienceTF.text != ""
        
        // enable sign up if form is filled
        enablePostButton(enabled: formFilled)
    }
    
    // disable automatic keyboard dismissal
    override var disablesAutomaticKeyboardDismissal: Bool {
        return false
    }
    
    @IBAction func backgroundTouched(_ sender: Any) {
        nameTF.resignFirstResponder()
        overviewTF.becomeFirstResponder()
        descriptionTV.becomeFirstResponder()
        role1TF.resignFirstResponder()
        roleExperienceTF.becomeFirstResponder()
        role1DescriptionTF.becomeFirstResponder()
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        handlePost()
        self.navigationController?.popViewController(animated: true)
    }
    
    func handlePost() {
        guard let name = nameTF.text else { return }
        guard let overview = overviewTF.text else { return }
        guard let description = descriptionTV.text else { return }
        guard let role = role1TF.text else { return }
        guard let experience = roleExperienceTF.text else { return }
        guard let roleDescription = role1DescriptionTF.text else { return }
        
        let safeImagePath = DatabaseManager.generateImageName()
        let imagePath = "\(safeImagePath)_project_picture.png"
        
        
        // Upload profile picture to Firebase storage
        guard let projectImage = self.projectImage.image, let data = projectImage.pngData() else {
            return
        }
        StorageManager.shared.uploadProfilePicture(with: data, filename: imagePath, completion: { result in
            switch result {
            case .success(let downloadUrl):
                UserDefaults.standard.set(downloadUrl, forKey: "project_picture_url")
            case .failure(let error):
                print("Storage manager error: \(error)")
            }
        })
        
        let projectUID = DatabaseManager.generateImageName()
        print("Project ID: \(projectUID)")
        
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let userUID = currentUser?.uid as! String
        let user = db.collection("users").document(userUID)
        
        var projectData = [String]()
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Project Data
                projectData = document.get("project") as! [String]
                // Add new project to user's project data
                projectData.append(projectUID)
                user.updateData(["project": projectData])
            } else {
                print("Project Data does not exist")
            }
        }
        
        let request = [String]()
        
        db.collection("projects").document(projectUID).setData([
            "uid": projectUID,
            "name": name,
            "overview": overview,
            "description": description,
            "role": role,
            "role_experience": experience,
            "role_description": roleDescription,
            "image_path": imagePath,
            "created_by": userUID,
            "request": request
        ])
        
    }
    
    func styling() {
        descriptionTV.layer.cornerRadius = 10
        descriptionTV.layer.cornerCurve = .continuous
        
        projectImage.layer.cornerRadius = 15
        projectImage.layer.cornerCurve = .continuous
        projectImage.layer.borderWidth = 1
    }
}
