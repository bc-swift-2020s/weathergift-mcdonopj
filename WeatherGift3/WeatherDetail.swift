//
//  WeatherDetail.swift
//  WeatherGift3
//
//  Created by Ann McDonough on 3/22/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation


private let dateformatter: DateFormatter = {
    //   print("I JUST CREATED A new DATE FORMATTER in weatherDetail")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter
}()
private let hourlyformatter: DateFormatter = {
    //  print("I JUST CREATED A new hourly FORMATTER in weatherDetail")
    let hourlyFormatter = DateFormatter()
    hourlyFormatter.dateFormat = "ha"
    return hourlyFormatter
}()


struct DailyWeather: Codable {
    var dailyIcon: String
    var dailyWeekday: String
    var dailySummary: String
    var dailyHigh: Int
    var dailyLow: Int
}

struct HourlyWeather: Codable {
    var hour: String
    var hourlyIcon: String
    var hourlyTemperature: Int
    var hourlyPrecipProbability: Int
}


class WeatherDetail: WeatherLocation {
    
    private struct Result: Codable {
        var timezone: String
        var currently: Currently
        var daily: Daily
        var hourly: Hourly
    }
    
    private struct Currently: Codable {
        var temperature: Double
        var time: TimeInterval
    }
    
    private struct Daily: Codable {
        var summary: String
        var icon: String
        var data: [DailyData]
    }
    
    private struct DailyData: Codable {
        var icon: String
        var time: TimeInterval
        var summary: String
        var temperatureHigh: Double
        var temperatureLow: Double
    }
    
    private struct Hourly: Codable {
        var data: [HourlyData]
    }
    
    private struct HourlyData: Codable {
        var time: TimeInterval
        var icon: String
        var precipProbability: Double
        var temperature: Double
    }
    
    var timezone = ""
    var currentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    var dailyWeatherData: [DailyWeather] = []
    var hourlyWeatherData: [HourlyWeather] = []
    
    func getData(completed: @escaping () -> () ) {
        let coordinates = "\(latitude),\(longitude)"
        let urlString = "\(APIurls.darkSkyURL)\(APIKeys.darkSkyKey)/\(coordinates)"
        // let urlString = "https://api.darksky.net/forecast/b94f0875317de54877db4feb06a79295/42.3601,-71.0589"
        //   print("we are accessing url string \(urlString)")
        
        //Create a URL
        guard let url = URL(string: urlString) else {
            //   print("Error could not create a url from \(urlString)")
            completed()
            return
        }
        
        // create session
        let session = URLSession.shared
        
        //get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error! \(error.localizedDescription)")
            }
            
            //deal with data
            do {
                //let json = try JSONSerialization.jsonObject(with: data!, options: [])
                //print("nice! json \(json)")
                let result = try JSONDecoder().decode(Result.self, from: data!)
                // print("Nice! \(result)")
                // print("The timezone for \(self.name) is \(result.timezone)")
                self.timezone = result.timezone
                self.currentTime = result.currently.time
                self.temperature = Int(result.currently.temperature.rounded())
                self.summary = result.daily.summary
                self.dailyIcon = result.daily.icon
                
                for index in 0..<result.daily.data.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily.data[index].time)
                    dateformatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateformatter.string(from: weekdayDate)
                    let dailyIcon = result.daily.data[index].icon
                    let dailySummary = result.daily.data[index].summary
                    let dailyHigh = Int(result.daily.data[index].temperatureHigh.rounded())
                    let dailyLow = Int(result.daily.data[index].temperatureLow.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    //print("Day: \(dailyWeather.dailyWeekday) High: \(dailyWeather.dailyHigh) Low: \(dailyWeather.dailyLow)")
                }
                
                let lastHour = min(24, result.hourly.data.count)
                print("**** Last hour = \(lastHour)")
                for index in 0..<lastHour {
                    //let hourlyDate = Date(timeIntervalSince1970: result.hourly.data[index].time)
                    let hourlyDate = Date(timeIntervalSince1970: result.hourly.data[index].time)
                    hourlyformatter.timeZone = TimeZone(identifier: result.timezone)
                    let hour = hourlyformatter.string(from: hourlyDate)
                    let hourlyIcon = result.hourly.data[index].icon
                    let precipProbability = Int((result.hourly.data[index].precipProbability * 100).rounded())
                    let temperature = Int(result.hourly.data[index].temperature.rounded())
                    let hourlyWeather = HourlyWeather(hour: hour, hourlyIcon: hourlyIcon, hourlyTemperature: temperature, hourlyPrecipProbability: precipProbability)
                    self.hourlyWeatherData.append(hourlyWeather)
                    //  print("Hour: \(hourlyWeather.hour) Icon: \(hourlyWeather.hourlyIcon) Temperature: \(hourlyWeather.hourlyTemperature) Precip Probability: \(hourlyWeather.hourlyPrecipProbability)")
                    //}
                }
            } catch {
                print("JSON ERROR \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
        
        
    }
    
    
}
