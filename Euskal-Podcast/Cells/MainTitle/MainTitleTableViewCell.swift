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
            
            backgroundImageImageView.layer.shadowColor = UIColor.black.cgColor
            backgroundImageImageView.layer.shadowOpacity = 0.2
            backgroundImageImageView.layer.shadowRadius = 4
            backgroundImageImageView.layer.shadowOffset = CGSize(width: 0, height: 8)
            backgroundImageImageView.layer.masksToBounds = false
            
            setupMainViewBacgroundGradient()
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
        backgroundImageImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        backgroundImageImageView.layer.cornerRadius = 4
        
        backgroundImageImageView.layer.borderWidth = 1
        backgroundImageImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    private func setupMainViewBacgroundGradient() {
        // Gradient background for the main view.
        let colorTop = UIColor.template.lightPurple.cgColor
        let colorBottom = UIColor.template.darkPurple.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        mainView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
