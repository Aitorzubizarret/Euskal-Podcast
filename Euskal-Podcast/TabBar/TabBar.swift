//
//  TabBar.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit

class TabBar: UITabBarController {
    
    // MARK: - Properties
    
    let podcastsCoordinator = PodcastsCoordinator()
    let searchCoordinator = SearchCoordinator()
    let meCoordinator = MeCoordinator()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVCs()
    }
    
    /// Setup ViewControllers.
    private func setupVCs() {
        // Podcasts Tab.
        let podcastsAPIManager = APIManager()
        let podcastsViewModel = PodcastsViewModel(apiManager: podcastsAPIManager)
        let podcastsVC = PodcastsViewController(coordinator: podcastsCoordinator, viewModel: podcastsViewModel)
        
        podcastsVC.tabBarItem = UITabBarItem(title: "Podcastak",
                                            image: UIImage(systemName: "list.bullet.circle"),
                                            selectedImage: UIImage(systemName: "list.bullet.circle.fill"))
        
        podcastsCoordinator.navigationController.viewControllers = [podcastsVC]
        
        // Search Tab.
        let searchVC = SearchViewController(coordinator: searchCoordinator)
        
        searchVC.tabBarItem = UITabBarItem(title: "Bilatu",
                                           image: UIImage(systemName: "magnifyingglass.circle"),
                                           selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        
        searchCoordinator.navigationController.viewControllers = [searchVC]
        
        // Me Tab.
        let meVC = MeViewController(coordinator: meCoordinator)
        
        meVC.tabBarItem = UITabBarItem(title: "Ni",
                                       image: UIImage(systemName: "person.crop.circle"),
                                       selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        meCoordinator.navigationController.viewControllers = [meVC]
        
        // Tabbar's View Controllers. Each ViewController will display a TabBarItem in the bar.
        viewControllers = [podcastsCoordinator.navigationController, searchCoordinator.navigationController, meCoordinator.navigationController]
    }
    
}
