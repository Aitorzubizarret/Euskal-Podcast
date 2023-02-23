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
    var foundProgramsWithText = PassthroughSubject<[Program], Error>()
    var foundEpisodesWithText = PassthroughSubject<[Episode], Error>()
    
    // MARK: - Methods
    
    init() {
        realm = try! Realm()
//        do {
//            realm = try Realm()
//        } catch let error {
//            print("RealmManager Init Error : \(error)")
//        }
    }
    
    private func convertStringToInt(value: String) -> Int {
        var result: Int = 0
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        
        let valueComponents = value.components(separatedBy: ":")
        
        switch valueComponents.count {
        case 1:
            seconds = Int(valueComponents[0]) ?? 0
        case 2:
            minutes = Int(valueComponents[0]) ?? 0
            seconds = Int(valueComponents[1]) ?? 0
            if let minutes = Int(valueComponents[0]),
               let seconds = Int(valueComponents[1]) {
                result = (minutes * 60) + seconds
            }
        case 3:
            hours = Int(valueComponents[0]) ?? 0
            minutes = Int(valueComponents[1]) ?? 0
            seconds = Int(valueComponents[2]) ?? 0
        default:
            result = 0
        }
        
        result = (hours * 3600) + (minutes * 60) + seconds
        
        return result
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
                    newEpisode.duration = convertStringToInt(value: episode.duration)
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
                                newEpisode.duration = convertStringToInt(value: episode.duration)
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
    
    func searchTextInProgramsAndEpisodes(text: String) {
        let searchTextInPrograms = realm.objects(Program.self).filter("title contains '\(text)' OR descriptionText contains '\(text)'")
        let searchTextInEpisodes = realm.objects(Episode.self).filter("title contains '\(text)' OR descriptionText contains '\(text)'")
        
        foundProgramsWithText.send(searchTextInPrograms.toArray())
        foundEpisodesWithText.send(searchTextInEpisodes.toArray())
    }
    
}
