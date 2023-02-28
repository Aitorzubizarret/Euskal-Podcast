//
//  PodcastsViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit
import Combine

class PodcastsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    
    private var viewModel: PodcastsViewModel
    private var subscribedTo: [AnyCancellable] = []
    
    private var podcasts: [Podcast] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var followingPodcasts: [Podcast] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var newEpisodes: [Episode] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: PodcastsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PODCASTAK"
        
        setupTableView()
        subscriptions()
        
        viewModel.fetchChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFollowingPodcasts()
        viewModel.getNewEpisodes()
        viewModel.getPodcasts()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let sectionTitleCell: UINib = UINib(nibName: "SectionTitleTableViewCell", bundle: nil)
        tableView.register(sectionTitleCell, forCellReuseIdentifier: "SectionTitleTableViewCell")
        
        let podcastListCell: UINib = UINib(nibName: "ProgramsListTableViewCell", bundle: nil)
        tableView.register(podcastListCell, forCellReuseIdentifier: "ProgramsListTableViewCell")
        
        let newEpisodesListCell: UINib = UINib(nibName: "NewEpisodesListTableViewCell", bundle: nil)
        tableView.register(newEpisodesListCell, forCellReuseIdentifier: "NewEpisodesListTableViewCell")
        
        let podcastCell: UINib = UINib(nibName: "ProgramTableViewCell", bundle: nil)
        tableView.register(podcastCell, forCellReuseIdentifier: "ProgramTableViewCell")
    }
    
    private func subscriptions() {
        viewModel.podcasts.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] podcasts in
            self?.podcasts = podcasts
        }.store(in: &subscribedTo)
        
        viewModel.followingPodcasts.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] followingPodcasts in
            self?.followingPodcasts = followingPodcasts
        }.store(in: &subscribedTo)
        
        viewModel.newEpisodes.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] receivedNewEpisodes in
            self?.newEpisodes = receivedNewEpisodes
        }.store(in: &subscribedTo)
    }
    
}

// MARK: - UITableView Delegate

extension PodcastsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 || indexPath.section == 5 {
            coordinator.showPodcastDetail(podcastId: podcasts[indexPath.row].id)
        }
    }
    
}

// MARK: - UITableView Data Source

extension PodcastsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if followingPodcasts.count > 0 {
                return 1
            } else {
                return 0
            }
        case 1:
            if followingPodcasts.count > 0 {
                return 1
            } else {
                return 0
            }
        case 2:
            if newEpisodes.count > 0 {
                return 1
            } else {
                return 0
            }
        case 3:
            if newEpisodes.count > 0 {
                return 1
            } else {
                return 0
            }
        case 4:
            return 1
        case 5:
            return podcasts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleTableViewCell", for: indexPath) as! SectionTitleTableViewCell
            
            cell.delegate = self
            cell.titleText = "JARRAITZEN"
            cell.hideBottomLine = true
            cell.hideShowListButton = false
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramsListTableViewCell", for: indexPath) as! ProgramsListTableViewCell
            cell.delegate = self
            
            cell.podcasts = followingPodcasts
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleTableViewCell", for: indexPath) as! SectionTitleTableViewCell
            
            cell.titleText = "ATAL BERRIAK"
            cell.hideBottomLine = true
            cell.hideShowListButton = true
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewEpisodesListTableViewCell", for: indexPath) as! NewEpisodesListTableViewCell
            cell.delegate = self
            cell.episodes = newEpisodes
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleTableViewCell", for: indexPath) as! SectionTitleTableViewCell
            
            cell.titleText = "PODCAST GUZTIAK"
            cell.hideBottomLine = true
            cell.hideShowListButton = true
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramTableViewCell", for: indexPath) as! ProgramTableViewCell
            
            let podcast = podcasts[indexPath.row]
            cell.iconURL = podcast.imageURL
            cell.titleText = podcast.title
            cell.descriptionText = podcast.descriptionText
            cell.episodesInfo = viewModel.getAmountEpisode(podcast: podcast)
            cell.authorText = podcast.author
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

// MARK: - SectionTitleCell Delegate

extension PodcastsViewController: SectionTitleCellDelegate {
    
    func showListAction() {
        coordinator.showFollowingPodcasts()
    }
    
}

// MARK: -

extension PodcastsViewController: NewEpisodeCellDelegate {
    
    func showSelectedEpisode(position: Int) {
        coordinator.showEpisodeDetail(episode: newEpisodes[position])
    }
    
}

// MARK: - ProgramListCell Delegate

extension PodcastsViewController: ProgramListCellDelegate {
    
    func showSelectedProgram(position: Int) {
        coordinator.showPodcastDetail(podcastId: followingPodcasts[position].id)
    }
    
}
