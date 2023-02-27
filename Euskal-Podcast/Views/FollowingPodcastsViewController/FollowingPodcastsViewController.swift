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
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    private var viewModel: FollowingPodcastsViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    
    private var podcasts: [Podcast] = [] {
        didSet {
            tableView.reloadData()
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
        
        subscriptions()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFollowingPodcasts()
    }
    
    private func subscriptions() {
        viewModel.podcasts.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] podcasts in
            self?.podcasts = podcasts
        }.store(in: &subscribedTo)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "ProgramTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: "ProgramTableViewCell")
        
        tableView.estimatedRowHeight = 110
    }
    
}

// MARK: - UITableView Delegate

extension FollowingPodcastsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.showPodcastDetail(podcastId: podcasts[indexPath.row].id)
    }
    
}

// MARK: - UITableView Data Source

extension FollowingPodcastsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramTableViewCell", for: indexPath) as! ProgramTableViewCell
        
        let podcast = podcasts[indexPath.row]
        cell.iconURL = podcast.imageURL
        cell.titleText = podcast.title
        cell.descriptionText = podcast.descriptionText
        cell.episodesInfo = viewModel.getAmountEpisode(podcast: podcast)
        cell.authorText = podcast.author
        
        return cell
    }
    
}
