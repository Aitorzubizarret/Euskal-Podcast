//
//  SearchViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-19.
//

import Foundation
import RealmSwift
import Combine

final class SearchViewModel {
    
    // MARK: - Properties
    
    var foundPrograms = PassthroughSubject<[Program], Error>()
    var foundEpisodes = PassthroughSubject<[Episode], Error>()
    private var subscribedTo: [AnyCancellable] = []
    
    private var realmManager: RealManagerProtocol
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        realmManager.foundProgramsWithText.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] programs in
            self?.foundPrograms.send(programs)
        }.store(in: &subscribedTo)
        
        realmManager.foundEpisodesWithText.sink { receiveCompletion in
            print("Receive completion")
        } receiveValue: { [weak self] episodes in
            self?.foundEpisodes.send(episodes)
        }.store(in: &subscribedTo)
    }
    
}

// MARK: - RealmManager methods.

extension SearchViewModel {
    
    func searchTextInProgramsAndEpisodes(text: String) {
        realmManager.searchTextInProgramsAndEpisodes(text: text)
    }
    
}
