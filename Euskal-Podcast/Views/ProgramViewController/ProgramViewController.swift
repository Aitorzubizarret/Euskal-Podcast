//
//  ProgramViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 29/05/2021.
//

import UIKit
import Combine

class ProgramViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private let mainTitleTableViewCellIdentifier: String = "MainTitleTableViewCell"
    private let episodeTableViewCellIdentifier: String = "EpisodeTableViewCell"
    
    private var coordinator: Coordinator
    private var viewModel: ProgramViewModel
    private var subscribedTo: [AnyCancellable] = []
    private var podcast: Podcast = Podcast() {
        didSet {
            title = podcast.title
            
            viewModel.checkPodcastIsBeingFollowed(podcast)
            
            tableView.reloadData()
        }
    }
    private var episodes: [Episode] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var podcastId: String
    
    var isPlaying: Bool = false {
        didSet {
            updateVisibleCells()
        }
    }
    
    var isFollowed: Bool = false {
        didSet {
            updateVisibleCells()
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: ProgramViewModel, podcastId: String) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.podcastId = podcastId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        subscriptions()
        
        viewModel.searchProgram(id: podcastId)
        isPlaying = viewModel.checkAudioIsPlaying()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Constraints.
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        // Register the cells.
        let mainTitleCell = UINib(nibName: mainTitleTableViewCellIdentifier, bundle: nil)
        tableView.register(mainTitleCell, forCellReuseIdentifier: mainTitleTableViewCellIdentifier)
        
        let episodeCell: UINib = UINib(nibName: episodeTableViewCellIdentifier, bundle: nil)
        tableView.register(episodeCell, forCellReuseIdentifier: episodeTableViewCellIdentifier)
    }
    
    private func subscriptions() {
        viewModel.podcast.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] podcast in
            self?.podcast = podcast
        }.store(in: &subscribedTo)
        
        viewModel.episodes.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] episodes in
            self?.episodes = episodes
        }.store(in: &subscribedTo)
        
        viewModel.audioIsPlaying.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] isPlaying in
            self?.isPlaying = isPlaying
        }.store(in: &subscribedTo)
        
        viewModel.podcastIsBeingFollowed.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] isBeingFollowed in
            self?.isFollowed = isBeingFollowed
        }.store(in: &subscribedTo)
    }
    
    private func updateVisibleCells() {
        guard let visibleCells = tableView.indexPathsForVisibleRows else { return }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: visibleCells, with: .none)
        tableView.endUpdates()
    }
    
}

// MARK: - UITableView Delegate

extension ProgramViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let selectedEpisode: Episode = podcast.episodes[indexPath.row]
            coordinator.showEpisodeDetail(episode: selectedEpisode)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITableView Data Source

extension ProgramViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodes.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return episodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mainTitleTableViewCellIdentifier, for: indexPath) as! MainTitleTableViewCell
            cell.delegate = self
            
            cell.imageURL = podcast.imageURL
            cell.titleName = podcast.title
            cell.descriptionText = podcast.descriptionText
            cell.isFollowing = isFollowed
            cell.episodesInfo = viewModel.getEpisodesInfoAndPodcastCopyright(podcast: podcast)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: episodeTableViewCellIdentifier, for: indexPath) as! EpisodeTableViewCell
            cell.delegate = self
            cell.rowAt = indexPath.row
            
            let episode = episodes[indexPath.row]
            cell.releaseDateText = episode.getPublishedDateFormatter()
            cell.titleText = episode.title
            cell.descriptionText = episode.descriptionText
            cell.durationText = episode.duration.asTimeFormatted()
            
            if viewModel.checkEpisodeIsPlaying(episodeId: episode.id) && isPlaying {
                cell.isPlaying = true
            } else {
                cell.isPlaying = false
            }
            
            return cell
        }
    }
    
}

// MARK: - MainTitleCell Delegate

extension ProgramViewController: MainTitleCellDelegate {
    
    func follow() {
        viewModel.followPodcast(podcast: podcast)
    }
    
    func unfollow() {
        viewModel.unfollowPodcast(podcast: podcast)
    }
    
}


// MARK: - EpisodeCell Delegate

extension ProgramViewController: EpisodeCellDelegate {
    
    func playEpisode(rowAt: Int) {
        let selectedEpisode = episodes[rowAt]
        viewModel.playEpisode(episode: selectedEpisode, podcast: podcast)
    }
    
    func pauseEpisode(rowAt: Int) {
        viewModel.pauseEpisode()
    }
    
}
