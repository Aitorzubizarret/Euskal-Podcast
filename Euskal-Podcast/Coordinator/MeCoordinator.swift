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
    
    func showPodcastList(podcasts: [Podcast]) {
        let podcastListViewModel = PodcastListViewModel(podcasts: podcasts)
        let podcastListVC = PodcastListViewController(coordinator: self, viewModel: podcastListViewModel)
        
        navigationController.show(podcastListVC, sender: nil)
    }
    
    func showPodcastDetail(podcastId: String) {
        let podcastRealmManager: RealManagerProtocol = RealmManager()
        let podcastViewModel = ProgramViewModel(realmManager: podcastRealmManager)
        let podcastVC = ProgramViewController(coordinator: self, viewModel: podcastViewModel, podcastId: podcastId)
        
        navigationController.show(podcastVC, sender: nil)
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
    
    func showSubscriptions() {
        let followingPodcastsRealmManager: RealManagerProtocol = RealmManager()
        let followingPodcastsViewModel = FollowingPodcastsViewModel(realmManager: followingPodcastsRealmManager)
        let followingPodcastsVC = FollowingPodcastsViewController(coordinator: self, viewModel: followingPodcastsViewModel)
        
        navigationController.show(followingPodcastsVC, sender: nil)
    }
    
}
