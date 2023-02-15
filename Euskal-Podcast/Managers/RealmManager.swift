//
//  RealmManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-15.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    // MARK: - Properties
    
    private var realm: Realm?
    
    // MARK: - Methods
    
    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("RealmManager Init Error : \(error)")
        }
    }
    
    func addProgram(program: Program) {
        guard let realm = realm else { return }
        
        do {
            try realm.write({
                realm.add(program)
            })
        } catch let error {
            print("RealmManager addProgram Error: \(error)")
        }
    }
    
    func getAllPrograms() -> [Program] {
        guard let realm = realm else { return [] }
        
        let programsResults: Results<Program> = realm.objects(Program.self)
        let programsArray: [Program] = programsResults.toArray()
        
        return programsArray
    }
    
    func deleteAll() {
        guard let realm = realm else { return }
        
        let programsResults: Results<Program> = realm.objects(Program.self)
        
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch let error {
            print("RealmMamanager deleteAll Error: \(error)")
        }
    }
    
}
