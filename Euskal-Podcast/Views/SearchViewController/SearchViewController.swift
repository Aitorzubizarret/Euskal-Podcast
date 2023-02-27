//
//  SearchViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    private var viewModel: SearchViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    private var foundPodcasts: [Podcast] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var foundEpisodes: [Episode] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: SearchViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "BILATU"
        
        setupSearchBar()
        setupTableView()
        
        subscriptions()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        
        searchBar.showsCancelButton = false
        searchBar.returnKeyType = .done
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .onDrag
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "ProgramsListTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: "ProgramsListTableViewCell")
        
        let sectionTitleCell: UINib = UINib(nibName: "SectionTitleTableViewCell", bundle: nil)
        tableView.register(sectionTitleCell, forCellReuseIdentifier: "SectionTitleTableViewCell")
        
        let episodeCell: UINib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register(episodeCell, forCellReuseIdentifier: "EpisodeTableViewCell")
    }
    
    private func subscriptions() {
        viewModel.foundPodcasts.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] podcasts in
            self?.foundPodcasts = podcasts
        }.store(in: &subscribedTo)
        
        viewModel.foundEpisodes.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] episodes in
            self?.foundEpisodes = episodes
        }.store(in: &subscribedTo)
    }
}

// MARK: - UISearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextInProgramsAndEpisodes(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

// MARK: - UITableView Delegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let selectedEpisode = foundEpisodes[indexPath.row]
            coordinator.showEpisodeDetail(episode: selectedEpisode)
        }
    }
    
}

// MARK: - UITableView Data Source

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if !foundPodcasts.isEmpty {
                return 1
            }
        case 1:
            if !foundPodcasts.isEmpty {
                return 1
            }
        case 2:
            if !foundEpisodes.isEmpty {
                return 1
            }
        case 3:
            return foundEpisodes.count
        default:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleTableViewCell", for: indexPath) as! SectionTitleTableViewCell
            cell.delegate = self
            cell.titleText = "PODCASTAK" + " - \(foundPodcasts.count)"
            cell.hideBottomLine = true
            cell.hideShowListButton = false
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramsListTableViewCell", for: indexPath) as! ProgramsListTableViewCell
            cell.delegate = self
            cell.podcasts = foundPodcasts
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleTableViewCell", for: indexPath) as! SectionTitleTableViewCell
            cell.delegate = self
            cell.titleText = "ATALAK" + " - \(foundEpisodes.count)"
            cell.hideBottomLine = false
            cell.hideShowListButton = true
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
            let episode = foundEpisodes[indexPath.row]
            cell.releaseDateText = episode.getPublishedDateFormatter()
            cell.titleText = episode.title
            cell.descriptionText = episode.descriptionText
            cell.durationText = episode.duration.asTimeFormatted()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

// MARK: - ProgramListCell Delegate

extension SearchViewController: ProgramListCellDelegate {
    
    func showSelectedProgram(position: Int) {
        let podcastId: String = foundPodcasts[position].id
        coordinator.showPodcastDetail(podcastId: podcastId)
    }
    
}

// MARK: - SectionTitleCell Delegate

extension SearchViewController: SectionTitleCellDelegate {
    
    func showListAction() {
        coordinator.showPodcastList(podcasts: foundPodcasts)
    }
    
}
