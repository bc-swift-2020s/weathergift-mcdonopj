//
//  ViewController.swift
//  WeatherGift3
//
//  Created by Ann McDonough on 3/18/20.
//  Copyright © 2020 Patrick McDonough. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    //@IBOutlet weak var editBarButton: UIToolbar!
    
   // @IBOutlet weak var addBarButton: UIToolbar!
    //   @IBOutlet weak var tableView: UITableView!
    
    var weatherLocations: [WeatherLocation] = []
    
  //  @IBOutlet weak var editBarButton: UIBarButtonItem!
    

 //   @IBOutlet weak var addBarButton: UIBarButtonItem!
    var selectedLocationIndex = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        var weatherLocation = WeatherLocation(name: "Chestnut Hill, MA", latitude: 0, longitude: 0)
//        weatherLocations.append(weatherLocation)
//
//         weatherLocation = WeatherLocation(name: "Lilongwe, Malawi", latitude: 0, longitude: 0)
//              weatherLocations.append(weatherLocation)
//         weatherLocation = WeatherLocation(name: "Buenos Aires, Argentina", latitude: 0, longitude: 0)
//          weatherLocations.append(weatherLocation)
//      
        tableView.dataSource = self
        tableView.delegate = self
    
        
    }
    
    func saveLocations() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations) {
            UserDefaults.standard.set(encoded, forKey: "weatherLocations")
        } else {
            print("Error: Saving encoded didn't work")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveLocations()
    }
    

    
    
    

    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) { //had to remove backslash
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//          UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields
//
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
               tableView.setEditing(false, animated: true)
                          sender.title = "Edit"
                   addBarButton.isEnabled = true
                      }else{
                   tableView.setEditing(true, animated: true)
                          sender.title = "Done"
                       addBarButton.isEnabled = false
           }
    }
   
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        cell.detailTextLabel?.text = "Lat:\(weatherLocations[indexPath.row].latitude), Long: \(weatherLocations[indexPath.row].longitude)"
        print("Name: \(weatherLocations[indexPath.row].name) Lat:\(weatherLocations[indexPath.row].latitude), Long: \(weatherLocations[indexPath.row].longitude)")
        print("Im in the function")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove =  weatherLocations[sourceIndexPath.row]
         weatherLocations.remove(at: sourceIndexPath.row)
         weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
       
    }
    
    
}


extension ViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    let newLocation = WeatherLocation(name: place.name ?? "unknown place", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    weatherLocations.append(newLocation)
    tableView.reloadData()
    
    print("It is supposed to be appended")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }


}
