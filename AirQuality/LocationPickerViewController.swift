//
//  LocationPickerViewController.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/14/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import UIKit

protocol LocationPickerViewControllerDelegate {
    func didSelect(country: String, state: String, city: String)
}

final class LocationPickerViewController: UINavigationController, StringPickerTableViewControllerDelegate {
    
    var pickerDelegate: LocationPickerViewControllerDelegate?
    
    
    var country: String?
    var state: String?
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCountryPicker()
    }
    
    private func showCountryPicker() {
        AirQualityStore.shared.fetchAvailableCountries { (result) -> Void in
            switch result {
            case let .success(countries):
                let picker = StringPickerTableViewController(titles: countries, delegate: self)
                DispatchQueue.main.async {
                    self.pushViewController(picker, animated: true)
                }
            case let .failure(error):
                print("Error fetching request with error: \(error)")

            }
        }
    }

    private func showStatePicker() {
        guard let country = country else { return }
        AirQualityStore.shared.fetchAvailableStates(in: country) { (result) -> Void in
            switch result {
            case let .success(states):
                let picker = StringPickerTableViewController(titles: states, delegate: self)
                DispatchQueue.main.async {
                    self.pushViewController(picker, animated: true)
                }
            case let .failure(error):
                print("Error fetching request with error: \(error)")
                
            }
        }
    }

    private func showCitiesPicker() {
        guard let country = country, let state = state else { return }
        AirQualityStore.shared.fetchAvailableCitiesIn(state: state, country: country) { (result) -> Void in
            switch result {
            case let .success(cities):
                let picker = StringPickerTableViewController(titles: cities, delegate: self)
                DispatchQueue.main.async {
                    self.pushViewController(picker, animated: true)
                }
            case let .failure(error):
                print("Error fetching request with error: \(error)")
            case let .cityNotFound(string):
                let alert = UIAlertController(title: "Error", message: string, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil) } ))
                self.present(alert, animated: true, completion: nil)
                print(string)
            }
        }
    }
    
    private func addCity() {
        guard let country = country, let state = state, let city = city else { return }
         AirQualityStore.shared.fetchAirQualityFor(city: city, state: state, country: country) {
            (airQualityResult) -> Void in
            switch airQualityResult {
            case let .success(airQuality):
                TrackedCitiesDataSource.shared.allTrackedCities.append(airQuality)
                
            case let .failure(error):
                print("Got error", error)
            }
        }
    }
    
    
    func stringPickerDidSelect(picker: StringPickerTableViewController, title: String) {
        if country == nil {
            country = title
            showStatePicker()
        } else if state == nil {
            state = title
            showCitiesPicker()
        } else {
            city = title
            addCity()
            dismiss(animated: true, completion: nil)
        }
    }
}
