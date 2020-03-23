//
//  LocationDetailViewController.swift
//  WeatherGift3
//
//  Created by Ann McDonough on 3/20/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var tempteratureLabel: UILabel!
    
    //var weatherLocation: WeatherLocation!
    var locationIndex = 0
    //var weatherDetail: WeatherDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUserInterface()
        
        // Do any additional setup after loading the view.
    }
    
  
    
    func updateUserInterface() {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        let weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
       
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
       
        //this is not running when it should be
        print("Im about to enter weatherDetail.getData(). Does it actually go in?")
        weatherDetail.getData {
            print("This is in the get data function. probably problem")
            DispatchQueue.main.async {
                self.dateLabel.text = weatherDetail.timezone
            self.locationLabel.text = weatherDetail.name
                self.tempteratureLabel.text = "\(weatherDetail.temperature)"
                self.descriptionLabel.text = weatherDetail.summary
                self.imageView.image = UIImage(named: weatherDetail.dailyIcon)
        }
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
      //  weatherLocation = pageViewController.weatherLocations[locationIndex]
        destination.weatherLocations = pageViewController.weatherLocations
    }
    
    
    @IBAction func unwindFromViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! ViewController
        locationIndex = source.selectedLocationIndex
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        pageViewController.weatherLocations = source.weatherLocations
pageViewController.setViewControllers([pageViewController.createLocationDetailController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
          let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        var direction: UIPageViewController.NavigationDirection = .forward
        if sender.currentPage < locationIndex {
            direction = .reverse
        }
pageViewController.setViewControllers([pageViewController.createLocationDetailController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
        
    }

}
