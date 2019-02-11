//
//  TrackedCitiesDataSource.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/14/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let citiesDidUpdate = NSNotification.Name("citiesDidUpdate")
}

class TrackedCitiesDataSource {
    
    static let shared = TrackedCitiesDataSource()
    
    var allTrackedCities = UserDefaults.standard.trackedCities {
        didSet {
            NotificationCenter.default.post(name: .citiesDidUpdate, object: nil)
            UserDefaults.standard.trackedCities = allTrackedCities
        }
    }
}
