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
        GoTAPI.loadAllHouses(onSuccess: { [weak self] houses in
            DispatchQueue.main.sync {
                self?.houses = houses
                self?.hideIndicator()
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }, onFailure: { [weak self] error in
            DispatchQueue.main.sync {
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
        
        let cell = UITableViewCell()
        let house = houses[indexPath.row]
        
        var defaultConfig = cell.defaultContentConfiguration()
        defaultConfig.text = house.name
        defaultConfig.secondaryText = house.region
        cell.accessoryType = .disclosureIndicator
        
        cell.contentConfiguration = defaultConfig
        return cell
    }
    
    
}


extension NSLayoutConstraint {
    @discardableResult
    func activate() -> Self {
        self.isActive = true
        return self
    }
}

extension UIViewController {
    func showIndicator() {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicatorView)
        
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).activate()
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).activate()
        
        indicatorView.startAnimating()
    }
    
    func hideIndicator() {
        self.view.subviews
            .filter { $0 is UIActivityIndicatorView }
            .forEach { $0.removeFromSuperview() }
    }
    
    func showAlert(for error: Error, onReload: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: "An error occurred", message: "Error message: \(error.localizedDescription)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Reload", style: .default, handler: { action in
            onReload()
            alertController.dismiss(animated: true)
        }))
        self.present(alertController, animated: true)
    }
}
