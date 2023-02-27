//
//  ProgramViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-17.
//

import Foundation
import RealmSwift
import Combine

final class ProgramViewModel {
    
    // MARK: - Properties
    
    private var realmManager: RealManagerProtocol
    
    private var subscribedTo: [AnyCancellable] = []
    
    // Observable subjets.
    var podcast = PassthroughSubject<Podcast, Error>()
    var episodes = PassthroughSubject<[Episode], Error>()
    var audioIsPlaying = PassthroughSubject<Bool, Error>()
    var podcastIsBeingFollowed = PassthroughSubject<Bool, Error>()
    
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        setupNotificationsObservers()
        subscriptions()
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(audioPlaying),
                                       name: .songPlaying,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(audioPause),
                                       name: .songPause,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(audioFinished),
                                       name: .audioFinished,
                                       object: nil)
    }
    
    private func subscriptions() {
        realmManager.foundPodcasts.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] podcasts in
            DispatchQueue.main.async {
                self?.checkFoundPodcastsIsNotEmptyAndHasOnlyOne(foundPodcasts: podcasts)
            }
        }.store(in: &subscribedTo)
        
        realmManager.podcastIsBeingFollowed.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] isBeingFollowed in
            self?.podcastIsBeingFollowed.send(isBeingFollowed)
        }.store(in: &subscribedTo)

    }
    
    @objc private func audioPlaying() {
        audioIsPlaying.send(true)
    }
    
    @objc private func audioPause() {
        audioIsPlaying.send(false)
    }
    
    @objc private func audioFinished() {
        audioIsPlaying.send(false)
    }
    
    private func checkFoundPodcastsIsNotEmptyAndHasOnlyOne(foundPodcasts: [Podcast]) {
        if !foundPodcasts.isEmpty && foundPodcasts.count == 1 {
            guard let onlyFoundPodcast = foundPodcasts.first else { return }
            
            self.podcast.send(onlyFoundPodcast)
            orderEpisodesByDate(podcast: onlyFoundPodcast, asc: false)
        }
    }
    
    func orderEpisodesByDate(podcast: Podcast, asc: Bool) {
        var orderedEpisodes: [Episode] = []
        
        if asc {
            orderedEpisodes = podcast.episodes.sorted(by: { $0.pubDate < $1.pubDate })
        } else {
            orderedEpisodes = podcast.episodes.sorted(by: { $0.pubDate > $1.pubDate })
        }
        
        self.episodes.send(orderedEpisodes)
    }
    
    func checkEpisodeIsPlaying(episodeId: String) -> Bool {
        let playingEpisodeId = AudioManager.shared.getEpisodeId()
        return (playingEpisodeId == episodeId) ? true : false
    }
    
    func checkAudioIsPlaying() -> Bool {
        return AudioManager.shared.isPlaying()
    }
    
    func playEpisode() {
        AudioManager.shared.playSong()
    }
    
    func playEpisode(episode: Episode, podcast: Podcast) {
        AudioManager.shared.playSong(episode: episode, podcast: podcast)
        
        let playedEpisode = PlayedEpisode()
        playedEpisode.episode = episode
        realmManager.addPlayedEpisode(playedEpisode)
    }
    
    func pauseEpisode() {
        AudioManager.shared.pauseSong()
    }
    
    func getEpisodesInfoAndPodcastCopyright(podcast: Podcast) -> String {
        var result: String = ""
        
        // Episodes Info.
        switch podcast.episodes.count {
        case 1:
            result = "Atal 1"
        default:
            result = "\(podcast.episodes.count) Atal"
        }
        
        // Copyright Info.
        result = result + " - " + podcast.copyright
        
        return result
    }
    
    func followPodcast(podcast: Podcast) {
        let followingPodcast = FollowingPodcast()
        followingPodcast.podcast = podcast
        
        realmManager.addFollowingPodcast(followingPodcast)
    }
    
    func unfollowPodcast(podcast: Podcast) {
        realmManager.deleteFollowingPodcast(podcastId: podcast.id)
    }
    
}

// MARK: - RealmManager methods.

extension ProgramViewModel {
    
    func searchProgram(id: String) {
        realmManager.searchPodcast(id: id)
    }
    
    func checkPodcastIsBeingFollowed(_ podcast: Podcast) {
        realmManager.searchPodcastInFollowingPodcasts(podcastId: podcast.id)
    }
    
}
