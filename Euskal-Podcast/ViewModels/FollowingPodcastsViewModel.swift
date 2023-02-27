//
//  FollowingPodcastsViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-27.
//

import Foundation
import Combine

final class FollowingPodcastsViewModel {
    
    // MARK: - Properties
    
    private var realmManager: RealManagerProtocol
    
    private var subscribedTo: [AnyCancellable] = []
    
    private var followingPodcasts: [FollowingPodcast] = [] {
        didSet {
            getAllPodcastsFromFollowingPodcasts(followingPodcasts)
        }
    }
    
    var podcasts = PassthroughSubject<[Podcast], Error>()
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        realmManager.allFollowingPodcasts.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] followingPodcasts in
            self?.followingPodcasts = followingPodcasts
        }.store(in: &subscribedTo)
    }
    
    func getFollowingPodcasts() {
        realmManager.getAllFollowingPodcasts()
    }
    
    func getAllPodcastsFromFollowingPodcasts(_ followingPodcasts: [FollowingPodcast]) {
        var allPodcasts: [Podcast] = []
        
        for followingPodcast in followingPodcasts {
            if let podcast: Podcast = followingPodcast.podcast {
                allPodcasts.append(podcast)
            }
        }
        
        podcasts.send(allPodcasts)
    }
    
    func getAmountEpisode(podcast: Podcast) -> String {
        let episodeNumber = podcast.episodes.count
        let lastEpisodesPubDateFormatter = podcast.getLastEpisodesPubDateFormatted()
        
        return "\(episodeNumber) Atal - Azkena: \(lastEpisodesPubDateFormatter)"
    }
    
}
