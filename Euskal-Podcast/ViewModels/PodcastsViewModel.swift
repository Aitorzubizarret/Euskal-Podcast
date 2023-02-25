//
//  PodcastsViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit
import Combine
import RealmSwift

final class PodcastsViewModel {
    
    // MARK: - Properties
    
    var apiManager: APIManager
    private var subscribedTo: [AnyCancellable] = []
    
    // Observable subjets.
    var podcasts = PassthroughSubject<[Podcast], Error>()
    
    private var realmManager: RealManagerProtocol
    
    // MARK: - Methods
    
    init(apiManager: APIManager, realManager: RealManagerProtocol) {
        self.apiManager = apiManager
        self.realmManager = realManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        apiManager.podcasts.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] podcasts in
            DispatchQueue.main.async {
                self?.savePodcastsInRealm(podcasts: podcasts)
            }
        }.store(in: &subscribedTo)
        
        realmManager.allChannels.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] channels in
            self?.fetchRSSChannels(channels: channels)
        }.store(in: &subscribedTo)
        
        realmManager.allPodcasts.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] podcasts in
            self?.podcasts.send(podcasts)
        }.store(in: &subscribedTo)
    }
    
    func fetchChannels() {
        getAllChannels()
    }
    
    func getPodcasts() {
        getAllPodcasts()
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

// MARK: - APIManager methods.

extension PodcastsViewModel {
    
    private func fetchRSSChannels(channels: [Channel]) {
        apiManager.fetchChannels(channels: channels)
    }
    
}

// MARK: - RealmManager methods.

extension PodcastsViewModel {
    
    private func savePodcastsInRealm(podcasts: [Podcast]) {
        realmManager.savePodcasts(podcasts)
    }
    
    private func getAllPodcasts() {
        realmManager.getAllPodcasts()
    }
    
    private func getAllChannels() {
        realmManager.getAllChannels()
    }
    
    private func deleteAllRealmData() {
        realmManager.deleteAll()
    }
    
}
