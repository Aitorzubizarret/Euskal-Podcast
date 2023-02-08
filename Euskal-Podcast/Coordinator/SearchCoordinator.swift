//
//  SearchCoordinator.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import Foundation
import UIKit

final class SearchCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Methods
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Coordinator

extension SearchCoordinator: Coordinator {
    
    func showProgramDetail(program: ProgramXML) {
        let programVC = ProgramViewController(coordinator: self)
        programVC.program = program
        
        navigationController.show(programVC, sender: nil)
    }
    
}
