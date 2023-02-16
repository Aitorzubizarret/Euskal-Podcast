//
//  RealmManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-15.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    // MARK: - Properties
    
    private var realm: Realm?
    
    // MARK: - Methods
    
    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("RealmManager Init Error : \(error)")
        }
    }
    
    func savePrograms(programs: [ProgramXML]) {
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
            
            addProgram(program: newProgram)
        }
    }
    
    func addProgram(program: Program) {
        guard let realm = realm else { return }
        
        do {
            try realm.write({
                realm.add(program)
            })
        } catch let error {
            print("RealmManager addProgram Error: \(error)")
        }
    }
    
    func getAllPrograms() -> [Program] {
        guard let realm = realm else { return [] }
        
        let programsResults: Results<Program> = realm.objects(Program.self)
        let programsArray: [Program] = programsResults.toArray()
        
        return programsArray
    }
    
    func deleteAll() {
        guard let realm = realm else { return }
        
        let programsResults: Results<Program> = realm.objects(Program.self)
        
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch let error {
            print("RealmMamanager deleteAll Error: \(error)")
        }
    }
    
}
