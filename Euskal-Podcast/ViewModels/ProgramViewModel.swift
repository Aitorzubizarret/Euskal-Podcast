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
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        realmManager.searchProgram.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] programs in
            self?.program.send(programs)
        }.store(in: &subscribedTo)

    }
    
}

// MARK: - RealmManager methods.

extension ProgramViewModel {
    
    func searchProgram(id: String) {
        realmManager.searchProgram(id: id)
    }
    
}
