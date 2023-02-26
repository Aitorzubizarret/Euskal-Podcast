//
//  ChannelTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-20.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlAddressLabel: UILabel!
    @IBOutlet weak var downloadStatusLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var nameText: String = "" {
        didSet {
            nameLabel.text = nameText
        }
    }
    var urlAddressText: String = "" {
        didSet {
            urlAddressLabel.text = urlAddressText
        }
    }
    var downloadStatus: String = "" {
        didSet {
            downloadStatusLabel.text = downloadStatus
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
        self.selectionStyle = .none
        
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
}
