//
//  PodcastListViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-23.
//

import Foundation

final class PodcastListViewModel {
    
    // MARK: - Properties
    
    var programs: [Program]
    
    // MARK: - Methods
    
    init(programs: [Program]) {
        self.programs = programs
    }
    
    func getAmountPrograms() -> Int {
        return programs.count
    }
    
    func getProgram(index: Int) -> Program {
        return programs[index]
    }
    
    func getProgramId(index: Int) -> String {
        return programs[index].id
    }
    
    func getAmountEpisode(index: Int) -> String {
        let episodeNumber = programs[index].episodes.count
        let episodeLastDateFormatted = getLastEpisodeDateFormatted(program: programs[index])
        
        return "\(episodeNumber) Atal - Azkena: \(episodeLastDateFormatted)"
    }
    
    private func getLastEpisodeDateFormatted(program: Program) -> String {
        var lastEpisodeDateFormatted = ""
        
        // Get last Episode.
        let lastEpisode = program.episodes.max { $0.pubDate < $1.pubDate }
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
