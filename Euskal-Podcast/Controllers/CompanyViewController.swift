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
    
    let companyDetailTableViewCellIdentifier: String = "CompanyDetailTableViewCell"
    let programsListTableViewCellIdentifier: String = "ProgramsListTableViewCell"
    var company: Company? {
        didSet {
            guard let receivedCompany = company else { return }
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    ///
    /// Setup the TableView.
    ///
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cells.
        let companyDetailCell: UINib = UINib(nibName: "CompanyDetailTableViewCell", bundle: nil)
        tableView.register(companyDetailCell, forCellReuseIdentifier: self.companyDetailTableViewCellIdentifier)
        
        let programsList: UINib = UINib(nibName: "ProgramsListTableViewCell", bundle: nil)
        tableView.register(programsList, forCellReuseIdentifier: self.programsListTableViewCellIdentifier)
    }
}

// MARK: - UITableView Delegate

extension CompanyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 235
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: companyDetailTableViewCellIdentifier) as! CompanyDetailTableViewCell
            if let receivedCompany = self.company {
                cell.company = receivedCompany
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: programsListTableViewCellIdentifier) as! ProgramsListTableViewCell
            cell.hostVC = self
            if let receivedCompany = company {
                cell.programs = receivedCompany.Programs
            }
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
}
