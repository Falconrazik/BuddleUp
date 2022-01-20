//
//  ProjectDetailVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 22/11/2021.
//

import UIKit
import Firebase

class ProjectDetailVC: UIViewController {

    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var projectDescriptonLabel: UILabel!
    @IBOutlet weak var roleDescriptionLabel: UILabel!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    
    // Variables
    var name = String()
    var role = String()
    var experience = String()
    var roleDescription = String()
    var overview = String()
    var projectDescription = String()
    var linkedInURL = String()
    var email = String()
    var fbURL = String()
    var imagePath = String()
    var request = [String]()
    var projectUID = String()
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styling()
        loadData()
        // Check if user has registered or not
        enableRequestButton()
        
        self.title = "Project Detail"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Num Request: \(request.count)")
        loadData()
    }
    
    @IBAction func linkedInButtonPressed(_ sender: Any) {
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func fbButtonPressed(_ sender: Any) {
    }
    
    @IBAction func requestButtonPressed(_ sender: Any) {
        let userUID = self.currentUser?.uid as! String
        let project = db.collection("projects").document(projectUID)
        request.append(userUID)
        
        project.getDocument { (document, error) in
            if let document = document, document.exists {
                project.updateData(["request": self.request])
                self.requestButton.isEnabled = false
                self.requestButton.alpha = 0.5
            } else {
                print("Project Data does not exist")
            }
        }
    }
    
    func loadData() {
        nameLabel.text = name
        roleLabel.text = role
        experienceLabel.text = experience
        overviewLabel.text = overview
        projectDescriptonLabel.text = projectDescription
        roleDescriptionLabel.text = roleDescription
        
        let path = "images/" + imagePath
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.downloadImage(imageView: self.projectImage, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.projectImage.image = image
            }
        }).resume()
    }
    
    func enableRequestButton() {
        let userUID = self.currentUser?.uid as! String
        // Check if user has already requested to join the project
        let user = db.collection("users").document(userUID)
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Data
                let userProject = document.get("project") as! [String]
                if !self.request.contains(userUID) && !userProject.contains(self.projectUID) {
                    self.requestButton.alpha = 1
                    self.requestButton.isEnabled = true
                }
                else {
                    self.requestButton.alpha = 0
                    self.requestButton.isEnabled = false
                }
            } else {
                print("Data does not exist")
            }
        }
    }
    
    func styling() {
        requestButton.layer.cornerRadius = 25
        requestButton.layer.cornerCurve = .continuous
        requestButton.layer.shadowColor = UIColor.darkGray.cgColor
        requestButton.layer.shadowOpacity = 0.5
        requestButton.layer.shadowRadius = 5.0
        
        roleView.layer.cornerRadius = 10
        roleView.layer.cornerCurve = .continuous
        roleView.layer.borderWidth = 1
        
        projectImage.layer.cornerRadius = 20
        projectImage.layer.cornerCurve = .continuous
        projectImage.clipsToBounds = true
    }

}
