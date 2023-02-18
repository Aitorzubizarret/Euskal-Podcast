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
    var realm: Realm { get set }
    var allPrograms: PassthroughSubject<Results<Program>, Error> { get set }
    var foundProgram: PassthroughSubject<Results<Program>, Error> { get set }
    
    func savePrograms(programs: [ProgramXML])
    func addProgram(program: Program)
    func getAllPrograms()
    func deleteAll()
    func searchProgram(id: String)
}
