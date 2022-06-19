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
//    func getLocalData() {
//        
//        // Episodes
//        var bertsoZaharrakSeason1Episodes: [Episode] = []
//        let miseriarenAdarrakEpisode1: Episode = Episode(name: "Miseriaren Adarrak",
//                                                         program: "Bertso Zaharrak",
//                                                         mp3Url: "https://www.ivoox.com/miseriaren-adarrak-xenpelarren-bertso-sorta_mf_50074712_feed_1.mp3",
//                                                         duration: "02:19")
//        bertsoZaharrakSeason1Episodes.append(miseriarenAdarrakEpisode1)
//        
//        var hodeiaEzDaExistitzenSeason1Episodes: [Episode] = []
//        let hodeiaEzDaExistitzenEpisode1: Episode = Episode(name: "01",
//                                                            program: "Hodeia Ez Da Existitzen",
//                                                            mp3Url: "https://www.ivoox.com/hodeia-ez-da-existitzen-01_md_60947015_wp_1.mp3",
//                                                            duration: "23:28")
//        hodeiaEzDaExistitzenSeason1Episodes.append(hodeiaEzDaExistitzenEpisode1)
//        let hodeiaEzDaExistitzenEpisode2: Episode = Episode(name: "02",
//                                                            program: "Hodeia Ez Da Existitzen",
//                                                            mp3Url: "https://www.ivoox.com/hodeia-ez-da-existitzen-02_md_64978613_wp_1.mp3",
//                                                            duration: "16:56")
//        hodeiaEzDaExistitzenSeason1Episodes.append(hodeiaEzDaExistitzenEpisode2)
//        let hodeiaEzDaExistitzenEpisode3: Episode = Episode(name: "Gorka Juliori elkarrizketa",
//                                                            program: "Hodeia Ez Da Existitzen",
//                                                            mp3Url: "https://www.ivoox.com/hodeia-ez-da-existitzen-gorka-juliori-elkarrizketa_md_64978721_wp_1.mp3",
//                                                            duration: "35:44")
//        hodeiaEzDaExistitzenSeason1Episodes.append(hodeiaEzDaExistitzenEpisode3)
//        let hodeiaEzDaExistitzenEpisode4: Episode = Episode(name: "03",
//                                                            program: "Hodeia Ez Da Existitzen",
//                                                            mp3Url: "https://www.ivoox.com/hodeia-ez-da-existitzen-03_md_64978753_wp_1.mp3",
//                                                            duration: "35:44")
//        hodeiaEzDaExistitzenSeason1Episodes.append(hodeiaEzDaExistitzenEpisode4)
//        let hodeiaEzDaExistitzenEpisode5: Episode = Episode(name: "Ekaitz Cancellari elkarrizketa",
//                                                            program: "Hodeia Ez Da Existitzen",
//                                                            mp3Url: "https://www.ivoox.com/hodeia-ez-da-existitzen-ekaitz-cancelari-elkarrizketa_md_64978816_wp_1.mp3",
//                                                            duration: "35:44")
//        hodeiaEzDaExistitzenSeason1Episodes.append(hodeiaEzDaExistitzenEpisode5)
//        
//        // Seasons
//        var bertsoZaharrakSeasonList: [Season] = []
//        let bertsoZaharrakSeason1: Season = Season(id: 0,
//                                                   name: "",
//                                                   dateStart: Date(),
//                                                   dateEnd: Date(),
//                                                   episodes: bertsoZaharrakSeason1Episodes)
//        bertsoZaharrakSeasonList.append(bertsoZaharrakSeason1)
//        
//        var hodeiaEzDaExistitzenSeasonList: [Season] = []
//        let hodeiaEzDaExistitzenSeason1: Season = Season(id: 1,
//                                                         name: "",
//                                                         dateStart: Date(),
//                                                         dateEnd: Date(),
//                                                         episodes: hodeiaEzDaExistitzenSeason1Episodes)
//        hodeiaEzDaExistitzenSeasonList.append(hodeiaEzDaExistitzenSeason1)
//        
//        // Programs
//        var programs: [Program] = []
//        
//        let bertsoZaharrak: Program = Program(id: 0,
//                                              name: "Bertso Zaharrak",
//                                              seasons: bertsoZaharrakSeasonList)
//        programs.append(bertsoZaharrak)
//        
//        let hodeiaEzDaExistitzen: Program = Program(id: 0,
//                                                    name: "Hodeia ez da existitzen",
//                                                    seasons: hodeiaEzDaExistitzenSeasonList)
//        programs.append(hodeiaEzDaExistitzen)
//        
//        // Companies
//        var newCompanies: [Company] = []
//        let argia: Company = Company(id: 0,
//                                     name: "Argia",
//                                     programs: programs)
//        newCompanies.append(argia)
//        
//        self.companyList = newCompanies
//    }
}
