//
//  RealManagerProtocol.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-16.
//

import Foundation
import RealmSwift
import Combine

protocol RealManagerProtocol {
    
    // MARK: - Properties
    
    var realm: Realm { get set }
    var allChannels: PassthroughSubject<[Channel], Error> { get set }
    var allPrograms: PassthroughSubject<[Program], Error> { get set }
    var foundProgram: PassthroughSubject<[Program], Error> { get set }
    var foundEpisodes: PassthroughSubject<[Episode], Error> { get set }
    
    // MARK: - Methods
    
    func savePrograms(programs: [ProgramXML])
    func saveChannels(channels: [Channel])
    
    func addChannel(channel: Channel)
    func addProgram(program: Program)
    
    func getAllPrograms()
    func getAllChannels()
    
    func deleteAll()
    func deleteChannel(channel: Channel)
    
    func searchProgram(id: String)
    func searchEpisodes(text: String)
}
