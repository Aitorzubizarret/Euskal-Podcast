//
//  TabBar.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-08.
//

import UIKit

class TabBar: UITabBarController {
    
    // MARK: - Properties
    
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
        
        setupTabBarAppearance()
        
        setupVCs()
        
        embedNowPlayingViewController()
        
        setupNotificationsObservers()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBar.appearance()
        appearance.tintColor = UIColor.template.purple
    }
    
    /// Setup ViewControllers.
    private func setupVCs() {
        // Podcasts Tab.
        let podcastsCoordinator: Coordinator = PodcastsCoordinator()
        let podcastsAPIManager = APIManager()
        let podcastsRealmManager = RealmManager()
        let podcastsViewModel = PodcastsViewModel(apiManager: podcastsAPIManager, realManager: podcastsRealmManager)
        let podcastsVC = PodcastsViewController(coordinator: podcastsCoordinator, viewModel: podcastsViewModel)
        
        podcastsVC.tabBarItem = UITabBarItem(title: "PODCASTAK",
                                            image: UIImage(systemName: "dot.radiowaves.up.forward"),
                                            selectedImage: UIImage(systemName: "dot.radiowaves.up.forward"))
        
        podcastsCoordinator.navigationController.viewControllers = [podcastsVC]
        
        // Search Tab.
        let searchCoordinator: Coordinator = SearchCoordinator()
        let searchRealmManager: RealManagerProtocol = RealmManager()
        let searchViewModel = SearchViewModel(realmManager: searchRealmManager)
        let searchVC = SearchViewController(coordinator: searchCoordinator, viewModel: searchViewModel)
        
        searchVC.tabBarItem = UITabBarItem(title: "BILATU",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           selectedImage: UIImage(systemName: "magnifyingglass"))
        
        searchCoordinator.navigationController.viewControllers = [searchVC]
        
        // Me Tab.
        let meCoordinator: Coordinator = MeCoordinator()
        let meVC = MeViewController(coordinator: meCoordinator)
        
        meVC.tabBarItem = UITabBarItem(title: "NI",
                                       image: UIImage(systemName: "person"),
                                       selectedImage: UIImage(systemName: "person.fill"))
        
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
        notificationCenter.addObserver(self,
                                       selector: #selector(showNowPlayingView),
                                       name: .showNowPlayingView,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(hideNowPlayingView),
                                       name: .hideNowPlayingView,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(showPlayerView),
                                       name: .showPlayerViewController,
                                       object: nil)
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
    
    @objc private func showPlayerView() {
        if let episode = AudioManager.shared.episode,
           let program = AudioManager.shared.program {
            let playerVC = PlayerViewController(episode: episode, program: program)
            playerVC.modalPresentationStyle = .pageSheet
            present(playerVC, animated: true)
        }
    }
    
}
