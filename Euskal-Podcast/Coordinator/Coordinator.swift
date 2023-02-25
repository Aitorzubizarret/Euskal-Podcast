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
    
    func showPodcastList(programs: [Program])
    func showProgramDetail(programId: String)
    func showEpisodeDetail(episode: Episode)
    func showChannelList()
    func showPlayedEpisodes()
}
