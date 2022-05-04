//
//  DetailsViewController.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 03.05.22.
//

import Foundation
import UIKit

class DetailsViewController<T: Codable>: UITableViewController {
    
    var object: T? {
        didSet {
            self.title = name
        }
    }
    var url: URL?
    
    var items: [(String, Any)] {
        guard let object = object else { return .init() }
        let mirroredObject = Mirror(reflecting: object)
        return mirroredObject.children.compactMap {
            guard let label = $0.label else { return nil }
            if label == "url" || label == "name" { return nil }
            return (label, $0.value)
        }
    }
    
    var name: String? {
        guard let object = object else { return .init() }
        let mirroredObject = Mirror(reflecting: object)
        return mirroredObject.children.first(where: { $0.label == "name" })?.value as? String
    }
    
    init(_ object: T) {
        self.object = object
        self.url = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ url: URL?) {
        self.object = nil
        self.url = url
        super.init(nibName: nil, bundle: nil)
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        print(items)
    }
    
    @objc func didPullRefresh() {
        loadData()
    }
    
    private func loadData() {
        showIndicator()
        GoTAPI.load(T.self, url: url, onSuccess: { [weak self] loadedObject in
            DispatchQueue.main.sync {
                self?.object = loadedObject
                self?.hideIndicator()
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let entry = items[indexPath.row]
        
        var defaultConfig = cell.defaultContentConfiguration()
        defaultConfig.text = entry.0.transformed()
        
        defaultConfig.prefersSideBySideTextAndSecondaryText = true
        defaultConfig.textToSecondaryTextHorizontalPadding = 10
        
        defaultConfig.textProperties.font = .systemFont(ofSize: 14, weight: .semibold)
        defaultConfig.secondaryTextProperties.font = .systemFont(ofSize: 14, weight: .regular)
        
        // Check if we have a string array
        if let arrayValues = entry.1 as? [String] {
            guard !arrayValues.isEmpty else {
                defaultConfig.secondaryText = ""
                cell.selectionStyle = .none
                cell.contentConfiguration = defaultConfig
                return cell
            }
            let urls = arrayValues.compactMap { URL(str: $0) }
            // we have a string array and no urls
            if urls.isEmpty {
                defaultConfig.secondaryText = arrayValues.joined(separator: ", ")
                cell.selectionStyle = .none
            } else {
                // we have urls
                defaultConfig.secondaryText = urls.first?
                    .disclosureText.appending("s") // add 's' for plural
                defaultConfig.secondaryTextProperties.color = .systemBlue
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            }
        } else if let stringValue = entry.1 as? String, let url = URL(str: stringValue) {
            defaultConfig.secondaryText = url.disclosureText
            defaultConfig.secondaryTextProperties.color = .systemBlue
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        } else {
            defaultConfig.secondaryText = entry.1 as? String
            cell.selectionStyle = .none
        }
        
        cell.contentConfiguration = defaultConfig
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let entry = items[indexPath.row]
        
        if let arrayValues = entry.1 as? [String] {
            let urls = arrayValues.compactMap { URL(str: $0) }
            guard !urls.isEmpty else { return }
            self.navigationController?.pushViewController(CharacterListViewController(urls), animated: true)
        }
        
        guard let stringValue = entry.1 as? String, let url = URL(str: stringValue) else {
            return
        }
        
        if url.isCharacterAPIUrl {
            self.navigationController?.pushViewController(DetailsViewController<Char>(url), animated: true)
        } else if url.isHouseAPIUrl {
            self.navigationController?.pushViewController(DetailsViewController<House>(url), animated: true)
        }
    }
}


extension String {
    func transformed() -> String {
        return self.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: self.range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
}

extension URL {
    
    var isHouseAPIUrl: Bool {
        pathComponents.contains("houses")
    }
    
    var isCharacterAPIUrl: Bool {
        pathComponents.contains("characters")
    }
    
    var disclosureText: String {
        for pathComponent in pathComponents {
            if pathComponent == "houses" {
                return "Load House"
            } else if pathComponent == "characters" {
                return "Load Character"
            }
        }
        return self.path
    }
    
    // Custom init with simple check for validity
    init?(str: String) {
        let components = str.components(separatedBy: .punctuationCharacters)
        if components.contains("http") || components.contains("https") {
            self.init(string: str)
        } else {
            return nil
        }
    }
    
}
