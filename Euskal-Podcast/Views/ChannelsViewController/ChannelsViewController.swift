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
    
    private var addBarButton = UIBarButtonItem()
    private var deleteBarButton = UIBarButtonItem()
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: ChannelsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Podcast Iturriak"
        
        setupNavbar()
        setupTableView()
        subscriptions()
        
        viewModel.getChannels()
    }
    
    private func setupNavbar() {
        initBarButtons()
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
    
    @objc func deleteModeTableView() {
        tableView.isEditing = true
        
        deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(initBarButtons))
        navigationItem.rightBarButtonItems = [deleteBarButton]
    }
    
    @objc func addModeTableView() {
        
    }
    
    @objc private func initBarButtons() {
        tableView.isEditing = false
        
        addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addModeTableView))
        deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "minus"), style: .plain, target: self, action: #selector(deleteModeTableView))
        navigationItem.rightBarButtonItems = [deleteBarButton, addBarButton]
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            
            let selectedChannel = channels[indexPath.row]
            viewModel.deleteChannel(channel: selectedChannel)
            channels.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
}
