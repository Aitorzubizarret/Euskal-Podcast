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
        let episodeLastDateFormatted = getLastEpisodeDateFormatted(podcast: podcast)
        
        return "\(episodeNumber) Atal - Azkena: \(episodeLastDateFormatted)"
    }
    
    private func getLastEpisodeDateFormatted(podcast: Podcast) -> String {
        var lastEpisodeDateFormatted = ""
        
        // Get last Episode.
        let lastEpisode = podcast.episodes.max { $0.pubDate < $1.pubDate }
        if let lastEpisode = lastEpisode {
            
            // Get last Episodes pubDate.
            let lastEpisodePubDate = lastEpisode.pubDate
            
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            formatter.locale = Locale(identifier: "eu")
            
            let relativeDate = formatter.localizedString(for: lastEpisodePubDate, relativeTo: Date())
            
            lastEpisodeDateFormatted = relativeDate
        }
        
        return lastEpisodeDateFormatted
    }
    
}
