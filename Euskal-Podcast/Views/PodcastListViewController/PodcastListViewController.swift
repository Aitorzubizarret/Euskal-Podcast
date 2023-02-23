//
//  PodcastListViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-23.
//

import UIKit

class PodcastListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    private var viewModel: PodcastListViewModel
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: PodcastListViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register cells.
        let programCell: UINib = UINib(nibName: "ProgramTableViewCell", bundle: nil)
        tableView.register(programCell, forCellReuseIdentifier: "ProgramTableViewCell")
    }
    
}

// MARK: - UITableView Delegate

extension PodcastListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.showProgramDetail(programId: viewModel.getProgramId(index: indexPath.row))
    }
    
}

// MARK: - UITableView Data Source

extension PodcastListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getAmountPrograms()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramTableViewCell", for: indexPath) as! ProgramTableViewCell
        
        let program = viewModel.getProgram(index: indexPath.row)
        cell.iconURL = program.imageURL
        cell.titleText = program.title
        cell.descriptionText = program.descriptionText
        cell.episodesInfo = viewModel.getAmountEpisode(index: indexPath.row)
        cell.authorText = program.author
        
        return cell
    }
    
    
}
