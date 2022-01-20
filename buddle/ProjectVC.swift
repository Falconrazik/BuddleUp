//
//  ProjecVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 22/11/2021.
//

import UIKit
import Firebase

class ProjectVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBarView: UIView!
    
    // variables
    var projectArray = [Project] ()
    var filteredProject = [Project] ()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        styling()

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        projectArray.removeAll()
        loadData()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!filteredProject.isEmpty) {
            return filteredProject.count;
        }
        return projectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectViewCell", for: indexPath) as! ProjectViewCell
        
        if (!filteredProject.isEmpty) {
            let project = projectArray[indexPath.row]
            let name = project.getName()
            let overview = project.getOverview()
            let imagePath = project.getImagePath()

            cell.configure(with: name, overview: overview, imagePath: imagePath)
        }
        else {
            let project = projectArray[indexPath.row]
            let name = project.getName()
            let overview = project.getOverview()
            let imagePath = project.getImagePath()
            
            cell.configure(with: name, overview: overview, imagePath: imagePath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = self.storyboard?.instantiateViewController(identifier: "ProjectDetailVC") as! ProjectDetailVC
        
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
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func setupTableView() {
        tableView.register(ProjectViewCell.nib(), forCellReuseIdentifier: ProjectViewCell.identifier)
    }
    
    func filterProject(_ query: String) {
        filteredProject.removeAll()
        let db = Firestore.firestore()
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

                    let newProject = Project(projectUID: projectUID, owner: owner, name: name, imagePath: imagePath, overview: overview, description: description, role: role, experience: experience, roleDescription: roleDescription, request: request)
                    if newProject.getName().lowercased().starts(with: query.lowercased()) {
                        self.projectArray.append(newProject)
                        self.projectArray.reverse()
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text {
            if textField.text == "" {
                filteredProject.removeAll()
                projectArray.removeAll()
                loadData()
                self.tableView.reloadData()
            }
            else {
                filteredProject.removeAll()
                filterProject(text+string)
                self.tableView.reloadData()
            }

        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func loadData() {
        let db = Firestore.firestore()
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
                    
                    let newProject = Project(projectUID: projectUID, owner: owner, name: name, imagePath: imagePath, overview: overview, description: description, role: role, experience: experience, roleDescription: roleDescription, request: request)
                    self.projectArray.append(newProject)
                    self.projectArray.reverse()
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func styling() {
        searchBarView.layer.cornerRadius = 25
        searchBarView.layer.cornerCurve = .continuous
        searchBarView.layer.masksToBounds = true
        
        searchBarView.layer.borderWidth = 0.5
    }
    
}



