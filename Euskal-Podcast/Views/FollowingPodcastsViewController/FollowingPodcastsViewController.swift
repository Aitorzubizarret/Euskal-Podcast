//
//  FollowingPodcastsViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-27.
//

import UIKit
import Combine

class FollowingPodcastsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    private var viewModel: FollowingPodcastsViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    
    private var podcasts: [Podcast] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: FollowingPodcastsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        subscriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFollowingPodcasts()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Layout.
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 20
        }
        
        collectionView.showsVerticalScrollIndicator = false
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "PodcastElementCollectionViewCell", bundle: nil)
        collectionView.register(programCell, forCellWithReuseIdentifier: "PodcastElementCollectionViewCell")
    }
    
    private func subscriptions() {
        viewModel.podcasts.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] podcasts in
            self?.podcasts = podcasts
        }.store(in: &subscribedTo)
    }
}

// MARK: - UICollectionView Delegate

extension FollowingPodcastsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.showPodcastDetail(podcastId: podcasts[indexPath.row].id)
    }
    
}

extension FollowingPodcastsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 60) / 2
        return CGSize(width: width, height: width)
    }
    
}

// MARK: - UICollectionView Data Source

extension FollowingPodcastsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastElementCollectionViewCell", for: indexPath) as! PodcastElementCollectionViewCell
        cell.podcast = podcasts[indexPath.row]
        return cell
    }
    
}
