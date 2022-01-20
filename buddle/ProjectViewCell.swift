//
//  ProjectViewCell.swift
//  buddle
//
//  Created by Vu Quang Huy on 22/11/2021.
//

import UIKit
import Firebase

class ProjectViewCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentCellView: UIView!
    
    
    static let identifier = "ProjectViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProjectViewCell", bundle: nil)
    }
    
    public func configure(with name: String, overview: String, imagePath: String) {
        projectImage.layer.cornerRadius = 15
        projectImage.layer.cornerCurve = .continuous
        
        let path = "images/" + imagePath
        
        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                self.downloadImage(imageView: self.projectImage, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        nameLabel.text = name
        descriptionLabel.text = overview
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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
