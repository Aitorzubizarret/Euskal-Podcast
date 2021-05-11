//
//  DataViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 11/05/2021.
//

import UIKit

class DataViewModel {
    
    // MARK: - Properties
    
    // Binding.
    var binding = { () -> () in }
    
    // Data Source.
    var episodesList: [Episode]? {
        didSet {
            self.binding()
        }
    }
    
    // MARK: - Methods
    
    ///
    /// Get Local Data.
    ///
    func getLocalData() {
        var newEpisodes: [Episode] = []
        let episode1: Episode = Episode(name: "Miseriaren Adarrak",
                                       program: "Bertso Zaharrak",
                                       mp3Url: "https://www.ivoox.com/miseriaren-adarrak-xenpelarren-bertso-sorta_mf_50074712_feed_1.mp3",
                                       duration: "02:19")
        newEpisodes.append(episode1)
        
        self.episodesList = newEpisodes
    }
}
