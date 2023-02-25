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
    var allPlayedEpisodes = PassthroughSubject<[PlayedEpisode], Error>()
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
    
}

// MARK: - RealmManagerProtocol

extension RealmManager: RealManagerProtocol {
    
    func savePrograms(_ programs: [Program]) {
        for program in programs {
            // Search the Program in the Realm DB.
            let foundProgramsInRealm = realm.objects(Program.self).filter("title == '\(program.title)' && author == '\(program.author)'")
            
            // If no program found save it, and if one program found check the amount of episode to update them.
            if foundProgramsInRealm.isEmpty {
                addProgram(program: program)
            } else if foundProgramsInRealm.count == 1 {
                let foundProgram = foundProgramsInRealm[0]
                
                if program.episodes.count != foundProgram.episodes.count {
                    // Get the last episode by PubDate.
                    let lastPubDateEpisode: Episode? = foundProgramsInRealm[0].episodes.max { $0.pubDate < $1.pubDate }
                    
                    // If there is an episode check if it's the last one (using the PubDate) and if new episodes found, save them.
                    if let lastPubDateEpisode = lastPubDateEpisode {
                        for episode in program.episodes {
                            if episode.pubDate > lastPubDateEpisode.pubDate {                                
                                addEpisodeToProgramInRealm(program: foundProgram, episode: episode)
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
    
    func addPlayedEpisode(_ playedEpisode: PlayedEpisode) {
        // Get the last added 'PlayedEpisode'.
        let lastPlayedEpisode = realm.objects(PlayedEpisode.self).sorted(byKeyPath: "date", ascending: false).first
        
        // Check the last saved 'PlayedEpisode's Episode' and the current 'PlayedEpisode's Episode' are not the same Episode.
        if let lastPlayedEpisode = lastPlayedEpisode,
           let lastEpisode = lastPlayedEpisode.episode,
           let currentEpisode = playedEpisode.episode {
            if lastEpisode.id != currentEpisode.id {
                do {
                    try realm.write({
                        realm.add(playedEpisode)
                    })
                } catch let error {
                    print("RealmManager addPlayedEpisode Error: \(error)")
                }
            }
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
    
    func getAllChannels() {
        let channels = realm.objects(Channel.self)
        allChannels.send(channels.toArray())
    }
    
    func getAllPrograms() {
        let programs = realm.objects(Program.self)
        allPrograms.send(programs.toArray())
    }
    
    func getAllPlayedEpisodes() {
        let playedEpisodes = realm.objects(PlayedEpisode.self).sorted(byKeyPath: "date", ascending: false)
        allPlayedEpisodes.send(playedEpisodes.toArray())
    }
    
    func deleteAll() {
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
        let searchTextInPrograms = realm.objects(Program.self).filter("title contains[c] '\(text)' OR descriptionText contains[c] '\(text)'")
        let searchTextInEpisodes = realm.objects(Episode.self).filter("title contains[c] '\(text)' OR descriptionText contains[c] '\(text)'")
        
        foundProgramsWithText.send(searchTextInPrograms.toArray())
        foundEpisodesWithText.send(searchTextInEpisodes.toArray())
    }
    
}
