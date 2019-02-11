//
//  UserDefaultsExtensions.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/22/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    struct Keys {
        static let trackedCities = "TrackedCities"
    }
    
    var trackedCities: [AirQuality] {
        get {
            guard let data = data(forKey: Keys.trackedCities) else { return [] }
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode([AirQuality].self, from: data)
            }
            catch {
                print("⚠️ Couldn't decode cities.", error)
                return []
            }
        }
        set {
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: Keys.trackedCities)
            }
            catch {
                print("⚠️ Could not encode air quality data", error)
            }
        }
    }
}
