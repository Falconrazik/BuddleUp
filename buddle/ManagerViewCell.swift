//
//  ManagerViewCell.swift
//  buddle
//
//  Created by Vu Quang Huy on 22/11/2021.
//

import UIKit
import Firebase

class ManagerViewCell: UITableViewCell {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "ManagerViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ManagerViewCell", bundle: nil)
    }
    
    public func configure(with name: String, owner: String) {
        styling()
        
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        let userUID = currentUser?.uid as! String
        let user = db.collection("users").document(owner)
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get User Project Data
                let ownerName = document.get("fullName") as! String
                self.createdByLabel.text = "By \(ownerName)"
            } else {
                print("Project Data does not exist")
            }
        }
        
        nameLabel.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8))
    }
    
    func styling() {
        background.layer.cornerRadius = 20
        background.layer.cornerCurve = .continuous
        
    }

}
