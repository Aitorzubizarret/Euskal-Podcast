//
//  APIManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 18/6/22.
//

import Foundation
import Combine

final class APIManager {
    
    // MARK: - Properties
    
    private var xmlParserManager: XMLParserManager = XMLParserManager()
    private var subscribedTo: [AnyCancellable] = []
    
    // Observable subjets.
    var programs = PassthroughSubject<[ProgramXML], Error>()
    
    var allPrograms: [ProgramXML] = [] {
        didSet {
            self.programs.send(allPrograms)
        }
    }
    
    private let urlPath: String = "https://www.aitorzubizarreta.eus/jsons/euskalpodcast/"
    private let sourcesURL: String = "main.json"
    
    // MARK: - Methods
    
    init() {
        subscriptions()
    }
    
    private func subscriptions() {
        xmlParserManager.program.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] program in
            self?.allPrograms.append(program)
        }.store(in: &subscribedTo)
    }
    
    func fetchChannels(channels: [Channel]) {
        for channel in channels {
            self.xmlParserManager.parseURL(urlString: channel.urlAddress)
        }
    }
    
    ///
    /// Gets the Sources data from the API.
    ///
//    private func getSources() {
//        let sourcesURLString = urlPath + sourcesURL
//        
//        guard let safeSourcesURL: URL = URL(string: sourcesURLString) else { return }
//        
//        let task = URLSession.shared.dataTask(with: safeSourcesURL) { (data, response, error) in
//            
//            if let safeError = error {
//                print("Error \(safeError.localizedDescription)")
//                return
//            }
//            
//            if let safeResponse = response {
//                //print("Response \(safeResponse)")
//            }
//            
//            if let safeData = data {
//                // For debug purposes.
//                //let receivedData: String = String(data: safeData, encoding: .utf8) ?? ""
//                //debugPrint("DebugPrint - Data: \(receivedData) - Response: \(response) - Error: \(error)")
//                
//                do {
//                    let sources = try JSONDecoder().decode([Source].self, from: safeData)
//                    
//                    if let dateManager = self.dataManager {
//                        dateManager.setSources(sources: sources)
//                    }
//                    
//                    for source in sources {
//                        if !source.JSONUrl.isEmpty {
//                            self.getCompanyData(urlString: source.JSONUrl)
//                        }
//                    }
//                    
//                    self.companiesGroup.notify(queue: .main) {
//                        if let dataManager = self.dataManager {
//                            dataManager.setCompanies(companies: self.tempCompanies.sorted { $0.Title < $1.Title } )
//                        }
//                    }
//                    
//                } catch let error {
//                    print("Error JSONDecoder : \(error)")
//                }
//            }
//            
//        }
//        task.resume()
//        
//    }
    
}
