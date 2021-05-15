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
    
    var company: Company? {
        didSet {
            guard let receivedCompany = self.company else { return }
            
            self.title = receivedCompany.name
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    ///
    /// Setup the TableView.
    ///
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: - UITableView Delegate

extension CompanyViewController: UITableViewDelegate {}

// MARK: - UITableView Data Source

extension CompanyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = "Company"
        return cell
    }
    
}
