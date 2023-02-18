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
    var program = PassthroughSubject<Results<Program>, Error>()
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
        realmManager.searchProgram.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] programs in
            self?.program.send(programs)
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
    
}

// MARK: - RealmManager methods.

extension ProgramViewModel {
    
    func searchProgram(id: String) {
        realmManager.searchProgram(id: id)
    }
    
}
