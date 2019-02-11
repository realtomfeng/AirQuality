//
//  AirQualityStore.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/11/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation

enum CountriesResult {
    case success([String])
    case failure(Error)
}

enum StatesResult {
    case success([String])
    case failure(Error)
}

enum CitiesResult {
    case success([String])
    case failure(Error)
    case cityNotFound(String)
}

enum AirQualityResult {
    case success(AirQuality)
    case failure(Error)
}

class AirQualityStore {
    
    static let shared = AirQualityStore()
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func processCountriesRequest(data: Data?, error: Error?) -> CountriesResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return AirVisualAPI.countriesData(fromJSON: jsonData)
    }
    
    func processStatesRequest(data: Data?, error: Error?) -> StatesResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return AirVisualAPI.statesData(fromJSON: jsonData)
    }

    func processCitiesRequest(data: Data?, error: Error?) -> CitiesResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return AirVisualAPI.citiesData(fromJSON: jsonData)
    }

    func processAirQualityRequest(data: Data?, error: Error?) -> AirQualityResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return AirVisualAPI.airQualityData(fromJSON: jsonData)
    }
    
    func fetchAvailableCountries(completion: @escaping (CountriesResult) -> Void) {
        let url = AirVisualAPI.airVisualURL(country: nil, state: nil, city: nil)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processCountriesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func fetchAvailableStates(in country: String, completion: @escaping (StatesResult) -> Void) {
        let url = AirVisualAPI.airVisualURL(country: country, state: nil, city: nil)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processStatesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    func fetchAvailableCitiesIn(state: String, country: String, completion: @escaping (CitiesResult) -> Void) {
        let url = AirVisualAPI.airVisualURL(country: country, state: state, city: nil)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processCitiesRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    func fetchAirQualityFor(city: String, state: String, country: String, completion: @escaping (AirQualityResult) -> Void) {
        let url = AirVisualAPI.airVisualURL(country: country, state: state, city: city)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processAirQualityRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func updateCities() -> Void {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "citiesDidUpdate"), object: nil)
        }
        for (index, city) in TrackedCitiesDataSource.shared.allTrackedCities.enumerated() {
            fetchAirQualityFor(city: city.city, state: city.state, country: city.country) {
                (airQualityResult) -> Void in
                switch airQualityResult {
                case let .success(airQuality):
                    TrackedCitiesDataSource.shared.allTrackedCities[index] = airQuality
                    
                case let .failure(error):
                    print("Got error updating cities", error)
                }
            }
        }
    }
    
}
