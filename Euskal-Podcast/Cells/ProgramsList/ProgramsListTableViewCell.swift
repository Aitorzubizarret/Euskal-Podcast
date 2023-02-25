//
//  ProgramsListTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 16/05/2021.
//

import UIKit

protocol ProgramListCellDelegate {
    func showAllPrograms()
    func showSelectedProgram(position: Int)
}

class ProgramsListTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    let programCollectionViewCellIdentifier: String = "ProgramCollectionViewCell"
    var podcasts: [Podcast] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var delegate: ProgramListCellDelegate?
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        setupCollectionView()
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
        selectionStyle = .none
        
        // UIimageView.
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    ///
    /// Setup the CollectionView.
    ///
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Layout.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        
        // Register cell.
        let programCell: UINib = UINib(nibName: "ProgramCollectionViewCell", bundle: nil)
        collectionView.register(programCell, forCellWithReuseIdentifier: programCollectionViewCellIdentifier)
    }
    
}

// MARK: - UICollectionView Delegate

extension ProgramsListTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showSelectedProgram(position: indexPath.row)
    }
    
}

// MARK: - UICollectionView Data Source

extension ProgramsListTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: programCollectionViewCellIdentifier, for: indexPath) as! ProgramCollectionViewCell
        cell.podcast = podcasts[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionView Delegate FlowLayout

extension ProgramsListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = CGFloat(UIScreen.main.bounds.width / 3.6)
        let cellHeight: CGFloat = 170
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
