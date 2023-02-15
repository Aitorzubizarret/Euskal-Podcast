//
//  Results-Extension.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-15.
//

import Foundation
import RealmSwift

extension Results {
    
    func toArray() -> [Element] {
        return compactMap { $0 }
    }
    
}
