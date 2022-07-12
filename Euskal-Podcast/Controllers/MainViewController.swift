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
    
    let episodeTableViewCell: String = "EpisodeTableViewCell"
    let seasonTableViewCell: String  = "SeasonTableViewCell"
    let programTableViewCell: String = "ProgramTableViewCell"
    let companyTableViewCell: String = "CompanyTableViewCell"
    let sourceTableViewCell: String  = "SourceTableViewCell"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.start()
        
        setupView()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name("Sources"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        title = "Euskal Podcast"
    }
    
    ///
    /// Setup the Table View.
    ///
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells
        let sourceCell: UINib = UINib(nibName: sourceTableViewCell, bundle: nil)
        tableView.register(sourceCell, forCellReuseIdentifier: sourceTableViewCell)
        
        let episodeCell: UINib = UINib(nibName: episodeTableViewCell, bundle: nil)
        tableView.register(episodeCell, forCellReuseIdentifier: episodeTableViewCell)
        
        let seasonCell: UINib = UINib(nibName: seasonTableViewCell, bundle: nil)
        tableView.register(seasonCell, forCellReuseIdentifier: seasonTableViewCell)
        
        let programCell: UINib = UINib(nibName: programTableViewCell, bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: programTableViewCell)
        
        let companyCell: UINib = UINib(nibName: companyTableViewCell, bundle: nil)
        tableView.register(companyCell, forCellReuseIdentifier: companyTableViewCell)
        
        tableView.estimatedRowHeight = 75
    }
    
    @objc private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyVC: CompanyViewController = CompanyViewController()
        //companyVC.company = companies[indexPath.row]
        show(companyVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: - UITableView Date Source

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.sources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sourceTableViewCell) as! SourceTableViewCell
        cell.source = DataManager.shared.sources[indexPath.row]
        return cell
    }
    
}
