//
//  ProgramsViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 22/05/2021.
//

import UIKit

class ProgramsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let programTableViewCell: String = "ProgramTableViewCell"
    var programs: [Program] = []
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Programak"
        
        self.setupTableView()
    }
    ///
    /// Setup the Table View.
    ///
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "ProgramTableViewCell", bundle: nil)
        self.tableView.register(programCell, forCellReuseIdentifier: self.programTableViewCell)
    }
}

// MARK: - UITableView Delegate

extension ProgramsViewController: UITableViewDelegate {}

// MARK: - UITableView Date Source

extension ProgramsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.programs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.programTableViewCell) as! ProgramTableViewCell
        cell.program = self.programs[indexPath.row]
        return cell
    }
    
}
