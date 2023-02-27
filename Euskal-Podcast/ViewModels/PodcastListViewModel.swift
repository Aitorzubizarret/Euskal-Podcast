//
//  PodcastListViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-23.
//

import Foundation

final class PodcastListViewModel {
    
    // MARK: - Properties
    
    var podcasts: [Podcast]
    
    // MARK: - Methods
    
    init(podcasts: [Podcast]) {
        self.podcasts = podcasts
    }
    
    func getAmountPodcasts() -> Int {
        return podcasts.count
    }
    
    func getPodcast(index: Int) -> Podcast {
        return podcasts[index]
    }
    
    func getPodcastId(index: Int) -> String {
        return podcasts[index].id
    }
    
    func getAmountEpisode(index: Int) -> String {
        let episodeNumber = podcasts[index].episodes.count
        let lastEpisodesPubDateFormatter = podcasts[index].getLastEpisodesPubDateFormatted()
        
        return "\(episodeNumber) Atal - Azkena: \(lastEpisodesPubDateFormatter)"
    }
}
