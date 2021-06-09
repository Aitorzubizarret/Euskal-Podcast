//
//  ProgramTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 13/05/2021.
//

import UIKit

class ProgramTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    var program: Program? {
        didSet {
            guard let receivedProgram = self.program else { return }
            
            self.titleLabel.text = receivedProgram.name
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
