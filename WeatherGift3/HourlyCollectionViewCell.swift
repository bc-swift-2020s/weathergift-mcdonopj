//
//  HourlyCollectionViewCell.swift
//  
//
//  Created by Ann McDonough on 3/30/20.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var PrecipProbabilityLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var rainDropImageView: UIImageView!
    
    var hourlyWeather: HourlyWeather! {
        didSet {
            hourLabel.text = hourlyWeather.hour
            iconImageView.image = UIImage()
            iconImageView.image = getIconImage(iconName: hourlyWeather.hourlyIcon)
            temperatureLabel.text = "\(hourlyWeather.hourlyTemperature)°"
            PrecipProbabilityLabel.text = "\(hourlyWeather.hourlyPrecipProbability)%"
            if hourlyWeather.hourlyPrecipProbability >= 20 {
                rainDropImageView.isHidden = false
                PrecipProbabilityLabel.isHidden = false
            } else {
                rainDropImageView.isHidden = true
                PrecipProbabilityLabel.isHidden = true
            }
        }
    }

    func getIconImage(iconName: String) -> UIImage {
       // print("Get icon image function is executing!)
        switch iconName {
        case "clear-day":
        return UIImage(systemName: "sun.max") ?? UIImage()
            
            case "clear-night":
                   return UIImage(systemName: "moon") ?? UIImage()
            case "rain":
                   return UIImage(systemName: "cloud.rain") ?? UIImage()
            case "snow":
                   return UIImage(systemName: "snow") ?? UIImage()
            case "sleet":
                   return UIImage(systemName: "cloud.sleet") ?? UIImage()
            case "wind":
                   return UIImage(systemName: "wind") ?? UIImage()
            case "fog":
                   return UIImage(systemName: "cloud.fog") ?? UIImage()
            case "cloudy":
                   return UIImage(systemName: "cloud") ?? UIImage()
            case "partly-cloudy-day":
                   return UIImage(systemName: "cloud.sun") ?? UIImage()
            case "partlu-cloudy-night":
                   return UIImage(systemName: "cloud.moon") ?? UIImage()
            case "hail":
                   return UIImage(systemName: "cloud.hail") ?? UIImage()
            case "thunderstorm":
                   return UIImage(systemName: "cloud.bolt.rain") ?? UIImage()
            case "tornado":
                   return UIImage(systemName: "tornado") ?? UIImage()
        default:
            return UIImage(systemName: "questionmark.diamond") ?? UIImage()
            
        }
        
    }
    
    
    
    
    
}
