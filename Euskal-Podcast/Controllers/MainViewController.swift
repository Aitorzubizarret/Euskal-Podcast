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
    
    var dataViewModel: DataViewModel = DataViewModel()
    var companies: [Company] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    let episodeTableViewCell: String = "EpisodeTableViewCell"
    let seasonTableViewCell: String  = "SeasonTableViewCell"
    let programTableViewCell: String = "ProgramTableViewCell"
    let companyTableViewCell: String = "CompanyTableViewCell"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
        self.bind()
        
        self.dataViewModel.getLocalData()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Euskal Podcast"
    }
    
    ///
    /// Setup the Table View.
    ///
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register cells
        let episodeCell: UINib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        self.tableView.register(episodeCell, forCellReuseIdentifier: self.episodeTableViewCell)
        
        let seasonCell: UINib = UINib(nibName: "SeasonTableViewCell", bundle: nil)
        self.tableView.register(seasonCell, forCellReuseIdentifier: self.seasonTableViewCell)
        
        let programCell: UINib = UINib(nibName: "ProgramTableViewCell", bundle: nil)
        self.tableView.register(programCell, forCellReuseIdentifier: self.programTableViewCell)
        
        let companyCell: UINib = UINib(nibName: "CompanyTableViewCell", bundle: nil)
        self.tableView.register(companyCell, forCellReuseIdentifier: self.companyTableViewCell)
        
        self.tableView.estimatedRowHeight = 75
    }
    
    //
    /// Get new data from DataViewModel.
    ///
    private func bind() {
        self.dataViewModel.binding = {
            if let receivedCompanies = self.dataViewModel.companyList {
                self.companies = receivedCompanies
            }
        }
    }
    
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyVC: CompanyViewController = CompanyViewController()
        companyVC.company = self.companies[indexPath.row]
        self.navigationController?.pushViewController(companyVC, animated: true)
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
        return self.companies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.companyTableViewCell) as! CompanyTableViewCell
        cell.company = self.companies[indexPath.row]
        return cell
    }
    
}
