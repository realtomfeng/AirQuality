//
//  advisory.swift
//  AirQuality
//
//  Created by Thomas Feng on 2/13/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import Foundation
import UIKit

enum Advisory {
    case active
    case cautionActive
    case doNotActive
    case openWindows
    case doNotOpenWindows
    case airPurifier
    case dustMask
    
    var image: UIImage? {
        
        let imageName: String
        
        switch self {
        case .active: imageName = "active"
        case .cautionActive: imageName = "cautionActive"
        case .doNotActive: imageName = "doNotActive"
        case .openWindows: imageName = "openWindows"
        case .doNotOpenWindows: imageName = "doNotOpenWindows"
        case .airPurifier: imageName = "airPurifier"
        case .dustMask: imageName = "dustMask"
        }
        
        return UIImage(named: imageName)
    }
    
    static func `for`(AQI: Int) -> [Advisory] {
        var advisories = [Advisory]()
        
        switch AQI {
        case 0...50:
            advisories = [.active, .openWindows]
        case 51...100:
            advisories = [.cautionActive, .doNotOpenWindows]
        default:
            advisories = [.doNotActive, .doNotOpenWindows, .dustMask, .airPurifier]
        }
        
        return advisories
    }
}
