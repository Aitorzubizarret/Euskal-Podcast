//
//  RealManagerProtocol.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-16.
//

import Foundation
import RealmSwift

protocol RealManagerProtocol {
    var realm: Realm { get set }
    
    func savePrograms(programs: [ProgramXML])
    func addProgram(program: Program)
    func getAllPrograms() -> [Program]
    func deleteAll()
}
