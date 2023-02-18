//
//  RealmManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-15.
//

import Foundation
import RealmSwift
import Combine

final class RealmManager {
    
    // MARK: - Properties
    
    var realm: Realm
    
    // Observable subjets.
    var allPrograms = PassthroughSubject<Results<Program>, Error>()
    var foundProgram = PassthroughSubject<Results<Program>, Error>()
    
    // MARK: - Methods
    
    init() {
        realm = try! Realm()
//        do {
//            realm = try Realm()
//        } catch let error {
//            print("RealmManager Init Error : \(error)")
//        }
    }
    
}

extension RealmManager: RealManagerProtocol {
    
    func savePrograms(programs: [ProgramXML]) {
        for program in programs {
            // Search Program in the DB before.
            let foundPrograms = realm.objects(Program.self).filter("title = '\(program.title)'")
            if foundPrograms.isEmpty {
                print("NOT Found Program")
                
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
            } else {
                for program in foundPrograms {
                    print("Found Program: \(program.title)")
                }
            }
        }
        
        allPrograms.send(realm.objects(Program.self))
    }
    
    func addProgram(program: Program) {
        do {
            try realm.write({
                realm.add(program)
            })
        } catch let error {
            print("RealmManager addProgram Error: \(error)")
        }
    }
    
//    func getAllPrograms() -> [Program] {
//        let programsResults: Results<Program> = realm.objects(Program.self)
//        let programsArray: [Program] = programsResults.toArray()
//        
//        return programsArray
//    }
    
    func getAllPrograms() {
        allPrograms.send(realm.objects(Program.self))
    }
    
    func deleteAll() {
        let programsResults: Results<Program> = realm.objects(Program.self)
        
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch let error {
            print("RealmMamanager deleteAll Error: \(error)")
        }
    }
    
    func searchProgram(id: String) {
        let foundPrograms = realm.objects(Program.self).filter("id = '\(id)'")
        foundProgram.send(foundPrograms)
    }
    
}
