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
    
    var coordinator: SearchCoordinator
    var viewModel: SearchViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    private var foundEpisodes: [Episode] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: SearchCoordinator, viewModel: SearchViewModel) {
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
        
        subscriptions()
        setupSearchBar()
        setupTableView()
    }
    
    private func subscriptions() {
        viewModel.foundEpisodes.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] episodes in
            self?.foundEpisodes = episodes
        }.store(in: &subscribedTo)
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
        let programCell: UINib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: "EpisodeTableViewCell")
        
        tableView.estimatedRowHeight = 110
    }
    
}

// MARK: - UISearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchEpisodes(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

// MARK: - UITableView Delegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEpisode = foundEpisodes[indexPath.row]
        coordinator.showEpisodeDetail(episode: selectedEpisode)
    }
    
}

// MARK: - UITableView Data Source

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
        
        let episode = foundEpisodes[indexPath.row]
        cell.releaseDateText = episode.getPublishedDateFormatter()
        cell.titleText = episode.title
        cell.descriptionText = episode.descriptionText
        cell.durationText = episode.duration.asTimeFormatted()
        
        return cell
    }
    
}
