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
        goToProgramsList()
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var hostVC: UIViewController?
    let programCollectionViewCellIdentifier: String = "ProgramCollectionViewCell"
    var programs: [ProgramXML] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        
        // Label.
        titleLabel.text = "Programak"
        
        // Button.
        seeAllButton.setTitle("Zerrenda", for: .normal)
        
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
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        
        // Register cell.
        let programCell: UINib = UINib(nibName: "ProgramCollectionViewCell", bundle: nil)
        collectionView.register(programCell, forCellWithReuseIdentifier: programCollectionViewCellIdentifier)
    }
    
    ///
    /// Go to ProgramsViewController.
    ///
    private func goToProgramsList() {
        let programsVC = ProgramsViewController()
        programsVC.programs = programs
        hostVC?.show(programsVC, sender: self)
    }
}

// MARK: - UICollectionView Delegate

extension ProgramsListTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let programVC = ProgramViewController()
        programVC.program = programs[indexPath.row]
        hostVC?.show(programVC, sender: self)
    }
    
}

// MARK: - UICollectionView Data Source

extension ProgramsListTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return programs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: programCollectionViewCellIdentifier, for: indexPath) as! ProgramCollectionViewCell
        cell.program = programs[indexPath.row]
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
