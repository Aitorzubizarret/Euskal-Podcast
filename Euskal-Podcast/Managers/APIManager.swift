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
    
    private var companiesURL: String = "https://www.aitorzubizarreta.eus/jsons/euskalpodcast/euskalpodcast-all.json"
    
    // MARK: - Methods
    
    private init() {}
    
    public func getCompaniesData(completionHandler: @escaping([Company]) -> Void) {
        guard let safeCompaniesURL: URL = URL(string: companiesURL) else { return }
        
        let task = URLSession.shared.dataTask(with: safeCompaniesURL) { (data, response, error) in
            
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
                    let companies = try JSONDecoder().decode([Company].self, from: safeData)
                    completionHandler(companies)
                } catch let error {
                    print("Error JSONDecoder : \(error)")
                }
            }
            
        }
        task.resume()
        
    }
    
}
