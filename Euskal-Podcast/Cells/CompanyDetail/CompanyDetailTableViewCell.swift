//
//  CompanyDetailTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 15/06/2021.
//

import UIKit

class CompanyDetailTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    // MARK: - Properties
    
    var company: Company? {
        didSet {
            guard let receivedCompany = self.company else { return }
            
            self.companyNameLabel.text = receivedCompany.name
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {}
}
