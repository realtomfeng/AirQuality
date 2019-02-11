//
//  TrackCitiesTableViewController.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/11/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation
import UIKit

class TrackedCitiesTableViewController: UITableViewController {
    
    let api = AirQualityStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.updateCities()
        
        NotificationCenter.default.addObserver(forName: .citiesDidUpdate, object: nil, queue: nil) { _ in
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrackedCitiesDataSource.shared.allTrackedCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = TrackedCitiesDataSource.shared.allTrackedCities[indexPath.row].city
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showAirQualityForCity"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.airQuality = TrackedCitiesDataSource.shared.allTrackedCities[row]
            }
        case "searchForCity"?:
            _ = segue.destination as! LocationPickerViewController
        default:
            preconditionFailure("Unexpect Segue identifier")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            TrackedCitiesDataSource.shared.allTrackedCities.remove(at: indexPath.row)
        }
    }

}

extension TrackedCitiesTableViewController {
    @objc private func didBecomeActive() {
        api.updateCities()
    }
}
