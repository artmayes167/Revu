//
//  FoodieMasterVC.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//

import UIKit
import CoreData

class FoodieMasterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var restaurants: [Restaurant] = []
    var sortStyle: SortStyle = .average
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Restaurant>(entityName: "Restaurant")
        do {
            restaurants = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch.  \(error), \(error.userInfo)")
        }
    }

    @IBAction func addNew(_ sender: Any) {
        
    }
    
    // prepared, but unused
    enum SortStyle {
        case average, name, recent
    }
    
    @IBAction func selectedNewSort(_ sender: UISegmentedControl) {
        let styles: [SortStyle] = [.average, .name, .recent]
        sortStyle = styles[sender.selectedSegmentIndex]
    }
    
    func sortWithStyle(_ style: SortStyle) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddRestaurant" {
            if let vc = segue.destination as? AddRestaurantVC {
                vc.delegate = self
            }
        } else if segue.identifier == "toReviews" {
            guard let r = sender as? Restaurant else { fatalError() }
            guard let vc = segue.destination as? ReviewsTVC else { fatalError() }
            vc.restaurant = r
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FoodieMasterVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as? FoodieMasterCell else {
            fatalError()
        }
        cell.configure(for: restaurant)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toReviews", sender: restaurants[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    /*
       // Override to support editing the table view.
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               // Delete the row from the data source
               tableView.deleteRows(at: [indexPath], with: .fade)
           } else if editingStyle == .insert {
               // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
           }
       }
       */
    
}

// MARK: - IndicatorView
@IBDesignable class IndicatorView: UIView {
    @IBOutlet var totalLabel: UILabel!
    var color: UIColor = .blue {
        didSet {
            backgroundColor = color
        }
    }
    
    var total: Int = 0 {
        didSet {
            if total > 9 {
                totalLabel.text = "9+"
            } else {
                totalLabel.text = String(total)
            }
        }
    }
}

// MARK: - FoodieMasterCell
class FoodieMasterCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cuisineLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var indicatorView: IndicatorView!
    
    func configure(for restaurant: Restaurant) {
        titleLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisine
        ratingLabel.text = restaurant.starAverage()
        indicatorView.total = restaurant.reviews?.count ?? 0
    }
}

// MARK: - AddRestaurantDelegate
extension FoodieMasterVC: AddRestaurantDelegate {
    func added(_ restaurant: Restaurant) {
        restaurants.append(restaurant)
        // sort
        tableView.reloadData()
    }
}
