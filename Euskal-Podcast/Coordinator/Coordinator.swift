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
    
    func showProgramDetail(program: Program)
    func showEpisodeDetail(episode: Episode)
}
