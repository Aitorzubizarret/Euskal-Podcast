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
    var allChannels: PassthroughSubject<Results<Channel>, Error> { get set }
    var allPrograms: PassthroughSubject<Results<Program>, Error> { get set }
    var foundProgram: PassthroughSubject<Results<Program>, Error> { get set }
    var foundEpisodes: PassthroughSubject<Results<Episode>, Error> { get set }
    
    // MARK: - Methods
    
    func savePrograms(programs: [ProgramXML])
    func saveChannels(channels: [Channel])
    
    func addChannel(channel: Channel)
    func addProgram(program: Program)
    
    func getAllPrograms()
    func getAllChannels()
    
    func deleteAll()
    
    func searchProgram(id: String)
    func searchEpisodes(text: String)
}
