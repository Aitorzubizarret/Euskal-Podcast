//
//  APIManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 18/6/22.
//

import Foundation

final class APIManager {
    
    // MARK: - Properties
    
    static var shared: APIManager = APIManager()
    
    private let urlPath: String = "https://www.aitorzubizarreta.eus/jsons/euskalpodcast/"
    private let sourcesURL: String = "main.json"
    
    private var companiesGroup = DispatchGroup()
    
    private var tempCompanies: [Company] = []
    
    // MARK: - Methods
    
    private init() {}
    
    public func start() {
        getSources()
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
                    
                    DataManager.shared.sources = sources
                    
                    for source in sources {
                        if !source.JSONUrl.isEmpty {
                            self.getCompanyData(urlString: source.JSONUrl)
                        }
                    }
                    
                    self.companiesGroup.notify(queue: .main) {
                        DataManager.shared.companies = self.tempCompanies
                    }
                    
                } catch let error {
                    print("Error JSONDecoder : \(error)")
                }
            }
            
        }
        task.resume()
        
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
