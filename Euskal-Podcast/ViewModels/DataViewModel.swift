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
    var companyList: [Company]? {
        didSet {
            self.binding()
        }
    }
    
    // MARK: - Methods
    
    ///
    /// Get Local Data.
    ///
    func getLocalData() {
        
        // Episodes
        var newEpisodes: [Episode] = []
        let episode1: Episode = Episode(name: "Miseriaren Adarrak",
                                       program: "Bertso Zaharrak",
                                       mp3Url: "https://www.ivoox.com/miseriaren-adarrak-xenpelarren-bertso-sorta_mf_50074712_feed_1.mp3",
                                       duration: "02:19")
        newEpisodes.append(episode1)
        
        // Seasons
        var newSeasons: [Season] = []
        let season1: Season = Season(id: 0,
                                     name: "",
                                     dateStart: Date(),
                                     dateEnd: Date(),
                                     episodes: newEpisodes)
        newSeasons.append(season1)
        
        // Programs
        var newPrograms: [Program] = []
        let program1: Program = Program(id: 0,
                                              name: "Bertso Zaharrak",
                                              seasons: newSeasons)
        newPrograms.append(program1)
        
        // Companies
        var newCompanies: [Company] = []
        let company1: Company = Company(id: 0,
                                     name: "Argia",
                                     programs: newPrograms)
        newCompanies.append(company1)
        
        self.companyList = newCompanies
    }
}
