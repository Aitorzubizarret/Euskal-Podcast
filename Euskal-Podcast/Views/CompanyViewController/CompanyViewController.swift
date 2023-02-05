//
//  CompanyViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 14/05/2021.
//

import UIKit

class CompanyViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var coordinator: Coordinator
    
    private let mainTitleTableViewCellIdentifier: String = "MainTitleTableViewCell"
    private let programsListTableViewCellIdentifier: String = "ProgramsListTableViewCell"
    
    public var company: Company?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Empresa"
        
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
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let mainTitleCell = UINib(nibName: mainTitleTableViewCellIdentifier, bundle: nil)
        tableView.register(mainTitleCell, forCellReuseIdentifier: mainTitleTableViewCellIdentifier)
        
        let programsList: UINib = UINib(nibName: programsListTableViewCellIdentifier, bundle: nil)
        tableView.register(programsList, forCellReuseIdentifier: programsListTableViewCellIdentifier)
    }
}

// MARK: - UITableView Delegate

extension CompanyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 265
        case 1:
            return 256
        default:
            return 0
        }
    }
    
}

// MARK: - UITableView Data Source

extension CompanyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = company {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mainTitleTableViewCellIdentifier, for: indexPath) as! MainTitleTableViewCell
            if let safeCompany = company {
                //cell.imageURL = safeCompany.IconURL
                //cell.titleName = safeCompany.Name
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: programsListTableViewCellIdentifier) as! ProgramsListTableViewCell
//            cell.hostVC = self
            if let receivedCompany = company {
                cell.programs = receivedCompany.Programs
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
