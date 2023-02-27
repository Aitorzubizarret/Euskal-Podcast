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
    var followingPodcasts = PassthroughSubject<[Podcast], Error>()
    
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
            self?.fetchAllChannels(channels)
        }.store(in: &subscribedTo)
        
        realmManager.allPodcasts.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] podcasts in
            self?.podcasts.send(podcasts)
        }.store(in: &subscribedTo)
        
        realmManager.allFollowingPodcasts.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] receivedFollowingPodcasts in
            self?.getPodcastsFromFollowingPodcasts(followingPodcasts: receivedFollowingPodcasts)
        }.store(in: &subscribedTo)

    }
    
    func fetchChannels() {
        getAllChannels()
    }
    
    func getFollowingPodcasts() {
        realmManager.getAllFollowingPodcasts()
    }
    
    func getPodcasts() {
        getAllPodcasts()
    }
    
    func getAmountEpisode(podcast: Podcast) -> String {
        let episodeNumber = podcast.episodes.count
        let lastEpisodesPubDateFormatter = podcast.getLastEpisodesPubDateFormatted()
        
        return "\(episodeNumber) Atal - Azkena: \(lastEpisodesPubDateFormatter)"
    }
    
    private func getPodcastsFromFollowingPodcasts(followingPodcasts: [FollowingPodcast]) {
        var podcasts: [Podcast] = []
        
        for followingPodcast in followingPodcasts {
            if let podcast = followingPodcast.podcast {
                podcasts.append(podcast)
            }
        }
        
        self.followingPodcasts.send(podcasts)
    }
    
}

// MARK: - APIManager methods.

extension PodcastsViewModel {
    
    private func fetchAllChannels(_ channels: [Channel]) {
        for channel in channels {
            self.apiManager.fetchChannel(channel)
        }
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
