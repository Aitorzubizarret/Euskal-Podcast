//
//  SectionTitleTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-23.
//

import UIKit

protocol SectionTitleCellDelegate {
    func showListAction()
}

class SectionTitleTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showListButton: UIButton!
    @IBAction func showListButtonTapped(_ sender: Any) {
        showListButtonAction()
    }
    @IBOutlet weak var showListChevromImageView: UIImageView!
    
    
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    var hideBottomLine: Bool = false {
        didSet {
            bottomLineImageView.isHidden = hideBottomLine
        }
    }
    var hideShowListButton: Bool = false {
        didSet {
            showListButton.isHidden = hideShowListButton
            showListChevromImageView.isHidden = hideShowListButton
        }
    }
    var delegate: SectionTitleCellDelegate?
    
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
    
    private func showListButtonAction() {
        delegate?.showListAction()
    }
    
}
