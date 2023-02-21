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
    var programs = PassthroughSubject<[Program], Error>()
    
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
            self?.fetchRSSChannels(channels: channels)
        }.store(in: &subscribedTo)
        
        realmManager.allPrograms.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] programs in
            self?.programs.send(programs)
        }.store(in: &subscribedTo)
    }
    
    func fetchChannels() {
        getAllChannels()
    }
    
    func getPrograms() {
        getAllPrograms()
    }
    
}

// MARK: - APIManager methods.

extension PodcastsViewModel {
    
    private func fetchRSSChannels(channels: [Channel]) {
        apiManager.fetchChannels(channels: channels)
    }
    
}

// MARK: - RealmManager methods.

extension PodcastsViewModel {
    
    private func saveProgramsInRealm(programs: [ProgramXML]) {
        realmManager.savePrograms(programs: programs)
    }
    
    private func getAllPrograms() {
        realmManager.getAllPrograms()
    }
    
    private func getAllChannels() {
        realmManager.getAllChannels()
    }
    
    private func deleteAllRealmData() {
        realmManager.deleteAll()
    }
    
}
