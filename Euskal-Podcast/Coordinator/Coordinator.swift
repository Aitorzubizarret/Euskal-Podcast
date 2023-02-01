//
//  Coordinator.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 1/2/23.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
    func goToMain()
    func goToCompany()
    func goToPrograms()
    func goToProgram()
    func goToPlayer()
}
