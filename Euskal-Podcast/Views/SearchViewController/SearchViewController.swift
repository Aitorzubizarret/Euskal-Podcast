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
        
        let sectionTitleCell: UINib = UINib(nibName: "SectionTitleTableViewCell", bundle: nil)
        tableView.register(sectionTitleCell, forCellReuseIdentifier: "SectionTitleTableViewCell")
        
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
        if section == 0 && !foundPrograms.isEmpty {
            return 1
        }
        
        if section == 1 && !foundPrograms.isEmpty {
            return 1
        }
        
        if section == 2 && !foundEpisodes.isEmpty {
            return 1
        }
        
        if section == 3 {
            return foundEpisodes.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleTableViewCell", for: indexPath) as! SectionTitleTableViewCell
            
            cell.delegate = self
            cell.titleText = "PODCASTAK" + " - \(foundPrograms.count)"
            cell.hideBottomLine = true
            cell.hideShowListButton = false
            
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramsListTableViewCell", for: indexPath) as! ProgramsListTableViewCell
            cell.delegate = self
            
            cell.programs = foundPrograms
            
            return cell
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleTableViewCell", for: indexPath) as! SectionTitleTableViewCell
            
            cell.delegate = self
            cell.titleText = "ATALAK" + " - \(foundEpisodes.count)"
            cell.hideBottomLine = false
            cell.hideShowListButton = true
            
            return cell
        }
        
        if indexPath.section == 3 {
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

// MARK: - ProgramListCell Delegate

extension SearchViewController: ProgramListCellDelegate {
    
    func showAllPrograms() {
        // TODO: - Create the ViewController to show the Programs and then the methods in Coordinator.
    }
    
    func showSelectedProgram(position: Int) {
        let programId: String = foundPrograms[position].id
        coordinator.showProgramDetail(programId: programId)
    }
    
}

// MARK: - SectionTitleCell Delegate

extension SearchViewController: SectionTitleCellDelegate {
    
    func showListAction() {
        coordinator.showPodcastList(programs: foundPrograms)
    }
    
}
