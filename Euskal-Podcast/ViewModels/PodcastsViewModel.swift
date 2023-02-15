//
//  PodcastsViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit
import Combine

final class PodcastsViewModel {
    
    // MARK: - Properties
    
    var apiManager: APIManager
    private var subscribedTo: [AnyCancellable] = []
    
    var allPrograms: [ProgramXML] = []
    
    // Observable subjets.
    var programs = PassthroughSubject<[Program], Error>()
    
    private var realmManager = RealmManager() // TODO: - Make this better.
    
    // MARK: - Methods
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        apiManager.programs.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] programs in
            //self?.programs.send(programs)
            DispatchQueue.main.async { [weak self] in
                self?.saveProgramsToRealm(programs: programs)
            }
        }.store(in: &subscribedTo)
    }
    
    func getData() {
        //fetchRSSPrograms()
        getRealmData()
        //deleteAllRealmData()
    }
    
}

// MARK: - APIManager methods.

extension PodcastsViewModel {
    
    func fetchRSSPrograms() {
        apiManager.fetchPrograms()
    }
    
}

// MARK: - RealmManager methods.

extension PodcastsViewModel {
    
    func saveProgramsToRealm(programs: [ProgramXML]) {
        for program in programs {
            // Create the Object.
            let newProgram = Program()
            newProgram.title = program.title
            newProgram.descriptionText = program.description
            newProgram.category = program.category
            newProgram.imageURL = program.imageURL
            newProgram.explicit = program.explicit
            newProgram.language = program.language
            newProgram.author = program.author
            newProgram.link = program.link
            newProgram.copyright = program.copyright
            newProgram.copyrightOwnerName = program.copyrightOwnerName
            newProgram.copyrightOwnerEmail = program.copyrightOwnerEmail
            
            for episode in program.episodes {
                let newEpisode = Episode()
                newEpisode.title = episode.title
                newEpisode.descriptionText = episode.description
                newEpisode.pubDate = episode.pubDate
                newEpisode.explicit = episode.explicit
                newEpisode.audioFileURL = episode.audioFileURL
                newEpisode.audioFileSize = episode.audioFileSize
                newEpisode.duration = episode.duration
                newEpisode.link = episode.link

                newProgram.episodes.append(newEpisode)
            }
            
            realmManager.addProgram(program: newProgram)
        }
    }
    
    func getRealmData() {
        programs.send(realmManager.getAllPrograms())
    }
    
    func deleteAllRealmData() {
        realmManager.deleteAll()
    }
    
}
