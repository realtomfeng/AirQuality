//
//  CitiesViewController.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/11/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation
import UIKit

class CitiesViewController: UITableViewController, LocationPickerViewControllerDelegate {
    func didSelect(country: String, state: String, city: String) {
        api.fetchAirQualityFor(city: city, state: state, country: country) {
            (airQualityResult) -> Void in
            switch airQualityResult {
            case let .success(airQuality):
                TrackedCitiesDataSource.shared.allTrackedCities.append(airQuality)
            case let .failure(error):
                print(error)
            }
        }
    }
}
