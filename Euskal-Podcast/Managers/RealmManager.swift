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
    var allChannels = PassthroughSubject<[Channel], Error>()
    var allPrograms = PassthroughSubject<[Program], Error>()
    var foundProgram = PassthroughSubject<[Program], Error>()
    var foundEpisodes = PassthroughSubject<[Episode], Error>()
    
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
            let foundProgramsInRealm = realm.objects(Program.self).filter("title == '\(program.title)' && author == '\(program.author)'")
            
            if foundProgramsInRealm.isEmpty {
                // Create the Object.
                let newProgram = Program()
                newProgram.channelId = program.channelId
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
            } else if foundProgramsInRealm.count == 1 {
                let foundProgram = foundProgramsInRealm[0]
                if program.episodes.count != foundProgram.episodes.count {
                    
                    // Get the last episode by PubDate.
                    let lastPubDateEpisode: Episode? = foundProgramsInRealm[0].episodes.max { $0.pubDate < $1.pubDate }
                    
                    if let lastPubDateEpisode = lastPubDateEpisode {
                        for episode in program.episodes {
                            if episode.pubDate > lastPubDateEpisode.pubDate {
                                let newEpisode = Episode()
                                newEpisode.title = episode.title
                                newEpisode.descriptionText = episode.description
                                newEpisode.pubDate = episode.pubDate
                                newEpisode.explicit = episode.explicit
                                newEpisode.audioFileURL = episode.audioFileURL
                                newEpisode.audioFileSize = episode.audioFileSize
                                newEpisode.duration = episode.duration
                                newEpisode.link = episode.link
                                
                                addEpisodeToProgramInRealm(program: foundProgram, episode: newEpisode)
                            }
                        }
                    }
                }
                
            } else {
                print("Duplicate programs?")
            }
        }
        
        let programs = realm.objects(Program.self)
        allPrograms.send(programs.toArray())
    }
    
    func saveChannels(channels: [Channel]) {
        for channel in channels {
            addChannel(channel: channel)
        }
    }
    
    func addChannel(channel: Channel) {
        do {
            try realm.write({
                realm.add(channel)
            })
        } catch let error {
            print("RealmManager addChannel Error: \(error)")
        }
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
    
    func addEpisodeToProgramInRealm(program: Program, episode: Episode) {
        do {
            try realm.write({
                program.episodes.append(episode)
            })
        } catch let error {
            print("Error RealmManager - addEpisodeToProgram - \(error)")
        }
    }
    
    func getAllPrograms() {
        let programs = realm.objects(Program.self)
        allPrograms.send(programs.toArray())
    }
    
    func getAllChannels() {
        let channels = realm.objects(Channel.self)
        allChannels.send(channels.toArray())
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
    
    func deleteChannel(channel: Channel) {
        do {
            try realm.write({
                // Get the Program.
                let programs = realm.objects(Program.self).filter("channelId == '\(channel.id)'")
                
                // Delete all the Episodes of that Program.
                for program in programs {
                    for episode in program.episodes {
                        realm.delete(episode)
                    }
                }
                
                // Delete the Program.
                realm.delete(programs)
                
                // Delete the Chanell.
                realm.delete(channel)
            })
        } catch let error {
            print("RealmManager deleteChannel Error: \(error)")
        }
    }
    
    func searchProgram(id: String) {
        let foundPrograms = realm.objects(Program.self).filter("id = '\(id)'")
        foundProgram.send(foundPrograms.toArray())
    }
    
    func searchEpisodes(text: String) {
        let searchResultsEpisodes = realm.objects(Episode.self).filter("title contains '\(text)'")
        foundEpisodes.send(searchResultsEpisodes.toArray())
    }
    
}
