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
    private var foundPrograms: [Program] = [] {
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
        viewModel.foundPrograms.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] programs in
            self?.foundPrograms = programs
        }.store(in: &subscribedTo)
        
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
        let programCell: UINib = UINib(nibName: "ProgramsListTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: "ProgramsListTableViewCell")
        
        let episodeCell: UINib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register(episodeCell, forCellReuseIdentifier: "EpisodeTableViewCell")
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
        if indexPath.section == 0 {
            return 256
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEpisode = foundEpisodes[indexPath.row]
        coordinator.showEpisodeDetail(episode: selectedEpisode)
    }
    
}

// MARK: - UITableView Data Source

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !foundPrograms.isEmpty {
            return 1
        }
        
        if section == 1 {
            return foundEpisodes.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramsListTableViewCell", for: indexPath) as! ProgramsListTableViewCell
            cell.delegate = self
            
            cell.programs = foundPrograms
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
            
            let episode = foundEpisodes[indexPath.row]
            cell.releaseDateText = episode.getPublishedDateFormatter()
            cell.titleText = episode.title
            cell.descriptionText = episode.descriptionText
            cell.durationText = episode.duration.asTimeFormatted()
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
}

extension SearchViewController: ProgramListCellDelegate {
    
    func showAllPrograms() {
        // TODO: - Create the ViewController to show the Programs and then the methods in Coordinator.
    }
    
    func showSelectedProgram(position: Int) {
        let programId: String = foundPrograms[position].id
        coordinator.showProgramDetail(programId: programId)
    }
    
}
