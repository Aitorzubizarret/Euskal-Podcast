//
//  NewEpisodesListTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-28.
//

import UIKit
import Combine

protocol NewEpisodeListCellDelegate {
    func showSelectedEpisode(position: Int)
    func playEpisode(_ episode: Episode)
    func pauseEpisode()
}

class NewEpisodesListTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var viewModel: PodcastsViewModel? {
        didSet {
            subscriptions()
        }
    }
    private var subscribedTo: [AnyCancellable] = []
    var episodes: [Episode] = []
    var delegate: NewEpisodeListCellDelegate?
    var isPlaying: Bool = false {
        didSet {
            updateVisibleCells()
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
    
    private func setupView() {
        selectionStyle = .none
        
        // UIimageView.
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Layout.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        
        // Register cell.
        let newEpisodeCell: UINib = UINib(nibName: "NewEpisodeCollectionViewCell", bundle: nil)
        collectionView.register(newEpisodeCell, forCellWithReuseIdentifier: "NewEpisodeCollectionViewCell")
    }
    
    private func subscriptions() {
        guard let viewModel = viewModel else { return }
        
        viewModel.audioIsPlaying.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] isPlaying in
            self?.isPlaying = isPlaying
        }.store(in: &subscribedTo)
    }
    
    private func updateVisibleCells() {
        let visibleItems: [IndexPath] = collectionView.indexPathsForVisibleItems
        collectionView.reloadItems(at: visibleItems)
    }
    
}

// MARK: - UICollectionView Delegate

extension NewEpisodesListTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showSelectedEpisode(position: indexPath.row)
    }
    
}

// MARK: - UICollectionView Delegate Flow Layout

extension NewEpisodesListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 40
        let height = (collectionView.frame.height - 10) / 3
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - UICollectionView Data Source

extension NewEpisodesListTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewEpisodeCollectionViewCell", for: indexPath) as! NewEpisodeCollectionViewCell
        cell.delegate = self
        cell.rowAt = indexPath.row
        cell.episode = episodes[indexPath.row]
        if let viewModel = viewModel {
            cell.isPlaying = viewModel.checkEpisodeIsPlaying(episodes[indexPath.row]) && isPlaying
        }
        return cell
    }
    
}

// MARK: - NewEpisodeCell Delegate

extension NewEpisodesListTableViewCell: NewEpisodeCellDelegate {
    
    func playEpisode(rowAt: Int) {
        delegate?.playEpisode(episodes[rowAt])
    }
    
    func pauseEpisode(rowAt: Int) {
        delegate?.pauseEpisode()
    }
    
}
