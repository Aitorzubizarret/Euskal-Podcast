//
//  EpisodeViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-28.
//

import Foundation

final class EpisodeViewModel {
    
    // MARK: - Properties
    
    var episode: Episode
    
    // MARK: - Methods
    
    init(episode: Episode) {
        self.episode = episode
    }
    
    func getTitle() -> String {
        return episode.title
    }
    
    func getDescription() -> String {
        return episode.descriptionText
    }
    
    func getPubDateFormatter() -> String {
        return episode.getPublishedDateFormatted()
    }
    
    func getExplicit() -> String {
        return episode.explicit
    }
    
    func getAudioFileURL() -> String {
        return episode.audioFileURL
    }
    
    func getAudioFileSize() -> String {
        return episode.getFileSizeFormatted()
    }
    
    func getDurationFormatted() -> String {
        return episode.duration.asTimeFormatted()
    }
    
    func getLink() -> String {
        return episode.link
    }
    
}
