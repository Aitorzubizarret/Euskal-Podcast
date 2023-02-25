//
//  PlayedEpisodesViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-24.
//

import UIKit
import Combine

class PlayedEpisodesViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    private var viewModel: PlayedEpisodesViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    
    private var playedEpisodes: [PlayedEpisode] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: PlayedEpisodesViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Entzundako Podcast Atalak"
        
        setupTableView()
        subscriptions()
        
        viewModel.getPlayedEpisodes()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "PlayedEpisodeTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: "PlayedEpisodeTableViewCell")
    }
    
    private func subscriptions() {
        viewModel.playedEpisodes.sink { receiveCompletion in
            print("Received Completion")
        } receiveValue: { [weak self] playedEpisodes in
            self?.playedEpisodes = playedEpisodes
        }.store(in: &subscribedTo)

    }
    
}

extension PlayedEpisodesViewController: UITableViewDelegate {}

extension PlayedEpisodesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playedEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayedEpisodeTableViewCell", for: indexPath) as! PlayedEpisodeTableViewCell
        
        let playedEpisode = playedEpisodes[indexPath.row]
        
        if let episode = playedEpisode.episode {
            cell.playedDateFormatted = playedEpisode.getDateFormatted()
            cell.pictureURL = viewModel.getPodcastImageFromEpisodeId(episode)
            cell.episodeName = episode.title
            cell.podcastName = viewModel.getPodcastNameFromEpisode(episode)
        }
        
        return cell
    }
    
}
