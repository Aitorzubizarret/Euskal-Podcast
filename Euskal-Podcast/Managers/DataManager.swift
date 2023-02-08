//
//  DataManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 12/7/22.
//

import Foundation

final class DataManager {
    
    // MARK: - Properties
    
    var sources: [Source] = []
    var companies: [Company] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Companies"), object: nil)
            
            var tempPrograms: [ProgramXML] = []
            for company in companies {
                for program in company.Programs {
                    tempPrograms.append(program)
                }
            }
            programsXML = tempPrograms
        }
    }
    var programs: [Program] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Programs"), object: nil)
        }
    }
    var programsXML: [ProgramXML] = [] {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("Programs"), object: nil)
        }
    }
    
    var apiManager: APIManager
    
    // MARK: - Methods
    
    init() {
        apiManager = APIManager()
    }
    
}

// MARK: - DataManagerProtocol

extension DataManager: DataManagerProtocol {
    
    func setSources(sources: [Source]) {
        self.sources = sources
    }
    
    func getSources() -> [Source] {
        return sources
    }
    
    func setCompanies(companies: [Company]) {
        self.companies = companies
    }
    
    func getCompanies() -> [Company] {
        return companies
    }
    
    func setPrograms(programs: [ProgramXML]) {
        self.programsXML = programs
    }
    
    func getPrograms() -> [ProgramXML] {
        return programsXML
    }
    
    func setProgram(program: ProgramXML) {
        self.programsXML.append(program)
    }
    
}
