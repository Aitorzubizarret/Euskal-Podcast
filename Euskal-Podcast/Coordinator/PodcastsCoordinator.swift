//
//  PodcastsCoordinator.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit

final class PodcastsCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Methods
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Coordinator

extension PodcastsCoordinator: Coordinator {
    
    func showProgramDetail(program: Program) {
        let programVC = ProgramViewController(coordinator: self)
        programVC.program = program
        
        navigationController.show(programVC, sender: nil)
    }
    
    func showEpisodeDetail(episode: Episode) {
        let episodeVC = EpisodeViewController(coordinator: self)
        episodeVC.episode = episode
        
        navigationController.show(episodeVC, sender: nil)
    }
    
}