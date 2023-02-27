//
//  EpisodeViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-15.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var publishedDateValueLabel: UILabel!
    @IBOutlet weak var explicitLabel: UILabel!
    @IBOutlet weak var explicitValueLabel: UILabel!
    @IBOutlet weak var audioFileURLLabel: UILabel!
    @IBOutlet weak var audioFileURLValueLabel: UILabel!
    @IBOutlet weak var audioFileSizeLabel: UILabel!
    @IBOutlet weak var audioFileSizeValueLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationValueLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var linkValueLabel: UILabel!
    
    // MARK: - Properties
    
    private var coordinator: Coordinator
    private var viewModel: EpisodeViewModel
    
    // MARK: - Methods
    
    init(coordinator: Coordinator, viewModel: EpisodeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Atala"
        
        titleValueLabel.text = viewModel.getTitle()
        descriptionValueLabel.text = viewModel.getDescription()
        publishedDateValueLabel.text = viewModel.getPubDateFormatter()
        explicitValueLabel.text = viewModel.getExplicit()
        audioFileURLValueLabel.text = viewModel.getAudioFileURL()
        audioFileSizeValueLabel.text = viewModel.getAudioFileSize()
        durationValueLabel.text = viewModel.getDurationFormatted()
        linkValueLabel.text = viewModel.getLink()
    }
    
}
