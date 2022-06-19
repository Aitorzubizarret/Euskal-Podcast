//
//  ProgramCollectionViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 16/05/2021.
//

import UIKit

class ProgramCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var program: Program? {
        didSet {
            guard let receivedProgram = program else { return }
            
            titleLabel.text = receivedProgram.Name
            switch receivedProgram.Seasons.count {
            case 0:
                descriptionLabel.text = "Denboraldirik gabe"
            case 1:
                descriptionLabel.text = "Denboraldi bat"
            default:
                descriptionLabel.text = "\(receivedProgram.Seasons.count) denboraldi"
            }
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        // ImageView.
        photoImageView.layer.cornerRadius = 6
    }
}
