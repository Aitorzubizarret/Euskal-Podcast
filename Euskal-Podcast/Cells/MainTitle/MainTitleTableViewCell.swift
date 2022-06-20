//
//  MainTitleTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 19/6/22.
//

import UIKit
import Kingfisher

class MainTitleTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backgroundImageImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    public var titleName: String = "" {
        didSet {
            nameLabel.text = titleName
        }
    }
    public var imageURL: String = "" {
        didSet {
            guard let safeImageURL: URL = URL(string: imageURL) else { return }
            
            backgroundImageImageView.kf.setImage(with: safeImageURL)
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
    
    private func setupView() {
        // Cell
        selectionStyle = .none
        
        // ImageView.
        bottomLineImageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
}
