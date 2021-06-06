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
            guard let receivedProgram = self.program else { return }
            
            self.titleLabel.text = receivedProgram.name
            self.descriptionLabel.text = receivedProgram.seasons.count == 1 ? "Denboraldi bat" : receivedProgram.seasons.count > 0 ? "\(receivedProgram.seasons.count) denboraldi" : "Denboraldirik gabe"
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        // ImageView.
        self.photoImageView.layer.cornerRadius = 6
    }
}
