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
    
    private var companies: [Company] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let episodeTableViewCell: String = "EpisodeTableViewCell"
    let seasonTableViewCell: String  = "SeasonTableViewCell"
    let programTableViewCell: String = "ProgramTableViewCell"
    let companyTableViewCell: String = "CompanyTableViewCell"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
        getData()
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
    
    ///
    /// Get data from the Internet.
    ///
    private func getData() {
//        APIManager.shared.getCompaniesData { [weak self] receivedCompanies in
//            if !receivedCompanies.isEmpty {
//                // For debug purposes.
//                //debugPrint("Companies \(receivedCompanies)")
//                self?.companies = receivedCompanies
//            } else {
//                print("MainViewController - getData - No data received.")
//            }
//        }
        
        APIManager.shared.getRSS(rssString: APIManager.shared.EITB_YOKO_ONA_RSS) { response in
            if response {
                print("Response true")
            } else {
                print("Response false")
            }
        }
    }
    
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyVC: CompanyViewController = CompanyViewController()
        companyVC.company = companies[indexPath.row]
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
        return companies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: companyTableViewCell) as! CompanyTableViewCell
        cell.company = companies[indexPath.row]
        return cell
    }
    
}
