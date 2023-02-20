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
    
    var foundEpisodes = PassthroughSubject<[Episode], Error>()
    private var subscribedTo: [AnyCancellable] = []
    
    private var realmManager: RealManagerProtocol
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        realmManager.foundEpisodes.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] episodes in
            self?.foundEpisodes.send(episodes.toArray())
        }.store(in: &subscribedTo)
    }
    
}

// MARK: - RealmManager methods.

extension SearchViewModel {
    
    func searchEpisodes(text: String) {
        realmManager.searchEpisodes(text: text)
    }
    
}