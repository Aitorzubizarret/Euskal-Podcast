//
//  ChannelsViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-20.
//

import Foundation
import Combine

final class ChannelsViewModel {
    
    // MARK: - Properties
    
    private var realmManager: RealManagerProtocol
    
    private var subscribedTo: [AnyCancellable] = []
    
    var channels = PassthroughSubject<[Channel], Error>()
    
    // MARK: - Methods
    
    init(realmManager: RealManagerProtocol) {
        self.realmManager = realmManager
        
        subscriptions()
    }
    
    private func subscriptions() {
        realmManager.allChannels.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] channels in
            self?.channels.send(channels.toArray())
        }.store(in: &subscribedTo)
    }
    
    func getChannels() {
        realmManager.getAllChannels()
    }
    
    func deleteChannel(channel: Channel) {
        DispatchQueue.main.async {
            self.realmManager.deleteChannel(channel: channel)
        }
    }
    
}
