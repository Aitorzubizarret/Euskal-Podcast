//
//  SmallListItemTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-20.
//

import UIKit

class SmallListItemTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chevronIconImageView: UIImageView!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    enum ItemTypes {
        case channels
        case searches
    }
    
    var itemType: ItemTypes? {
        didSet {
            guard let itemType = itemType else { return }
            
            switch itemType {
            case .channels:
                iconImageView.image = UIImage(systemName: "antenna.radiowaves.left.and.right")
                titleLabel.text = "Podcast Iturriak"
            case .searches:
                iconImageView.image = UIImage(systemName: "magnifyingglass")
                titleLabel.text = "Bestelakoa"
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
    
    private func setupView() {
        selectionStyle = .none
        
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
}
