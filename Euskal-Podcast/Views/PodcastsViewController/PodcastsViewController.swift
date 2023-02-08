//
//  PodcastsViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit

class PodcastsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    var coordinator: PodcastsCoordinator
    
    init(coordinator: PodcastsCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Podcastak"
    }
    
}
