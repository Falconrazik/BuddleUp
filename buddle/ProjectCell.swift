//
//  ProjectCell.swift
//  buddle
//
//  Created by Vu Quang Huy on 21/11/2021.
//

import UIKit

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectOverview: UILabel!

    
    func populate(with project: Project) {
        projectLabel.text = project.title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
