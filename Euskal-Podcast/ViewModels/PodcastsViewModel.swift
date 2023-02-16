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
            DispatchQueue.main.async {
                self?.saveProgramsInRealm(programs: programs)
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
    
    func saveProgramsInRealm(programs: [ProgramXML]) {
        realmManager.savePrograms(programs: programs)
    }
    
    func getRealmData() {
        programs.send(realmManager.getAllPrograms())
    }
    
    func deleteAllRealmData() {
        realmManager.deleteAll()
    }
    
}
