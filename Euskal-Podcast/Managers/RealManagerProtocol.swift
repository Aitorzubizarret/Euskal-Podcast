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
    var foundPodcasts: PassthroughSubject<[Podcast], Error> { get set }
    var foundPodcastsWithText: PassthroughSubject<[Podcast], Error> { get set }
    
    var foundEpisodesWithText: PassthroughSubject<[Episode], Error> { get set }
    
    var allPlayedEpisodes: PassthroughSubject<[PlayedEpisode], Error> { get set }
    
    var allFollowingPodcasts: PassthroughSubject<[FollowingPodcast], Error> { get set }
    var podcastIsBeingFollowed: PassthroughSubject<Bool, Error> { get set }
    
    var allNewEpisodes: PassthroughSubject<[Episode], Error> { get set }
    
    
    
    
    
    // MARK: - Methods
    
    func getAllChannels()
    func saveChannels(_ channels: [Channel])
    func addChannel(_ channel: Channel)
    func deleteChannel(_ channel: Channel)
    
    func getAllPodcasts()
    func savePodcasts(_ podcasts: [Podcast])
    func addPodcast(_ podcast: Podcast)
    func searchPodcastById(_ id: String)
    func searchTextInPodcasts(_ text: String)
    
    func searchTextInEpisodes(_ text: String)
    
    func getAllPlayedEpisodes()
    func addPlayedEpisode(_ playedEpisode: PlayedEpisode)
    func addEpisodeToPodcastInRealm(_ episode: Episode, _ podcast: Podcast)
    
    func getAllFollowingPodcasts()
    func addFollowingPodcast(_ followingPodcast: FollowingPodcast)
    func deleteFollowingPodcastById(_ id: String)
    func searchPodcastInFollowingPodcastsById(_ id: String)
    
    func getNewEpisodes()
    
    func deleteAll()
    
}
