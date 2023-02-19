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
    private var program: Program = Program() {
        didSet {
            tableView.reloadData()
        }
    }
    private var programId: String
    
    var isPlaying: Bool = false {
        didSet {
            updateVisibleCells()
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: ProgramViewModel, programId: String) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.programId = programId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Programa"
        
        setupTableView()
        subscriptions()
        
        viewModel.searchProgram(id: programId)
        isPlaying = viewModel.checkAudioIsPlaying()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.template.lightPurple

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
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
        viewModel.program.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] program in
            self?.program = program
        }.store(in: &subscribedTo)
        
        viewModel.audioIsPlaying.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] isPlaying in
            self?.isPlaying = isPlaying
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
            let selectedEpisode: Episode = program.episodes[indexPath.row]
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
        return program.episodes.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        default:
            return program.title
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return program.episodes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mainTitleTableViewCellIdentifier, for: indexPath) as! MainTitleTableViewCell
            
            cell.imageURL = program.imageURL
            cell.titleName = program.title
            cell.descriptionText = program.descriptionText
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: episodeTableViewCellIdentifier, for: indexPath) as! EpisodeTableViewCell
            cell.delegate = self
            cell.rowAt = indexPath.row
            
            let episode = program.episodes[indexPath.row]
            cell.releaseDateText = episode.getPublishedDateFormatter()
            cell.titleText = episode.title
            cell.descriptionText = episode.descriptionText
            cell.durationText = episode.getDurationFormatted()
            
            if viewModel.checkEpisodeIsPlaying(episodeId: episode.id) && isPlaying {
                cell.isPlaying = true
            } else {
                cell.isPlaying = false
            }
            
            return cell
        }
    }
    
}

extension ProgramViewController: EpisodeCellDelegate {
    
    func playEpisode(rowAt: Int) {
        let selectedEpisode = program.episodes[rowAt]
        viewModel.playEpisode(episode: selectedEpisode, program: program)
    }
    
    func pauseEpisode(rowAt: Int) {
        viewModel.pauseEpisode()
    }
    
}
