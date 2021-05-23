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
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Programak"
    }
}
