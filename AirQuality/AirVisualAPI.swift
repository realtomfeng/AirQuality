//
//  AirVisualAPI.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/11/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation

struct AirVisualAPI {
    private static var baseURLString = "http://api.airvisual.com/v2/"
    private static let apiKey = "gDpZQhYxdvxHvSTzB"

    static func airVisualURL(country: String?, state: String?, city: String?) -> URL {
        var queryItems = [URLQueryItem]()
        var baseParams = [
            "key": apiKey,
        ]
        switch country {
        case nil:
            baseURLString.append("country?")
        default:
            switch state {
            case nil:
                baseURLString.append("state?")
                baseParams["country"] = country
            default:
                switch city {
                case nil:
                    baseURLString.append("city?")
                    baseParams["state"] = state
                default:
                    baseParams["state"] = state
                    baseParams["city"] = city
                }
            }
        }
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        var components = URLComponents(string: baseURLString)!
        components.queryItems = queryItems
        return components.url!
    }
}
