//
//  Extensions.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 04.05.22.
//

import Foundation
import UIKit

// MARK: - UIViewController Extensions
extension UIViewController {
    /// Shows an Activity Indicator on the view controllers `view`.
    func showIndicator() {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicatorView)
        
        indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        indicatorView.startAnimating()
    }
    
    /// Hides an active Activity Indicator of the view controller.
    func hideIndicator() {
        self.view.subviews
            .filter { $0 is UIActivityIndicatorView }
            .forEach { $0.removeFromSuperview() }
    }
    
    /// Shows an alert for the given `Error` and performs the given action on click.
    func showAlert(for error: Error, onReload: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: "An error occurred", message: "Error message: \(error.localizedDescription)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Reload", style: .default, handler: { action in
            onReload()
            alertController.dismiss(animated: true)
        }))
        self.present(alertController, animated: true)
    }
    
    /// Maps the corresponding `IndexPaths` from a given startIndex to an endIndex.
    func getIndexPathsFor(startIndex: Int?, endIndex: Int?) -> [IndexPath] {
        guard let startIndex = startIndex, let endIndex = endIndex else {
            return []
        }

        var indexPaths: [IndexPath] = []
        for index in startIndex..<endIndex {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        return indexPaths
    }
}

// MARK: - String Extensions
extension String {
    /// Transforms camelCase string into a string with spaces;
    /// Taken from: https://stackoverflow.com/a/50821071
    func transformed() -> String {
        return self.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: self.range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
}

// MARK: - URL Extensions
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
