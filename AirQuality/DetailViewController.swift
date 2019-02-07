//
//  DetailViewController.swift
//  AirQuality
//
//  Created by Thomas Feng on 1/16/19.
//  Copyright © 2019 Infinity and Beyond. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var airQuality: AirQuality!
    
    
    @IBOutlet var emojiForAirQuality: UIImageView!
    @IBOutlet var airQualitySummaryLabel: UILabel!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var USAQI: UILabel!
    @IBOutlet var date: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        airQualitySummaryLabel.text = airQuality.pollution?.airQualitySummary()
        emojiForAirQuality.image = airQuality.pollution?.airQualityImage()
        cityName.text = airQuality.city
        self.view.backgroundColor = backgroundColor()
        guard let usAQI = airQuality.pollution?.aqius else { return }
        USAQI.text = String(usAQI)
        date.text = airQuality.pollution?.getDate(date: (airQuality.pollution?.timestamp)!)
    }
    
    func backgroundColor() -> UIColor {
        switch airQuality.pollution?.airQualitySummary() {
        case "Good":
            return UIColor.green
        case "Moderate":
            return UIColor.yellow
        case "Unhealthy for sensitive groups":
            return UIColor.orange
        case "Unhealthy":
            return UIColor.red
        case "Very unhealthy":
            return UIColor.purple
        case "Hazardous":
            return UIColor.init(red: 128, green: 0, blue: 0, alpha: 1)
        default:
            return UIColor.white
        }
    }
}
