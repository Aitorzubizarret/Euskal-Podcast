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
        let episodeLastDateFormatted = getLastEpisodeDateFormatted(podcast: podcasts[index])
        
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
