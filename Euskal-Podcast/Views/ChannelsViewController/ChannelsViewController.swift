//
//  ChannelsViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-20.
//

import UIKit
import Combine

class ChannelsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    private var viewModel: ChannelsViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    private var channels: [Channel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: ChannelsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Podcast Iturriak"
        
        setupTableView()
        subscriptions()
        
        viewModel.getChannels()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "ChannelTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: "ChannelTableViewCell")
    }
    
    private func subscriptions() {
        viewModel.channels.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] channels in
            self?.channels = channels
        }.store(in: &subscribedTo)
    }
    
}

// MARK: - UITableView Delegate

extension ChannelsViewController: UITableViewDelegate {}

// MARK: - UITableView Data Source

extension ChannelsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelTableViewCell", for: indexPath) as! ChannelTableViewCell
        
        let channel = channels[indexPath.row]
        cell.nameText = channel.name
        cell.urlAddressText = channel.urlAddress
        
        return cell
    }
    
}
