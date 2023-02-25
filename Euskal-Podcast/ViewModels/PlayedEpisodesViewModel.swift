//
//  PlayedEpisodesViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-25.
//

import Foundation
import Combine

final class PlayedEpisodesViewModel {
    
    // MARK: - Properties
    
    private var realmManager: RealManagerProtocol
    
    var playedEpisodes = PassthroughSubject<[PlayedEpisode], Error>()
    private var subscribedTo: [AnyCancellable] = []
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        realmManager.allPlayedEpisodes.sink { receiveCompletion in
            print("Received Completion")
        } receiveValue: { [weak self] playedEpisodes in
            self?.playedEpisodes.send(playedEpisodes)
        }.store(in: &subscribedTo)

    }
    
    func getPlayedEpisodes() {
        realmManager.getAllPlayedEpisodes()
    }
    
    func getPodcastImageFromEpisodeId(_ episodeId: String) -> String {
        return ""
    }
    
    func getPodcastNameFromEpisodeId(_ episodeId: String) -> String {
        return "Yoko Ona"
    }
    
}
