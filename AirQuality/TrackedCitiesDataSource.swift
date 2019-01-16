//
//  TrackedCitiesDataSource.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/14/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation

class TrackedCitiesDataSource {
    
    static let shared = TrackedCitiesDataSource()
    
    var allTrackedCities =  [AirQuality]()
}
