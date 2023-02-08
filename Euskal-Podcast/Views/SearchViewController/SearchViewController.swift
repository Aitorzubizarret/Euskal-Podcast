//
//  SearchViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    var coordinator: SearchCoordinator
    
    // MARK: - Methods
    
    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bilatu"
    }
    
}
