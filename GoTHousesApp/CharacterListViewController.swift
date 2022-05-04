//
//  CharacterListViewController.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 04.05.22.
//

import UIKit

class CharacterListViewController: UITableViewController {
    
    var urls: [URL?] = []
    var chars: [Char] = []
    
    init(_ urls: [URL?]) {
        self.urls = urls
        super.init(nibName: nil, bundle: nil)
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        loadData()
    }

    private func setup() {
        self.title = "Characters"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @objc func didPullRefresh() {
        loadData()
    }
    
    private func loadData() {
        showIndicator()
        GoTAPI.load(Char.self, urls: urls, onSuccess: { [weak self] chars in
            self?.hideIndicator()
            self?.chars = chars
            self?.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }, onFailure: { [weak self] error in
            self?.hideIndicator()
            self?.showAlert(for: error, onReload: {
     
                self?.loadData()
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let char = chars[indexPath.row]
        
        var defaultConfig = cell.defaultContentConfiguration()
        defaultConfig.text = char.name
        defaultConfig.secondaryText = char.titles.joined(separator: ", ")
        cell.accessoryType = .disclosureIndicator
        
        cell.contentConfiguration = defaultConfig
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let char = chars[indexPath.row]
        let detailsVC = DetailsViewController(char)
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
