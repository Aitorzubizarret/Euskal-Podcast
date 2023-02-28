//
//  RealmManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-15.
//

import Foundation
import RealmSwift
import Combine

final class RealmManager {
    
    // MARK: - Properties
    
    var realm: Realm
    
    // Observable subjets.
    var allChannels = PassthroughSubject<[Channel], Error>()
    var allPodcasts = PassthroughSubject<[Podcast], Error>()
    var allPlayedEpisodes = PassthroughSubject<[PlayedEpisode], Error>()
    var allFollowingPodcasts = PassthroughSubject<[FollowingPodcast], Error>()
    var allNewEpisodes = PassthroughSubject<[Episode], Error>()
    var foundPodcasts = PassthroughSubject<[Podcast], Error>()
    var foundPodcastsWithText = PassthroughSubject<[Podcast], Error>()
    var foundEpisodesWithText = PassthroughSubject<[Episode], Error>()
    var foundFollowingPodcast = PassthroughSubject<FollowingPodcast, Error>()
    var podcastIsBeingFollowed = PassthroughSubject<Bool, Error>()
    
    // MARK: - Methods
    
    init() {
        realm = try! Realm()
//        do {
//            realm = try Realm()
//        } catch let error {
//            print("RealmManager Init Error : \(error)")
//        }
    }
    
}

// MARK: - RealmManagerProtocol

extension RealmManager: RealManagerProtocol {
    
    func savePodcasts(_ podcasts: [Podcast]) {
        for podcast in podcasts {
            // Search the Podcast in Realm DB.
            let foundPodcastsInRealm = realm.objects(Podcast.self).filter("title == '\(podcast.title)' && author == '\(podcast.author)'")
            
            // If no Podcast found save it, and if one Podcast found check the amount of episodes to update them.
            if foundPodcastsInRealm.isEmpty {
                addPodcast(podcast)
                updateChannelDownloaded(channelId: podcast.channelId)
            } else if foundPodcastsInRealm.count == 1 {
                let foundPodcast = foundPodcastsInRealm[0]
                
                if podcast.episodes.count != foundPodcast.episodes.count {
                    // Get the last episode by PubDate.
                    let lastPubDateEpisode: Episode? = foundPodcastsInRealm[0].episodes.max { $0.pubDate < $1.pubDate }
                    
                    // If there is an episode check if it's the last one (using the PubDate) and if new episodes found, save them.
                    if let lastPubDateEpisode = lastPubDateEpisode {
                        for episode in podcast.episodes {
                            if episode.pubDate > lastPubDateEpisode.pubDate {
                                addEpisodeToPodcastInRealm(episode, foundPodcast)
                            }
                        }
                    }
                }
                
            } else {
                print("Duplicate Podcasts?")
            }
        }
        
        let podcasts = realm.objects(Podcast.self)
        allPodcasts.send(podcasts.toArray())
    }
    
    func saveChannels(channels: [Channel]) {
        for channel in channels {
            addChannel(channel: channel)
        }
    }
    
    func addChannel(channel: Channel) {
        do {
            try realm.write({
                realm.add(channel)
            })
        } catch let error {
            print("RealmManager addChannel Error: \(error)")
        }
    }
    
    func addPodcast(_ podcast: Podcast) {
        do {
            try realm.write({
                realm.add(podcast)
            })
        } catch let error {
            print("RealmManager addPodcast Error: \(error)")
        }
    }
    
    func addPlayedEpisode(_ playedEpisode: PlayedEpisode) {
        // Get the last added 'PlayedEpisode'.
        let lastPlayedEpisode = realm.objects(PlayedEpisode.self).sorted(byKeyPath: "date", ascending: false).first
        
        // Check the last saved 'PlayedEpisode's Episode' and the current 'PlayedEpisode's Episode' are not the same Episode.
        if let lastPlayedEpisode = lastPlayedEpisode {
            if let lastEpisode = lastPlayedEpisode.episode,
               let currentEpisode = playedEpisode.episode {
                if lastEpisode.id != currentEpisode.id {
                    do {
                        try realm.write({
                            realm.add(playedEpisode)
                        })
                    } catch let error {
                        print("RealmManager addPlayedEpisode Error: \(error)")
                    }
                }
            }
        } else {
            // There is no "PlayedEpisode" yet in the RealmDB.
            do {
                try realm.write({
                    realm.add(playedEpisode)
                })
            } catch let error {
                print("RealmManager addPlayedEpisode Error: \(error)")
            }
        }
    }
    
    func addEpisodeToPodcastInRealm(_ episode: Episode, _ podcast: Podcast) {
        do {
            try realm.write({
                podcast.episodes.append(episode)
            })
        } catch let error {
            print("Error RealmManager - addEpisodeToPodcastInRealm - \(error)")
        }
    }
    
    func addFollowingPodcast(_ followingPodcast: FollowingPodcast) {
        do {
            try realm.write({
                realm.add(followingPodcast)
                
                podcastIsBeingFollowed.send(true)
            })
        } catch let error {
            print("Error RealmManager - addFollowingPodcast - \(error)")
        }
    }
    
    func getAllChannels() {
        let channels = realm.objects(Channel.self)
        allChannels.send(channels.toArray())
    }
    
    func getAllPodcasts() {
        let podcasts = realm.objects(Podcast.self)
        allPodcasts.send(podcasts.toArray())
    }
    
    func getAllPlayedEpisodes() {
        let playedEpisodes = realm.objects(PlayedEpisode.self).sorted(byKeyPath: "date", ascending: false)
        allPlayedEpisodes.send(playedEpisodes.toArray())
    }
    
    func getAllFollowingPodcasts() {
        let followingPodcasts = realm.objects(FollowingPodcast.self)
        allFollowingPodcasts.send(followingPodcasts.toArray())
    }
    
    func getNewEpisodes() {
        let newEpisodes = realm.objects(Episode.self).sorted(byKeyPath: "pubDate", ascending: true)
        let newEpisodesArray: [Episode] = newEpisodes.toArray()
        let first20NewEpisodes: [Episode] = newEpisodesArray.suffix(21).reversed()
        allNewEpisodes.send(first20NewEpisodes)
    }
    
    func deleteAll() {
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch let error {
            print("RealmMamanager deleteAll Error: \(error)")
        }
    }
    
    func deleteChannel(channel: Channel) {
        do {
            try realm.write({
                // Get the Podcast.
                let podcasts = realm.objects(Podcast.self).filter("channelId == '\(channel.id)'")
                
                // Delete all the Episodes of that Podcast.
                for podcast in podcasts {
                    for episode in podcast.episodes {
                        realm.delete(episode)
                    }
                }
                
                // Delete the Podcasts.
                realm.delete(podcasts)
                
                // Delete the Chanel.
                realm.delete(channel)
            })
        } catch let error {
            print("RealmManager deleteChannel Error: \(error)")
        }
    }
    
    func deleteFollowingPodcast(podcastId: String) {
        let foundFollowingPodcasts = realm.objects(FollowingPodcast.self)
        
        for foundFollowingPodcast in foundFollowingPodcasts {
            if let podcast = foundFollowingPodcast.podcast {
                if podcast.id == podcastId {
                    do {
                        try realm.write({
                            realm.delete(foundFollowingPodcast)
                            
                            podcastIsBeingFollowed.send(false)
                        })
                    } catch let error {
                        print("Error RealmManager - deleteFollowingPodcast - \(error)")
                    }
                    break
                }
            }
        }
    }
    
    func searchPodcast(id: String) {
        let foundPodcast = realm.objects(Podcast.self).filter("id = '\(id)'")
        foundPodcasts.send(foundPodcast.toArray())
    }
    
    func searchTextInPodcastsAndEpisodes(text: String) {
        let searchTextInPrograms = realm.objects(Podcast.self).filter("title contains[c] '\(text)' OR descriptionText contains[c] '\(text)'")
        let searchTextInEpisodes = realm.objects(Episode.self).filter("title contains[c] '\(text)' OR descriptionText contains[c] '\(text)'")
        
        foundPodcastsWithText.send(searchTextInPrograms.toArray())
        foundEpisodesWithText.send(searchTextInEpisodes.toArray())
    }
    
    func searchFollowingPodcast(podcastId: String) {
        let foundFollowingPodcasts = realm.objects(FollowingPodcast.self).filter("podcastId = %@", podcastId)
        
        if !foundFollowingPodcasts.isEmpty && foundFollowingPodcasts.count == 1,
           let followingPodcast = foundFollowingPodcasts.first {
            foundFollowingPodcast.send(followingPodcast)
        }
    }
    
    func searchPodcastInFollowingPodcasts(podcastId: String) {
        var response: Bool = false
        
        let followingPodcasts = realm.objects(FollowingPodcast.self)
        for followingPodcast in followingPodcasts {
            if let podcast = followingPodcast.podcast {
                if podcastId == podcast.id {
                    response = true
                    break
                }
            }
        }
        
        podcastIsBeingFollowed.send(response)
    }
    
    private func updateChannelDownloaded(channelId: String) {
        let foundChannel = realm.objects(Channel.self).filter("id = %@", channelId).first
        
        if let foundChannel = foundChannel {
            do {
                try realm.write {
                    foundChannel.downloaded = true
                }
            } catch let error {
                print("RealmManager updateChannelDownloaded Error: \(error)")
            }
        }
    }
    
}
