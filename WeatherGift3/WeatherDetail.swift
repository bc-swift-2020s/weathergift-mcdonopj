//
//  WeatherDetail.swift
//  WeatherGift3
//
//  Created by Ann McDonough on 3/22/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation

class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var currently: Currently
        var daily: Daily
    }
    
    struct Currently: Codable {
        var temperature: Double
    }
    
    struct Daily: Codable {
        var summary: String
        var icon: String
    }
    
    var timezone = ""
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    
     func getData(completed: @escaping () -> () ) {
      let coordinates = "\(latitude),\(longitude)"
      let urlString = "\(APIurls.darkSkyURL)\(APIKeys.darkSkyKey)/\(coordinates)"
     // let urlString = "https://api.darksky.net/forecast/b94f0875317de54877db4feb06a79295/42.3601,-71.0589"
      print("we are accessing url string \(urlString)")
   
      //Create a URL
      guard let url = URL(string: urlString) else {
          print("Error could not create a url from \(urlString)")
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
            print("Nice! \(result)")
            print("The timezone for \(self.name) is \(result.timezone)")
            self.timezone = result.timezone
            self.temperature = Int(result.currently.temperature.rounded())
            self.summary = result.daily.summary
            self.dailyIcon = result.daily.icon
            
          } catch {
              print("JSON ERROR \(error.localizedDescription)")
          }
     completed()
      }
       task.resume()
  
      
  }


}
