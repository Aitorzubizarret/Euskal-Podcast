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
    var programs = PassthroughSubject<[ProgramXML], Error>()
    
    // MARK: - Methods
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        apiManager.programs.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] programs in
            self?.programs.send(programs)
        }.store(in: &subscribedTo)
    }
    
    func getPrograms() {
        apiManager.fetchPrograms()
    }
    
}
