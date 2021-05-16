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
    
    let programsListTableViewCellIdentifier: String = "ProgramsListTableViewCell"
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
        
        // Register cells.
        let programsList: UINib = UINib(nibName: "ProgramsListTableViewCell", bundle: nil)
        self.tableView.register(programsList, forCellReuseIdentifier: self.programsListTableViewCellIdentifier)
    }
}

// MARK: - UITableView Delegate

extension CompanyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }
    
}

// MARK: - UITableView Data Source

extension CompanyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.programsListTableViewCellIdentifier) as! ProgramsListTableViewCell
        return cell
        
    }
    
}
