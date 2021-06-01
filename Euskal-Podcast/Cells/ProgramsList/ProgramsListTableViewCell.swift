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
        self.goToProgramsList()
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var hostVC: UIViewController?
    let programCollectionViewCellIdentifier: String = "ProgramCollectionViewCell"
    var programs: [Program] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
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
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
        }
        
        self.collectionView.showsHorizontalScrollIndicator = false
        
        // Register cell.
        let programCell: UINib = UINib(nibName: "ProgramCollectionViewCell", bundle: nil)
        self.collectionView.register(programCell, forCellWithReuseIdentifier: self.programCollectionViewCellIdentifier)
    }
    
    ///
    /// Go to ProgramsViewController.
    ///
    private func goToProgramsList() {
        let programsVC: ProgramsViewController = ProgramsViewController()
        self.hostVC?.navigationController?.pushViewController(programsVC, animated: true)
    }
}

// MARK: - UICollectionView Delegate

extension ProgramsListTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let programVC: ProgramViewController = ProgramViewController()
        self.hostVC?.navigationController?.pushViewController(programVC, animated: true)
    }
    
}

// MARK: - UICollectionView Data Source

extension ProgramsListTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.programs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: self.programCollectionViewCellIdentifier, for: indexPath) as! ProgramCollectionViewCell
        cell.program = self.programs[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionView Delegate FlowLayout

extension ProgramsListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = 118
        let cellHeight = 170
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
