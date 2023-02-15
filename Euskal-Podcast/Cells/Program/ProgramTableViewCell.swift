//
//  ProgramTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 13/05/2021.
//

import UIKit

class ProgramTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var iconURL: String = "" {
        didSet {
            if let iconURL: URL = URL(string: iconURL) {
                photoImageView.kf.setImage(with: iconURL)
            }
        }
    }
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    var descriptionText: String = "" {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    var authorText: String = "" {
        didSet {
            authorLabel.text = authorText
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.selectionStyle = .none
        
        // ImageView.
        photoImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        photoImageView.layer.cornerRadius = 4
        
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
}
