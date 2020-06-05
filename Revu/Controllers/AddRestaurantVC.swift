//
//  AddRestaurantVC.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//

import UIKit
import CoreData

protocol AddRestaurantDelegate {
    func added(_ restaurant: Restaurant)
}

class AddRestaurantVC: UIViewController {
    var delegate: AddRestaurantDelegate?
    @IBOutlet weak var nameTextField: RevuTextField!
    @IBOutlet weak var cuisineTextField: RevuTextField!
    @IBOutlet weak var tableView: PickerTableView!
    
    // Add to CD
    let cuisines = ["Afghan", "African", "Albanian", "American", "Arabian", "Argentinian", "Armenian", "Asian Fusion", "Australian", "Austrian", "Bagels", "Bakery", "Bangladeshi", "Barbeque", "Belgian", "Brasseries", "Brazilian", "Breakfast", "British", "Brunch", "Buffets", "Burgers", "Burmese", "Cafes", "Cafeteria", "Cajun", "Californian", "Calzones", "Cambodian", "Cantonese", "Caribbean", "Catalan", "Cheesesteaks", "Chicken", "Chicken Wings", "Chili", "Chinese", "Classic", "Coffee and Tea", "Colombian", "Comfort Food", "Costa Rican", "Creole", "Crepes", "Cuban", "Czech", "Delis", "Dessert", "Dim Sum", "Diner", "Dominican", "Eclectic", "Ecuadorian", "Egyptian", "El Salvadoran", "Empanadas", "English", "Ethiopian", "Fast Food", "Filipino", "Fine Dining", "Fish & Chips", "Fondue", "Food Cart", "Food Court", "Food Stands", "French", "Fresh Fruits", "Frozen Yogurt", "Gastropubs", "German", "Gluten-Free", "Greek", "Grill", "Guatemalan", "Gyro", "Haitian", "Halal", "Hawaiian", "Himalayan", "Hoagies", "Hot Dogs", "Hot Pot", "Hungarian", "Iberian", "Ice Cream", "Indian", "Indonesian", "Irish", "Italian", "Jamaican", "Japanese", "Kids", "Korean", "Kosher", "Laotian", "Late Night", "Latin American", "Lebanese", "Live/Raw Food", "Low Carb", "Malaysian", "Mandarin", "Mediterranean", "Mexican", "Middle Eastern", "Modern European", "Mongolian", "Moroccan", "Nepalese", "Noodles", "Nouvelle Cuisine", "Nutritious", "Organic", "Pakistani", "Pancakes", "Pasta", "Persian", "Persian/Iranian", "Peruvian", "Pitas", "Pizza", "Polish", "Portuguese", "Potato", "Poutineries", "Pub Food", "Puerto Rican", "Ribs", "Russian", "Salad", "Sandwiches", "Scandinavian", "Scottish", "Seafood", "Senegalese", "Singaporean", "Slovakian", "Small Plates", "Smoothies and Juices", "Soul Food", "Soup", "South African", "South American", "Southern", "Southwestern", "Spanish", "Sri Lankan", "Steakhouses", "Subs", "Supper Clubs", "Sushi Bars", "Syrian", "Szechwan", "Taiwanese", "Tapas", "Tex-Mex", "Thai", "Tibetan", "Turkish", "Ukrainian", "Uzbek", "Vegan", "Vegetarian", "Vietnamese", "Wraps"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 105
        tableView.rowHeight = UITableView.automaticDimension
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addRestaurant(_ sender: Any) {
        guard let n = nameTextField.text, !n.isEmpty, let c = cuisineTextField.text, !c.isEmpty else {
            showOkayAlert(title: "Oops", message: "Please complete all fields", handler: nil)
            return
        }
        save(n, cuisine: c)
    }
    
    func save(_ name: String, cuisine: String) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity =
          NSEntityDescription.entity(forEntityName: "Restaurant",
                                     in: managedContext)!
        
       guard let restaurant = NSManagedObject(entity: entity,
                                              insertInto: managedContext) as? Restaurant else {
                                                fatalError()
        }
        
        restaurant.setValue(name, forKeyPath: "name")
        restaurant.setValue(cuisine, forKey: "cuisine")
        
        do {
          try managedContext.save()
            delegate?.added(restaurant)
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AddRestaurantVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cuisines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cuisine") as? CuisineCell else { fatalError() }
        cell.titleLabel.text = cuisines[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cuisineTextField.text = cuisines[indexPath.row]
        tableView.isHidden = true
        view.layoutIfNeeded()
    }
}

// MARK: - UITextFieldDelegate
extension AddRestaurantVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cuisineTextField {
            textField.resignFirstResponder()
            tableView.isHidden = false
            view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - CuisineCell
class CuisineCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
