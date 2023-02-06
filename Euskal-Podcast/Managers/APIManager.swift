//
//  APIManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 18/6/22.
//

import Foundation

final class APIManager {
    
    // MARK: - Properties
    
    var dataManager: DataManagerProtocol?
    
    private let urlPath: String = "https://www.aitorzubizarreta.eus/jsons/euskalpodcast/"
    private let sourcesURL: String = "main.json"
    
    private var companiesGroup = DispatchGroup()
    
    private var tempCompanies: [Company] = []
    
    // MARK: - Methods
    
    public func start() {
        //getSources()
        
        var programsURLString: [String] = []
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/590855897/itunes/")
        programsURLString.append("https://www.ivoox.com/feed_fg_f11397658_filtro_1.xml")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/596735897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/328715897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/328775897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/332275897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/445875897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/329795897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/355895897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/368015897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/464515897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/330455897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/456735897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/329435897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/330575897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/612735897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/329075897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/330215897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/331175897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/339995897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/367955897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/396335897/itunes/")
        programsURLString.append("https://api.eitb.eus/api/eitbpodkast/getRss/438635897/itunes/")
        programsURLString.append("https://www.ivoox.com/gazteon_fg_f1766426_filtro_1.xml")
        programsURLString.append("https://www.ivoox.com/gazteon_fg_f1795727_filtro_1.xml")
        programsURLString.append("https://www.ivoox.com/feed_fg_f11381606_filtro_1.xml")
        
        for programURLString in programsURLString {
            getDataXMLSource(urlString: programURLString)
        }
    }
    
    ///
    /// Gets the Sources data from the API.
    ///
    private func getSources() {
        let sourcesURLString = urlPath + sourcesURL
        
        guard let safeSourcesURL: URL = URL(string: sourcesURLString) else { return }
        
        let task = URLSession.shared.dataTask(with: safeSourcesURL) { (data, response, error) in
            
            if let safeError = error {
                print("Error \(safeError.localizedDescription)")
                return
            }
            
            if let safeResponse = response {
                //print("Response \(safeResponse)")
            }
            
            if let safeData = data {
                // For debug purposes.
                //let receivedData: String = String(data: safeData, encoding: .utf8) ?? ""
                //debugPrint("DebugPrint - Data: \(receivedData) - Response: \(response) - Error: \(error)")
                
                do {
                    let sources = try JSONDecoder().decode([Source].self, from: safeData)
                    
                    if let dateManager = self.dataManager {
                        dateManager.setSources(sources: sources)
                    }
                    
                    for source in sources {
                        if !source.JSONUrl.isEmpty {
                            self.getCompanyData(urlString: source.JSONUrl)
                        }
                    }
                    
                    self.companiesGroup.notify(queue: .main) {
                        if let dataManager = self.dataManager {
                            dataManager.setCompanies(companies: self.tempCompanies.sorted { $0.Title < $1.Title } )
                        }
                    }
                    
                } catch let error {
                    print("Error JSONDecoder : \(error)")
                }
            }
            
        }
        task.resume()
        
    }
    
    private func getDataXMLSource(urlString: String) {
        if let dataManager = dataManager {
            let xmlParserManager = XMLParserManager(dataManager: dataManager)
            xmlParserManager.parseURL(urlString: urlString)
        }
        
    }
    
    ///
    /// Gets data from one company from the API.
    ///
    private func getCompanyData(urlString: String) {
        let companyURLString = urlPath + urlString
        
        guard let safeURL: URL = URL(string: companyURLString) else { return }
        
        companiesGroup.enter()
        
        let task = URLSession.shared.dataTask(with: safeURL) { data, response, error in
            
            if let safeError = error {
                print("Error \(safeError.localizedDescription)")
                self.companiesGroup.leave()
                return
            }
            
            if let safeResponse = response {
                //print("Response \(safeResponse)")
            }
            
            if let safeData = data {
                // For debug purposes.
                //let receivedData: String = String(data: safeData, encoding: .utf8) ?? ""
                //debugPrint("DebugPrint - Data: \(receivedData) - Response: \(response) - Error: \(error)")
                
                do {
                    let company = try JSONDecoder().decode(Company.self, from: safeData)
                    
                    self.tempCompanies.append(company)
                } catch let error {
                    print("Error JSONDecoder : \(error)")
                }
            }
            
            self.companiesGroup.leave()
            
        }
        task.resume()
    }
    
}
