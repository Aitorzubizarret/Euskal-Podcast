//
//  CompanyViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 14/05/2021.
//

import UIKit

class CompanyViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    var company: Company? {
        didSet {
            guard let receivedCompany = self.company else { return }
            
            self.title = receivedCompany.name
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
