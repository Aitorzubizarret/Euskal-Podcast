//
//  SearchCoordinator.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit

final class SearchCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Methods
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Coordinator

extension SearchCoordinator: Coordinator {
    
    func showPodcastList(programs: [Program]) {
        let podcastListViewModel = PodcastListViewModel(programs: programs)
        let podcastListVC = PodcastListViewController(coordinator: self, viewModel: podcastListViewModel)
        
        navigationController.show(podcastListVC, sender: nil)
    }
    
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
    
    func showPlayedEpisodes() {
        let playedEpisodeRealmManager: RealManagerProtocol = RealmManager()
        let playedEpisodeViewModel = PlayedEpisodesViewModel(realmManager: playedEpisodeRealmManager)
        let playedEpisodesVC = PlayedEpisodesViewController(coordinator: self, viewModel: playedEpisodeViewModel)
        
        navigationController.show(playedEpisodesVC, sender: nil)
    }
    
}
