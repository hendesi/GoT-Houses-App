//
//  ViewController.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 02.05.22.
//

import UIKit

class ViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let refreshControl = UIRefreshControl()
    
    var houses: [House] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        loadData()
    }

    private func setup() {
        self.title = "GoT Houses"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).activate()
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).activate()
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).activate()
        
        refreshControl.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func didPullRefresh() {
        loadData()
    }
    
    private func loadData() {
        showIndicator()
        GoTAPI.loadHouses(page: 1, onSuccess: { [weak self] houses in
            DispatchQueue.main.sync {
                self?.houses = houses
                self?.hideIndicator()
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }, onFailure: { [weak self] error in
            DispatchQueue.main.sync {
                self?.hideIndicator()
                self?.showAlert(for: error, onReload: {
         
                    self?.loadData()
                })
                print(error)
            }
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let house = houses[indexPath.row]
        
        var defaultConfig = cell.defaultContentConfiguration()
        defaultConfig.text = house.name
        defaultConfig.secondaryText = house.region
        cell.accessoryType = .disclosureIndicator
        
        cell.contentConfiguration = defaultConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let house = houses[indexPath.row]
        let detailsVC = DetailsViewController(house)
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == houses.count {
            self.showIndicator()
            GoTAPI.loadMoreHouses(onSuccess: { [weak self] newHouses in
                DispatchQueue.main.sync {
                    self?.hideIndicator()
                    self?.houses.append(contentsOf: newHouses)
                    let reloadableIndexPaths = self?.getIndexPathsFor(startIndex: indexPath.row + 1, endIndex: self?.houses.count) ?? []
                    self?.tableView.insertRows(at: reloadableIndexPaths, with: .fade)
                }
            }, onFailure: { [weak self] error in
                DispatchQueue.main.sync {
                    self?.hideIndicator()
                    self?.showAlert(for: error, onReload: {
                        self?.loadData()
                    })
                }
            })
        }
    }
}
