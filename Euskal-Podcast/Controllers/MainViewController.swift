//
//  MainViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 02/05/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var episodes: [Episode] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    let episodeTableViewCell: String = "EpisodeTableViewCell"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.createData()
    }
    
    
    ///
    /// Setup the Table View.
    ///
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register cell.
        let episodeCell: UINib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        self.tableView.register(episodeCell, forCellReuseIdentifier: episodeTableViewCell)
        
        self.tableView.estimatedRowHeight = 75
    }
    
    ///
    /// Create data.
    ///
    private func createData() {
        let episode: Episode = Episode(name: "Miseriaren Adarrak",
                                       program: "Bertso Zaharrak",
                                       mp3Url: "https://www.ivoox.com/miseriaren-adarrak-xenpelarren-bertso-sorta_mf_50074712_feed_1.mp3",
                                       duration: "02:19")
        self.episodes.append(episode)
    }
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC: PlayerViewController = PlayerViewController()
        playerVC.episode = self.episodes[indexPath.row]
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
}

// MARK: - UITableView Date Source

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.episodeTableViewCell) as! EpisodeTableViewCell
        cell.episode = self.episodes[indexPath.row]
        return cell
    }
    
}
