//
//  RequestVC.swift
//  buddle
//
//  Created by Vu Quang Huy on 23/11/2021.
//

import UIKit
import Firebase

class RequestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // variables
    static var request = [String]()
    static var projectUID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        print("Request num: \(RequestVC.request.count)")
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestVC.request.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestViewCell", for: indexPath) as! RequestViewCell
        
        let db = Firestore.firestore()
        let userUID = RequestVC.request[indexPath.row]
        let user = db.collection("users").document(userUID)
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Request Data
                let name = document.get("fullName") as! String
                let university = document.get("university") as! String
                let major = document.get("major") as! String
                let year = document.get("year") as! String
                let email = document.get("email") as! String
                cell.configure(name: name, university: university, major: major, year: year, email: email)
            } else {
                print("User Data does not exist")
            }
        }

        cell.styling()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = self.storyboard?.instantiateViewController(identifier: "CandidateVC") as! CandidateVC
        let userUID = RequestVC.request[indexPath.row]
        let projectUID = RequestVC.projectUID
        vc.userUID = userUID
        vc.projectUID = projectUID

        self.tableView.reloadData()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.register(RequestViewCell.nib(), forCellReuseIdentifier: RequestViewCell.identifier)
    }

}
