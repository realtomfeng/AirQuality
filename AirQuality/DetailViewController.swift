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
    @IBOutlet var airQualityName: UILabel!
    @IBOutlet var airQualitySummaryLabel: UILabel!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var USAQI: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var progressBar: UIProgressView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.trackTintColor = UIColor.white
        progressBar.progressTintColor = {
            guard let AQI = airQuality.pollution?.aqius else { return UIColor.black }
            switch AQI {
            case 0...50:
                return UIColor.green.darker()
            case 51...100:
                return UIColor.yellow.darker()
            case 101...150:
                return UIColor.orange.darker()
            case 151...200:
                return UIColor.red.darker()
            case 201...300:
                return UIColor.purple.darker()
            default:
                return UIColor.black
            }
        }()
        updateUI()
    }
    
    func updateUI() {
        airQualitySummaryLabel.text = airQuality.pollution?.airQualityActions()
        airQualityName.text = airQuality.pollution?.airQualitySummary()
        emojiForAirQuality.image = airQuality.pollution?.airQualityImage()
        cityName.text = airQuality.city
        self.view.backgroundColor = backgroundColor()
        guard let usAQI = airQuality.pollution?.aqius else { return }
        USAQI.text = "AQI: " + String(usAQI)
        date.text = airQuality.pollution?.getDate(date: (airQuality.pollution?.timestamp)!)
        progressBar.progress = Float(usAQI)/200.00
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

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    var advisories: [Advisory] {

        var allAdvisories = [Advisory]()
        guard let usAQI = airQuality.pollution?.aqius else { return allAdvisories }
        allAdvisories += Advisory.for(AQI: usAQI)
        
        return allAdvisories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "advisoryCell", for: indexPath) as! AdvisoryCell
        
        cell.advisoryImage.image = advisories[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advisories.count
    }
}
