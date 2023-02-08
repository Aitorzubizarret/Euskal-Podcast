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
    
    var coordinator: PodcastsCoordinator?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Podcastak"
    }
    
}
