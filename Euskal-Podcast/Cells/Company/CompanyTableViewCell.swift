//
//  CompanyTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 13/05/2021.
//

import UIKit
import Kingfisher

class CompanyTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    var company: Company? {
        didSet {
            guard let receivedCompany = company else { return }
            
            // Label.
            nameLabel.text = receivedCompany.Title
            
            // Image.
            for url in receivedCompany.URLs {
                if url.Name == "Icon",
                   let safeUrl: URL = URL(string: url.URL) {
                    logoImageView.kf.setImage(with: safeUrl)
                }
            }
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
        // Cell.
        selectionStyle = .none
        
        // ImageView.
        logoImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        logoImageView.layer.cornerRadius = 4
        
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
}
