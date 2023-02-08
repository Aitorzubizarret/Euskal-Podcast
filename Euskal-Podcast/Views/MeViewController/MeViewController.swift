//
//  MeViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit

class MeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    var coordinator: MeCoordinator
    
    // MARK: - Methods
    
    init(coordinator: MeCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ni"
    }
    
}
