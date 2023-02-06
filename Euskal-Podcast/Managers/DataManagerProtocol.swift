//
//  DataManagerProtocol.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 5/2/23.
//

import Foundation

protocol DataManagerProtocol {
    var sources: [Source] { get set }
    var companies: [Company] { get set }
    var programs: [Program] { get set }
    var programsXML: [ProgramXML] { get set }
    var apiManager: APIManager { get set }
    
    func setSources(sources: [Source])
    func getSources() -> [Source]
    func setCompanies(companies: [Company])
    func getCompanies() -> [Company]
    func setPrograms(programs: [ProgramXML])
    func getPrograms() -> [ProgramXML]
    func setProgram(program: ProgramXML)
}
