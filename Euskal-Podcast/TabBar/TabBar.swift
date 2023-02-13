//
//  TabBar.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit

class TabBar: UITabBarController {
    
    // MARK: - Properties
    
    private let podcastsCoordinator = PodcastsCoordinator()
    private let searchCoordinator = SearchCoordinator()
    private let meCoordinator = MeCoordinator()
    
    var nowPlayingView: UIView = {
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    var nowPlayingViewController: NowPlayingViewController?
    
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVCs()
        
        embedNowPlayingViewController()
        
        setupNotificationsObservers()
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
    
    private func embedNowPlayingViewController() {
        nowPlayingViewController = NowPlayingViewController()
        
        guard let nowPlayingViewController = nowPlayingViewController else { return }
        
        nowPlayingViewController.willMove(toParent: self)
        nowPlayingViewController.view.frame = nowPlayingView.frame
        nowPlayingView.addSubview(nowPlayingViewController.view)
        addChild(nowPlayingViewController)
        nowPlayingViewController.didMove(toParent: self)
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self, selector: #selector(showNowPlayingView),
                                       name: Notification.Name(rawValue: "ShowNowPlayingView"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(hideNowPlayingView),
                                       name: Notification.Name(rawValue: "HideNowPlayingView"), object: nil)
    }
    
}

extension TabBar {
    
    @objc private func showNowPlayingView() {
        view.insertSubview(nowPlayingView, aboveSubview: tabBar)
        
        view.addConstraints([
            NSLayoutConstraint(item: nowPlayingView, attribute: .leading, relatedBy: .equal,
                               toItem: tabBar, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nowPlayingView, attribute: .trailing, relatedBy: .equal,
                               toItem: tabBar, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nowPlayingView, attribute: .top, relatedBy: .equal,
                               toItem: tabBar, attribute: .top, multiplier: 1, constant: -60),
            NSLayoutConstraint(item: nowPlayingView, attribute: .bottom, relatedBy: .equal,
                               toItem: tabBar, attribute: .top, multiplier: 1, constant: 0)
        ])
    }
    
    @objc private func hideNowPlayingView() {
        nowPlayingView.removeFromSuperview()
    }
    
}
