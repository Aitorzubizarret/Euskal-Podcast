//
//  MainTitleTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 19/6/22.
//

import UIKit
import Kingfisher

protocol MainTitleCellDelegate {
    func follow()
    func unfollow()
}

class MainTitleTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backgroundImageImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followUnfollowButton: UIButton!
    @IBAction func followUnfollowButtonTapped(_ sender: Any) {
        followUnfollowAction()
    }
    @IBOutlet weak var separatorImageView: UIImageView!
    @IBOutlet weak var episodesInfoLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var imageURL: String = "" {
        didSet {
            guard let safeImageURL: URL = URL(string: imageURL) else { return }
            
            backgroundImageImageView.kf.setImage(with: safeImageURL)
        }
    }
    var titleName: String = "" {
        didSet {
            nameLabel.text = titleName
        }
    }
    var descriptionText: String = "" {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    var isFollowing: Bool = false {
        didSet {
            if isFollowing {
                followUnfollowButton.setTitle("Jarraitzen", for: .normal)
                
                let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .small)
                followUnfollowButton.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: config), for: .normal)
                followUnfollowButton.imageView?.tintColor = UIColor.template.purple
            } else {
                followUnfollowButton.setTitle("Jarraitu", for: .normal)
                
                let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .small)
                followUnfollowButton.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
                followUnfollowButton.imageView?.tintColor = UIColor.template.purple
            }
        }
    }
    var episodesInfo: String = "" {
        didSet {
            episodesInfoLabel.text = episodesInfo
        }
    }
    var delegate: MainTitleCellDelegate?
    
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
        
        // Button.
        followUnfollowButton.layer.cornerRadius = 10 // 17
        followUnfollowButton.layer.backgroundColor = UIColor.template.purple.withAlphaComponent(0.2).cgColor
        followUnfollowButton.setTitleColor(UIColor.template.purple, for: .normal)
        
        // ImageView.
        backgroundImageImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        backgroundImageImageView.layer.borderWidth = 1
        backgroundImageImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        backgroundImageImageView.layer.masksToBounds = false
        
        backgroundImageImageView.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        backgroundImageImageView.layer.shadowColor = UIColor.gray.cgColor
        backgroundImageImageView.layer.shadowRadius = 4
        backgroundImageImageView.layer.shadowOpacity = 0.5
        
        separatorImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    private func followUnfollowAction() {
        guard let delegate = delegate else { return }
        
        if isFollowing {
            delegate.unfollow()
        } else {
            delegate.follow()
        }
    }
    
}
