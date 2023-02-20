//
//  MeCoordinator.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit

final class MeCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Methods
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Coordinator

extension MeCoordinator: Coordinator {
    
    func showProgramDetail(programId: String) {
        let programRealmManager: RealManagerProtocol = RealmManager()
        let programViewModel = ProgramViewModel(realmManager: programRealmManager)
        let programVC = ProgramViewController(coordinator: self, viewModel: programViewModel, programId: programId)
        
        navigationController.show(programVC, sender: nil)
    }
    
    func showEpisodeDetail(episode: Episode) {
        let episodeVC = EpisodeViewController(coordinator: self)
        episodeVC.episode = episode
        
        navigationController.show(episodeVC, sender: nil)
    }
    
    func showChannelList() {
        let channelsRealmManager: RealManagerProtocol = RealmManager()
        let channelsViewModel = ChannelsViewModel(realmManager: channelsRealmManager)
        let channelListVC = ChannelsViewController(coordinator: self, viewModel: channelsViewModel)
        
        navigationController.show(channelListVC, sender: nil)
    }
    
}
