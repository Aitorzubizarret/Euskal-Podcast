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
    
    private let programTableViewCell: String = "ProgramTableViewCell"
    
    public var programs: [Program] = []
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Programak"
        
        setupTableView()
    }
    ///
    /// Setup the Table View.
    ///
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "ProgramTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: programTableViewCell)
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
        return programs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: programTableViewCell) as! ProgramTableViewCell
        cell.program = programs[indexPath.row]
        return cell
    }
    
}
