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
    
    private var sourcesURL: String = "https://www.aitorzubizarreta.eus/jsons/euskalpodcast/main.json"
    
    // MARK: - Methods
    
    private init() {}
    
    public func start() {
        getSources()
    }
    
    private func getSources() {
        guard let safeSourcesURL: URL = URL(string: sourcesURL) else { return }
        
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
                } catch let error {
                    print("Error JSONDecoder : \(error)")
                }
            }
            
        }
        task.resume()
        
    }
    
}
