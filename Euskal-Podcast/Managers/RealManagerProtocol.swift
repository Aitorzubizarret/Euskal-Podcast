//
//  RealManagerProtocol.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-16.
//

import Foundation
import RealmSwift
import Combine

protocol RealManagerProtocol {
    
    // MARK: - Properties
    
    var realm: Realm { get set }
    var allChannels: PassthroughSubject<[Channel], Error> { get set }
    var allPodcasts: PassthroughSubject<[Podcast], Error> { get set }
    var allPlayedEpisodes: PassthroughSubject<[PlayedEpisode], Error> { get set }
    var foundPodcasts: PassthroughSubject<[Podcast], Error> { get set }
    var foundPodcastsWithText: PassthroughSubject<[Podcast], Error> { get set }
    var foundEpisodesWithText: PassthroughSubject<[Episode], Error> { get set }
    
    // MARK: - Methods
    
    func savePodcasts(_ podcasts: [Podcast])
    func saveChannels(channels: [Channel])
    
    func addChannel(channel: Channel)
    func addPodcast(_ podcast: Podcast)
    func addPlayedEpisode(_ playedEpisode: PlayedEpisode)
    func addEpisodeToPodcastInRealm(_ episode: Episode, _ podcast: Podcast)
    
    func getAllChannels()
    func getAllPodcasts()
    func getAllPlayedEpisodes()
    
    func deleteAll()
    func deleteChannel(channel: Channel)
    
    func searchPodcast(id: String)
    func searchTextInPodcastsAndEpisodes(text: String)
}
