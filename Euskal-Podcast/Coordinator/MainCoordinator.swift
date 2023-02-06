//
//  MainCoordinator.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 1/2/23.
//

import Foundation
import UIKit

final class MainCoordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Methods
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Coordinator

extension MainCoordinator: Coordinator {
    
    func start() {
        goToMain()
    }
    
    func goToMain() {
        let dataManager: DataManagerProtocol = DataManager()
        
        let mainVC = MainViewController(coordinator: self, dataManager: dataManager)
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    func goToCompany() {
        let companyVC = CompanyViewController(coordinator: self)
        navigationController.pushViewController(companyVC, animated: true)
    }
    
    func goToPrograms(programs: [ProgramXML]) {
        let programsVC = ProgramsViewController(coordinator: self)
        programsVC.programs = programs
        navigationController.pushViewController(programsVC, animated: true)
    }
    
    func goToProgram(program: ProgramXML) {
        let programVC = ProgramViewController(coordinator: self)
        programVC.program = program
        navigationController.pushViewController(programVC, animated: true)
    }
    
    func goToPlayer(episode: EpisodeXML) {
        let playerVC = PlayerViewController(coordinator: self)
        playerVC.episodeXML = episode
        navigationController.pushViewController(playerVC, animated: true)
    }
    
}
