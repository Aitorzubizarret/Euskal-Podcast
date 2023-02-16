//
//  ProgramViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 29/05/2021.
//

import UIKit

class ProgramViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private let mainTitleTableViewCellIdentifier: String = "MainTitleTableViewCell"
    private let episodeTableViewCellIdentifier: String = "EpisodeTableViewCell"
    
    private let notificationCenter = NotificationCenter.default
    
    var coordinator: Coordinator
    
    var program: Program? {
        didSet {
            guard let _ = program else { return }
            
            tableView.reloadData()
        }
    }
    
    var isPlaying: Bool = false
    
    // MARK: - Methods
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Programa"
        
        isPlaying = AudioManager.shared.isPlaying()
        setupTableView()
        setupNotificationsObservers()
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
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(songIsPlaying),
                                       name: .songPlaying,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(songIsPause),
                                       name: .songPause,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(songIsPause),
                                       name: .audioFinished,
                                       object: nil)
    }
    
    @objc private func songIsPlaying() {
        isPlaying = true
        
        updateVisibleCell()
    }
    
    @objc private func songIsPause() {
        isPlaying = false
        
        updateVisibleCell()
    }
    
    private func updateVisibleCell() {
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
            if let program = program {
                let selectedEpisode: Episode = program.episodes[indexPath.row]
                coordinator.showEpisodeDetail(episode: selectedEpisode)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITableView Data Source

extension ProgramViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let safeProgram = program {
            return (safeProgram.episodes.count > 0) ? 2 : 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        default:
            if let program = program {
                return program.title
            } else {
                return ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let program = program {
                return program.episodes.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mainTitleTableViewCellIdentifier, for: indexPath) as! MainTitleTableViewCell
            if let program = program {
                cell.imageURL = program.imageURL
                cell.titleName = program.title
                cell.descriptionText = program.descriptionText
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: episodeTableViewCellIdentifier, for: indexPath) as! EpisodeTableViewCell
            cell.delegate = self
            cell.rowAt = indexPath.row
            
            if let program = program {
                let episode = program.episodes[indexPath.row]
                cell.releaseDateText = episode.getPublishedDateFormatter()
                cell.titleText = episode.title
                cell.descriptionText = episode.descriptionText
                cell.durationText = episode.getDurationFormatted()
                
                if AudioManager.shared.getEpisodeId() == episode.id {
                    cell.isPlaying = isPlaying
                } else {
                    cell.isPlaying = false
                }
            }
            
            return cell
        }
    }
    
}

extension ProgramViewController: EpisodeCellDelegate {
    
    func playEpisode(rowAt: Int) {
        guard let program = program else { return }
        
        let selectedEpisode = program.episodes[rowAt]
        
        AudioManager.shared.playSong(episode: selectedEpisode, programName: program.title, programImageString: program.imageURL)
    }
    
    func pauseEpisode(rowAt: Int) {
        AudioManager.shared.pauseSong()
    }
    
}
