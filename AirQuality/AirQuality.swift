//
//  File.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/13/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import UIKit

struct AirQuality: Codable {
    let city: String
    let state: String
    let country: String
    let weather: Weather?
    let pollution: Pollution?
    let coordinates: Coordinates
    
    init?(json: [String: Any]) {
        if let current = json["current"] as? [String: Any],
        let location = json["location"] as? [String: Any],
        let coordinatesJson = location["coordinates"] as? [Double],
        let weatherJson = current["weather"] as? [String: Any],
        let pollutionJson = current["pollution"] as? [String: Any] {
            city = json["city"] as! String
            state = json["state"] as! String
            country = json["country"] as! String
            weather = Weather(json: weatherJson)
            pollution = Pollution(json: pollutionJson)
            coordinates = Coordinates(array: coordinatesJson)
        } else {
            return nil
        }

    }
}

struct Weather: Codable {
    let timestamp: String?
    let humidity: Int?
    let ic: String?
    let atmosphericPressure, temperature, windDirection: Int?
    let windSpeed: Double?
    
    init(json: [String: Any]) {
        timestamp = json["ts"] as? String
        humidity = json["ts"] as? Int
        ic = json["ic"] as? String
        atmosphericPressure = json["pr"] as? Int
        temperature = json["tp"] as? Int
        windDirection = json["wd"] as? Int
        windSpeed = json["ws"] as? Double
    }
}

struct Pollution: Codable {
    let timestamp: String?
    let aqius: Int?
    let mainus: String?
    let aqicn: Int?
    let maincn: String?
    
    init(json: [String: Any]) {
        timestamp = json["ts"] as? String
        aqius = json["aqius"] as? Int
        mainus = json["mainus"] as? String
        aqicn = json["aqicn"] as? Int
        maincn = json["maincn"] as? String
    }
    
    func airQualityImage() -> UIImage? {
        if let AQI = aqius {
            switch AQI {
            case 0...50:
                return UIImage(named: "good")
            case 51...100:
                return UIImage(named: "moderate")
            case 101...150:
                return UIImage(named: "unhealthyForSensitiveGroups")
            case 151...200:
                return UIImage(named: "unhealthy")
            case 201...300:
                return UIImage(named: "veryUnhealthy")
            case 301...500:
                return UIImage(named: "hazardous")
            default:
                return UIImage()
            }
        }
        return UIImage()
    }
    
    func airQualitySummary() -> String {
        if let AQI = aqius {
            switch AQI {
            case 0...50:
                return "Good"
            case 51...100:
                return "Moderate"
            case 101...150:
                return "Unhealthy for sensitive groups"
            case 151...200:
                return "Unhealthy"
            case 201...300:
                return "Very unhealthy"
            case 301...500:
                return "Hazardous"
            default:
                return "Error AQI not found!"
            }
        }
        return "Error AQI not found!"
    }
    
    func airQualityActions() -> String {
        if let AQI = aqius {
            switch AQI {
            case 0...50:
                return "No action necessary to protect health."
            case 51...100:
                return "Unusually sensitive people should consider reducing prolonged or heavy exertion."
            case 101...150:
                return "People with heart or lung disease, Children and older adults should reduce prolonged or heavy outdoor exertion."
            case 151...200:
                return "People with heart or lung disease, Children and older adults should avoid prolonged or heavy exertion. Everyone else should reduce prolonged or heavy exertion."
            case 201...300:
                return "People with heart or lung disease, Children and older adults should avoid all physical activity outdoors. Everyone else should reduce prolonged or heavy exertion."
            case 301...500:
                return "Get out of Hazardous area."
            default:
                return "Error AQI not found!"
            }
        }
        return "Error AQI not found!"
    }
    
    func getDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        let convertedDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"

        return dateFormatter.string(from: convertedDate!)
    }
}

struct Coordinates: Codable {
    let lat: Double
    let long: Double
    
    init(array: [Double]) {
        lat = array[0]
        long = array[1]
    }
}
