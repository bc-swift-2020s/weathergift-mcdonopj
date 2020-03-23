//
//  PageViewController.swift
//  WeatherGift3
//
//  Created by Ann McDonough on 3/22/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        loadLocations()
        
        setViewControllers([createLocationDetailController(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
    }
    
    
      func loadLocations() {
        print("This is weatherLocations")
        print(weatherLocations)
          guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations")
              as? Data else {
                  print("warning could not load it. If first time installing ignore this error")
                //TODO GET USER LOCATION FOR FIRST ELEMENT IN ARRAY
                weatherLocations.append(WeatherLocation(name: "Current Location", latitude: 20.20, longitude: 20.20))
                print("This is weatherLocations now")
                print(weatherLocations)
                  return
          }
          let decoder = JSONDecoder()
          if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
              self.weatherLocations = weatherLocations
          } else {
              print("error could not decode data from userDefaults")
          }
           //TODO GET USER LOCATION FOR FIRST ELEMENT IN ARRAY
        print("about to append)")
        if weatherLocations.isEmpty {
            print("weatherLocations is empty")
               weatherLocations.append(WeatherLocation(name: "Current Location", latitude: 20.20, longitude: 20.20))
        }
        
        
      }
    
    
    func createLocationDetailController(forPage page: Int) -> LocationDetailViewController {
        let detailViewController = storyboard!.instantiateViewController(identifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.locationIndex = page
        return detailViewController
    }

}


extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex > 0 {
                return createLocationDetailController(forPage: currentViewController.locationIndex - 1)
                
            }
           
        }
 return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count - 1 {
                       return createLocationDetailController(forPage: currentViewController.locationIndex + 1)
                       
                   }
                 
    }
      return nil
}

}
