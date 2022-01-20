//
//  ManagerDetailVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 23/11/2021.
//

import UIKit
import Firebase

class ManagerDetailVC: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    @IBOutlet weak var roleDescriptionLabel: UILabel!
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var viewRequestButton: UIButton!
    @IBOutlet weak var projectImage: UIImageView!
    
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
    var createdBy = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styling()
        loadData()
        enableViewRequestButton()
        
        self.title = "Project Manager"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let db = Firestore.firestore()
        let project = db.collection("projects").document(projectUID)
        project.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Project Data
                self.request = document.get("request") as! [String]
                print("viewWillAppearCalled")
                self.enableViewRequestButton()
            } else {
                print("Request does not exist")
            }
        }
        loadData()
        enableViewRequestButton()
    }
    
    @IBAction func viewRequestButtonPressed(_ sender: Any) {
        
        RequestVC.request = request
        RequestVC.projectUID = projectUID
        
        performSegue(withIdentifier: "RequestVC", sender: sender)
    }
    
    func loadData() {
        nameLabel.text = name
        roleLabel.text = role
        experienceLabel.text = experience
        overviewLabel.text = overview
        projectDescriptionLabel.text = projectDescription
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
    
    func enableViewRequestButton() {
        // Check if user has already requested to join the project
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let UID = currentUser?.uid as! String
        
        if UID == createdBy {
            if request.count > 0 {
                viewRequestButton.alpha = 1
                viewRequestButton.isEnabled = true
            }
            else {
                viewRequestButton.alpha = 0.5
                viewRequestButton.isEnabled = false
            }
        }
        else {
            viewRequestButton.alpha = 0
            viewRequestButton.isEnabled = false
        }
        
    }
    
    func styling() {
        viewRequestButton.layer.cornerRadius = 25
        viewRequestButton.layer.cornerCurve = .continuous
        viewRequestButton.layer.shadowColor = UIColor.darkGray.cgColor
        viewRequestButton.layer.shadowOpacity = 0.5
        viewRequestButton.layer.shadowRadius = 5.0
        
        roleView.layer.cornerRadius = 10
        roleView.layer.cornerCurve = .continuous
        roleView.layer.borderWidth = 1
        
        projectImage.layer.cornerRadius = 20
        projectImage.layer.cornerCurve = .continuous
        projectImage.clipsToBounds = true
    }

}
