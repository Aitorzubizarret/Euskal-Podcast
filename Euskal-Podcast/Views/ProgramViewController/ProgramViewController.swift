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
    
    var coordinator: Coordinator
    
    private let tableView = UITableView()
    
    private let mainTitleTableViewCellIdentifier: String = "MainTitleTableViewCell"
    private let episodeTableViewCellIdentifier: String = "EpisodeTableViewCell"
    
    public var program: ProgramXML? {
        didSet {
            guard let safeProgram = program else { return }
            
            tableView.reloadData()
        }
    }
    
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
        
        setupTableView()
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
    
    ///
    /// Setup the TableView.
    ///
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

}

// MARK: - UITableView Delegate

extension ProgramViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            if let program = program {
                let selectedEpisode: EpisodeXML = program.episodes[indexPath.row]
                coordinator.goToPlayer(episode: selectedEpisode)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 265
        default:
            return UITableView.automaticDimension
        }
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
            if let safeProgram = program {
                return safeProgram.title
            } else {
                return ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let safeProgram = program {
                return safeProgram.episodes.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mainTitleTableViewCellIdentifier, for: indexPath) as! MainTitleTableViewCell
            if let safeProgram = program {
                cell.imageURL = safeProgram.imageURL
                cell.titleName = safeProgram.title
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: episodeTableViewCellIdentifier, for: indexPath) as! EpisodeTableViewCell
            if let safeProgram = program {
                cell.episode = safeProgram.episodes[indexPath.row]
            }
            return cell
        }
    }
    
}
