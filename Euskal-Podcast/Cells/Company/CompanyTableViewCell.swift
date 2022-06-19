//
//  CompanyTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 13/05/2021.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    var company: Company? {
        didSet {
            guard let receivedCompany = company else { return }
            
            nameLabel.text = receivedCompany.Name
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
        logoImageView.backgroundColor = UIColor.blue
    }
}
