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
    
    let episodeTableViewCell:     String = "EpisodeTableViewCell"
    let seasonTableViewCell:      String = "SeasonTableViewCell"
    let programTableViewCell:     String = "ProgramTableViewCell"
    let companyTableViewCell:     String = "CompanyTableViewCell"
    let sourceTableViewCell:      String = "SourceTableViewCell"
    let programListTableViewCell: String = "ProgramsListTableViewCell"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.start()
        
        setupView()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name("Companies"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name("Programs"), object: nil)
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
        
        let programListCell = UINib(nibName: programListTableViewCell, bundle: nil)
        tableView.register(programListCell, forCellReuseIdentifier: programListTableViewCell)
        
        //tableView.estimatedRowHeight = 75
    }
    
    @objc private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func update() {
        print("\(DataManager.shared.companies)")
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
        if indexPath.section == 0 {
            return 256
        } else {
            return 60
        }
    }
    
}

// MARK: - UITableView Date Source

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return DataManager.shared.companies.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: programListTableViewCell) as! ProgramsListTableViewCell
            cell.programs = DataManager.shared.programs
            cell.hostVC = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: companyTableViewCell) as! CompanyTableViewCell
            cell.company = DataManager.shared.companies[indexPath.row]
            return cell
        }
    }
    
}
