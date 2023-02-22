//
//  ProgramViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-17.
//

import Foundation
import RealmSwift
import Combine

final class ProgramViewModel {
    
    // MARK: - Properties
    
    private var realmManager: RealManagerProtocol
    
    private var subscribedTo: [AnyCancellable] = []
    
    // Observable subjets.
    var program = PassthroughSubject<Program, Error>()
    var episodes = PassthroughSubject<[Episode], Error>()
    var audioIsPlaying = PassthroughSubject<Bool, Error>()
    
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        setupNotificationsObservers()
        subscriptions()
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(audioPlaying),
                                       name: .songPlaying,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(audioPause),
                                       name: .songPause,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(audioFinished),
                                       name: .audioFinished,
                                       object: nil)
    }
    
    private func subscriptions() {
        realmManager.foundProgram.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] program in
            DispatchQueue.main.async {
                self?.checkFoundProgramIsNotEmptyAndHasOnlyOne(foundProgram: program)
            }
        }.store(in: &subscribedTo)
    }
    
    @objc private func audioPlaying() {
        audioIsPlaying.send(true)
    }
    
    @objc private func audioPause() {
        audioIsPlaying.send(false)
    }
    
    @objc private func audioFinished() {
        audioIsPlaying.send(false)
    }
    
    private func checkFoundProgramIsNotEmptyAndHasOnlyOne(foundProgram: [Program]) {
        if !foundProgram.isEmpty && foundProgram.count == 1 {
            guard let onlyFoundProgram = foundProgram.first else { return }
            
            self.program.send(onlyFoundProgram)
            orderEpisodesByDate(program: onlyFoundProgram, asc: false)
        }
    }
    
    func orderEpisodesByDate(program: Program, asc: Bool) {
        var orderedEpisodes: [Episode] = []
        
        if asc {
            orderedEpisodes = program.episodes.sorted(by: { $0.pubDate < $1.pubDate })
        } else {
            orderedEpisodes = program.episodes.sorted(by: { $0.pubDate > $1.pubDate })
        }
        
        self.episodes.send(orderedEpisodes)
    }
    
    func checkEpisodeIsPlaying(episodeId: String) -> Bool {
        let playingEpisodeId = AudioManager.shared.getEpisodeId()
        return (playingEpisodeId == episodeId) ? true : false
    }
    
    func checkAudioIsPlaying() -> Bool {
        return AudioManager.shared.isPlaying()
    }
    
    func playEpisode() {
        AudioManager.shared.playSong()
    }
    
    func playEpisode(episode: Episode, program: Program) {
        AudioManager.shared.playSong(episode: episode, program: program)
    }
    
    func pauseEpisode() {
        AudioManager.shared.pauseSong()
    }
    
    func getEpisodesInfoAndProgramCopyright(program: Program) -> String {
        var result: String = ""
        
        // Episodes Info.
        switch program.episodes.count {
        case 1:
            result = "Atal 1"
        default:
            result = "\(program.episodes.count) Atal"
        }
        
        // Copyright Info.
        result = result + " - " + program.copyright
        
        return result
    }
    
}

// MARK: - RealmManager methods.

extension ProgramViewModel {
    
    func searchProgram(id: String) {
        realmManager.searchProgram(id: id)
    }
    
}
