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
        case played
    }
    
    var itemType: ItemTypes? {
        didSet {
            guard let itemType = itemType else { return }
            
            switch itemType {
            case .channels:
                iconImageView.image = UIImage(systemName: "antenna.radiowaves.left.and.right")
                titleLabel.text = "Podcast Iturriak"
            case .played:
                iconImageView.image = UIImage(systemName: "play")
                titleLabel.text = "Entzundako Podcast Atalak"
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
