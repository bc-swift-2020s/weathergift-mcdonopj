//
//  WeatherLocation.swift
//  WeatherGift3
//
//  Created by Ann McDonough on 3/18/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, latitude: Double, longitude: Double){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getData() {
        let coordinates = "\(latitude),\(longitude)"
        let urlString = "\(APIurls.darkSkyURL)\(APIKeys.darkSkyKey)/\(coordinates)"
       // let urlString = "https://api.darksky.net/forecast/b94f0875317de54877db4feb06a79295/42.3601,-71.0589"
        print("we are accessing url string \(urlString)")
     
        //Create a URL
        guard let url = URL(string: urlString) else {
            print("Error could not create a url from \(urlString)")
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
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("nice! json \(json)")
            } catch {
                print("JSON ERROR \(error.localizedDescription)")
            }
       
        }
         task.resume()
    
        
    }


}
