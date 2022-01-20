//
//  RequestViewCell.swift
//  buddle
//
//  Created by Vu Quang Huy on 23/11/2021.
//

import UIKit
import Firebase

class RequestViewCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    static let identifier = "RequestViewCell"
    
    static var userUID = String()
    static var projectUID = String()
    
    let db = Firestore.firestore()
    
    static func nib() -> UINib {
        return UINib(nibName: "RequestViewCell", bundle: nil)
    }
    
    public func configure(name: String, university: String, major: String, year: String, email: String) {
        styling()
        
        nameLabel.text = name
        universityLabel.text = university
        majorLabel.text = major
        yearLabel.text = year
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        
        let path = "images/" + filename
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.downloadImage(imageView: self.avatarImage, url: url)
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
                self.avatarImage.image = image
            }
        }).resume()
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
        
        avatarImage.layer.cornerRadius = avatarImage.layer.bounds.width / 2
        avatarImage.clipsToBounds = true
    }
    
}
