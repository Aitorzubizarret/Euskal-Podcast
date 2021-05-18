//
//  ProgramsListTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 16/05/2021.
//

import UIKit

class ProgramsListTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBAction func seeAllButtonTapped(_ sender: Any) {
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    let programCollectionViewCellIdentifier: String = "ProgramCollectionViewCell"
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
        self.setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        // Cell
        self.selectionStyle = .none
        
        // Label.
        self.titleLabel.text = "Programak"
        
        // Button.
        self.seeAllButton.setTitle("Zerrenda", for: .normal)
        
    }
    
    ///
    /// Setup the CollectionView.
    ///
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Layout.
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
        }
        
        self.collectionView.showsHorizontalScrollIndicator = false
        
        // Register cell.
        let programCell: UINib = UINib(nibName: "ProgramCollectionViewCell", bundle: nil)
        self.collectionView.register(programCell, forCellWithReuseIdentifier: self.programCollectionViewCellIdentifier)
    }
}

// MARK: - UICollectionView Delegate

extension ProgramsListTableViewCell: UICollectionViewDelegate {}

// MARK: - UICollectionView Data Source

extension ProgramsListTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: self.programCollectionViewCellIdentifier, for: indexPath) as! ProgramCollectionViewCell
        return cell
    }
}
