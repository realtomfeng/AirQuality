//
//  AirVisualAPI.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/11/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation

enum APIError: Error {
    case couldNotParseJSON
}

struct AirVisualAPI {
    private static let baseURLString = "https://api.airvisual.com/v2/"
    private static let apiKey = "gDpZQhYxdvxHvSTzB"

    static func countriesData(fromJSON data: Data) -> CountriesResult {
        do {
            var allCountries = [String]()
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let countriesData = json["data"] as! [[String: String]]
            
            for country in countriesData {
                guard let countryName = country["country"] else { continue }
                allCountries.append(countryName)
            }
            
            return .success(allCountries)
        } catch {
            return .failure(error)
        }
    }

    static func statesData(fromJSON data: Data) -> StatesResult {
        do {
            var allStates = [String]()
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let statesData = json["data"] as! [[String: String]]
            
            for state in statesData {
                guard let stateName = state["state"] else { continue }
                allStates.append(stateName)
            }
            
            return .success(allStates)
        } catch {
            return .failure(error)
        }
    }

    static func citiesData(fromJSON data: Data) -> CitiesResult {
        do {
            var allCities = [String]()
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            guard let citiesData = json["data"] as? [[String: String]] else {
                let error = json["data"] as? [String:String]
                return .cityNotFound((error?["message"])!)
            }
            
            for city in citiesData {
                guard let cityName = city["city"] else { continue }
                allCities.append(cityName)
            }
            
            return .success(allCities)
        } catch {
            return .failure(error)
        }
    }
    
    static func airQualityData(fromJSON data: Data) -> AirQualityResult {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let jsonData = json["data"] as? [String: Any] else {
                    return .failure(APIError.couldNotParseJSON)
            }
            if let airQuality = AirQuality(json: jsonData) {
                return .success(airQuality) } else { return .failure(APIError.couldNotParseJSON) }
        } catch {
            return .failure(error)
        }
    }
    
    static func airVisualURL(country: String?, state: String?, city: String?) -> URL {
        var url = baseURLString
        var queryItems = [URLQueryItem]()
        var baseParams = [
            "key": apiKey,
        ]
        switch country {
        case nil:
            url.append("countries?")
        default:
            baseParams["country"] = country
            switch state {
            case nil:
                url.append("states?")
            default:
                baseParams["state"] = state
                switch city {
                case nil:
                    url.append("cities?")
                default:
                    url.append("city?")
                    baseParams["city"] = city
                }
            }
        }
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        var components = URLComponents(string: url)!
        components.queryItems = queryItems
        print(components.url)

        return components.url!
    }
}
