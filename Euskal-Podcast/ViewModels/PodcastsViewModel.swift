//
//  PodcastsViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit
import Combine
import RealmSwift

final class PodcastsViewModel {
    
    // MARK: - Properties
    
    var apiManager: APIManager
    private var subscribedTo: [AnyCancellable] = []
    
    // Observable subjets.
    var programs = PassthroughSubject<Results<Program>, Error>()
    
    private var realmManager: RealManagerProtocol
    
    // MARK: - Methods
    
    init(apiManager: APIManager, realManager: RealManagerProtocol) {
        self.apiManager = apiManager
        self.realmManager = realManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        apiManager.programs.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] programs in
            DispatchQueue.main.async {
                self?.saveProgramsInRealm(programs: programs)
            }
        }.store(in: &subscribedTo)
        
        realmManager.allChannels.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] channels in
            self?.fetchRSSChannels(channels: channels.toArray())
        }.store(in: &subscribedTo)
        
        realmManager.allPrograms.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] programs in
            self?.programs.send(programs)
        }.store(in: &subscribedTo)
    }
    
    func getData() {
        getAllPrograms()
        getAllChannels()
    }
    
}

// MARK: - APIManager methods.

extension PodcastsViewModel {
    
    func fetchRSSChannels(channels: [Channel]) {
        apiManager.fetchChannels(channels: channels)
    }
    
}

// MARK: - RealmManager methods.

extension PodcastsViewModel {
    
    func saveProgramsInRealm(programs: [ProgramXML]) {
        realmManager.savePrograms(programs: programs)
    }
    
    func getAllPrograms() {
        realmManager.getAllPrograms()
    }
    
    func getAllChannels() {
        realmManager.getAllChannels()
    }
    
    func deleteAllRealmData() {
        realmManager.deleteAll()
    }
    
}
