//
//  PodcastsViewModel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit
import Combine

final class PodcastsViewModel {
    
    // MARK: - Properties
    
    var allPrograms: [ProgramXML] = []
    
    // Observable subjets.
    var programs = PassthroughSubject<[ProgramXML], Error>()
    
    // MARK: - Methods
    
    init() {}
    
    func fetchDemoData() {
        let demoProgram1 = ProgramXML(title: "Title 1",
                                     description: "Description 1",
                                     category: "",
                                     imageURL: "",
                                     explicit: "",
                                     language: "",
                                     author: "",
                                     link: "",
                                     copyright: "",
                                     copyrightOwnerName: "",
                                     copyrightOwnerEmail: "",
                                     episodes: [])
        let demoProgram2 = ProgramXML(title: "Title 2",
                                     description: "Description 2",
                                     category: "",
                                     imageURL: "",
                                     explicit: "",
                                     language: "",
                                     author: "",
                                     link: "",
                                     copyright: "",
                                     copyrightOwnerName: "",
                                     copyrightOwnerEmail: "",
                                     episodes: [])
        programs.send([demoProgram1, demoProgram2])
    }
}
