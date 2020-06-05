//
//  AddReviewVC.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//

import UIKit
import CoreData

protocol AddReviewDelegate {
    func added(_ review: Review, context: NSManagedObjectContext)
}

class AddReviewVC: UIViewController {
    var restaurant: Restaurant?
    var reviewDate: Date = Date()
    var delegate: AddReviewDelegate?
    
    @IBOutlet var dismissKeyboardTap: UITapGestureRecognizer!
    @IBOutlet weak var starReviewControl: StarReviewControl!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateTextField: RevuTextField!
    @IBOutlet weak var commentsTextView: RevuTextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainer: UIView!
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rateLabel.text = "Rate " + (restaurant?.name ?? "")
        starReviewControl.configure()
    }
    
    // MARK: - Date Picker Functions
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        reviewDate = sender.date
    }
    
    @IBAction func doneWithDatePicker(_ sender: Any) {
        dateTextField.text = reviewDate.stringFromDate()
        datePickerContainer.isHidden = true
        view.layoutIfNeeded()
    }
    
    // gesture recognizer to allow for touch outside textView to dismiss keyboard
    @IBAction func dismissKeybard(_ sender: Any) {
        commentsTextView.resignFirstResponder()
        dismissKeyboardTap.isEnabled = false
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReview(_ sender: Any) {
        save()
    }
    
    func save() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext

        let review = Review(context: managedContext)
        review.date = datePicker.date
        review.stars = Int32(starReviewControl.selectedRating)
        review.text = commentsTextView.text
        delegate?.added(review, context: managedContext)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate, UITextFieldDelegate
extension AddReviewVC: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            textField.resignFirstResponder()
            datePickerContainer.isHidden = false
            view.layoutIfNeeded()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        dismissKeyboardTap.isEnabled = true
    }
}
