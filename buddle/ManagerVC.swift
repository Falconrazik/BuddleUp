//
//  ManagerVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 22/11/2021.
//

import UIKit
import Firebase

class ManagerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // variables
    var projectArray = [Project] ()
    var projectList = [String]()
    let cellSpacingHeight: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
        
        projectArray.removeAll()
        
        self.tableView.separatorColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        projectArray.removeAll()
        loadData()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerViewCell", for: indexPath) as! ManagerViewCell
        
        let project = projectArray[indexPath.row]
        let name = project.getName()
        let owner = project.getOwner()
        

        cell.configure(with: name, owner: owner)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = self.storyboard?.instantiateViewController(identifier: "ManagerDetailVC") as! ManagerDetailVC

        let project = projectArray[indexPath.row]
        vc.projectUID = project.getProjectUID()
        vc.name = project.getName()
        vc.role = project.getRole()
        vc.experience = project.getExperience()
        vc.roleDescription = project.getRoleDescription()
        vc.overview = project.getOverview()
        vc.projectDescription = project.getDescription()
        vc.imagePath = project.getImagePath()
        vc.request = project.getRequest()
        vc.createdBy = project.getOwner()

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func setupTableView() {
        tableView.register(ManagerViewCell.nib(), forCellReuseIdentifier: ManagerViewCell.identifier)
    }
    
    func loadData() {
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let userUID = currentUser?.uid as! String
        let user = db.collection("users").document(userUID)

        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Project Data
                self.projectList = document.get("project") as! [String]
                db.collection("projects").getDocuments() { (QuerySnapshot, err) in
                    if let err = err {
                        print("Error getting documents : \(err)")
                    }
                    else {
                        for document in QuerySnapshot!.documents {
                            let name = document.get("name") as! String
                            let overview = document.get("overview") as! String
                            let imagePath = document.get("image_path") as! String
                            let description = document.get("description") as! String
                            let role = document.get("role") as! String
                            let experience = document.get("role_experience") as! String
                            let roleDescription = document.get("role_description") as! String
                            let request = document.get("request") as! [String]
                            let projectUID = document.get("uid") as! String
                            let owner = document.get("created_by") as! String


                            if self.projectList.contains(projectUID) {
                                let newProject = Project(projectUID: projectUID, owner: owner, name: name, imagePath: imagePath, overview: overview, description: description, role: role, experience: experience, roleDescription: roleDescription, request: request)
                                self.projectArray.append(newProject)
                                self.projectArray.reverse()
                            }
                            else {
                                print("Failed to get project")
                            }
                        }
                        print("projectArray: \(self.projectArray.count)")
                        self.tableView.reloadData()
                    }
                }
                print("Num Project: \(self.projectList.count)")
            } else {
                print("Project Data does not exist")
            }
        }

    }
    
    
}
