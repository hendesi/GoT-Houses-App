//
//  GoTTableViewController.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 03.05.22.
//

import Foundation
import UIKit

class ParentViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func didPullRefresh() {
        loadData()
    }
    
    func loadData() {
        fatalError("Override in subclass")
    }
}
