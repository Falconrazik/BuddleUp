//
//  HomePageViewController.swift
//  buddle
//
//  Created by Vu Quang Huy on 15/11/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class CandidateVC: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    @IBOutlet weak var skill1View: UIView!
    @IBOutlet weak var skill2View: UIView!
    @IBOutlet weak var skill3View: UIView!
    @IBOutlet weak var skill4View: UIView!
    @IBOutlet weak var skill5View: UIView!
    
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var skill1Label: UILabel!
    @IBOutlet weak var skill2Label: UILabel!
    @IBOutlet weak var skill3Label: UILabel!
    @IBOutlet weak var skill4Label: UILabel!
    @IBOutlet weak var skill5Label: UILabel!
    
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    
    // Sliding effects
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayRightOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    // User data variables
    var fullname:String = ""
    var university:String = ""
    var city:String = ""
    var major:String = ""
    var year:String = ""
    var skills = [String] ()
    var nameInfo:String = ""
    var age:String = ""
    var bio: String = ""
    var linkedInURL = ""
    var instaURL = ""
    var fbURL = ""
    
    // Variables
    var userUID = String()
    var projectUID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = ""
        self.universityLabel.text = ""
        self.majorLabel.text = ""
        self.yearLabel.text = ""
        getUserData()
 
        // Styling
        styling()
        enableAcceptButton()
        
        // Sliding effects
        trayDownOffset = -350
        trayRightOffset = 7
        trayOriginalCenter = infoView.center
        trayUp = CGPoint(x: infoView.center.x + trayRightOffset, y: infoView.center.y + trayDownOffset)
        trayDown = CGPoint(x: infoView.center.x + trayRightOffset, y: trayOriginalCenter.y)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        enableAcceptButton()
        getUserData()
    }
    
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let project = db.collection("projects").document(self.projectUID)
        var request = [String]()
        
        project.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Project Data
                request = document.get("request") as! [String]
                // Add new project to user's project data
                if let index = request.firstIndex(of: self.userUID) {
                    request.remove(at: index)
                }
                project.updateData(["request": request])
            } else {
                print("Request does not exist")
            }
        }
        
        let user = db.collection("users").document(self.userUID)
        var userProject = [String]()
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User My Project Data
                userProject = document.get("project") as! [String]
                // Add new project to user's project data
                userProject.append(self.projectUID)
                user.updateData(["project": userProject])
            } else {
                print("My Project does not exist")
            }
        }

        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func enableAcceptButton() {
        let db = Firestore.firestore()
        let project = db.collection("projects").document(self.projectUID)
        var request = [String]()
        
        project.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Project Data
                request = document.get("request") as! [String]
                if request.contains(self.userUID) {
                    self.acceptButton.isEnabled = true
                    self.acceptButton.alpha = 1
                }
                else {
                    self.acceptButton.isEnabled = false
                    self.acceptButton.alpha = 0.5
                }
                project.updateData(["request": request])
            } else {
                print("Request does not exist")
            }
        }
    }
    
    func getUserData() {
        let db = Firestore.firestore()
        let user = db.collection("users").document(userUID)
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Data
                let userEmail = document.get("email") as! String
                let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
                let filename = safeEmail + "_profile_picture.png"
                
                let path = "images/" + filename
                
                StorageManager.shared.downloadURL(for: path, completion: { result in
                    switch result {
                    case .success(let url):
                        self.downloadImage(imageView: self.coverImage, url: url)
                    case .failure(let error):
                        print("Failed to get download url: \(error)")
                    }
                })
            } else {
                print("Data does not exist")
            }
        }
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Data
                self.fullname = document.get("fullName") as! String
                self.university = document.get("university") as! String
                self.city = document.get("city") as! String
                self.major = document.get("major") as! String
                self.year = document.get("year") as! String
                self.age = document.get("age") as! String
                self.bio = document.get("bio") as! String
                self.skills = document.get("skills") as! [String]
                self.linkedInURL = document.get("linkedInURL") as! String
                self.instaURL = document.get("instaURL") as! String
                self.fbURL = document.get("fbURL") as! String
                
                // Assign User data
                self.nameLabel.text = self.fullname
                self.universityLabel.text = self.university
                self.cityLabel.text = self.city
                self.majorLabel.text = self.major
                self.yearLabel.text = self.year
                self.nameInfoLabel.text = "\(self.fullname), \(self.age)"
                self.bioLabel.text = self.bio
                self.skill1Label.text = self.skills[0]
                self.skill2Label.text = self.skills[1]
                self.skill3Label.text = self.skills[2]
                self.skill4Label.text = self.skills[3]
                self.skill5Label.text = self.skills[4]
                
            } else {
                print("Data does not exist")
            }
        }
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.coverImage.image = image
            }
        }).resume()
    }
    
    
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        var translation = sender.translation(in: view)
        var velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizer.State.began {
            trayOriginalCenter = infoView.center
        }
        else if sender.state == UIGestureRecognizer.State.changed {
            infoView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == UIGestureRecognizer.State.ended {
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.infoView.center = self.trayDown
               })
            } else {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.infoView.center = self.trayUp
               })
            }
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        switchToRequestVC()
    }
    
    func switchToRequestVC() {
        let requestVC = self.storyboard?.instantiateViewController(identifier: "RequestVC") as? RequestVC
        self.view.window?.rootViewController = requestVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func linkedInButtonPressed(_ sender: Any) {
        guard let url = URL(string: linkedInURL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func fbButtonPressed(_ sender: Any) {
        guard let url = URL(string: fbURL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func instaButtonPressed(_ sender: Any) {
        guard let url = URL(string: instaURL) else { return }
        UIApplication.shared.open(url)
    }
    

    func styling() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        acceptButton.layer.cornerRadius = 25
        acceptButton.layer.cornerCurve = .continuous
        acceptButton.layer.shadowColor = UIColor.darkGray.cgColor
        acceptButton.layer.shadowOpacity = 0.5
        acceptButton.layer.shadowRadius = 5.0
        
        infoView.layer.cornerRadius = 45
        infoView.layer.borderWidth = 1
        infoView.layer.cornerCurve = .continuous
        
        majorLabel.layer.cornerRadius = 20
        majorLabel.layer.borderWidth = 1
        majorLabel.layer.cornerCurve = .continuous
        
        yearLabel.layer.cornerRadius = 20
        yearLabel.layer.borderWidth = 1
        yearLabel.layer.cornerCurve = .continuous
        
        skill1View.layer.cornerRadius = skill1View.layer.bounds.width / 2
        skill1View.clipsToBounds = true
        
        skill2View.layer.cornerRadius = skill2View.layer.bounds.width / 2
        skill2View.clipsToBounds = true
        
        skill3View.layer.cornerRadius = skill3View.layer.bounds.width / 2
        skill3View.clipsToBounds = true
        
        skill4View.layer.cornerRadius = skill4View.layer.bounds.width / 2
        skill4View.clipsToBounds = true
        
        skill5View.layer.cornerRadius = skill5View.layer.bounds.width / 2
        skill5View.clipsToBounds = true
    }
    
}
