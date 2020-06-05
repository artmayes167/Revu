//
//  UIKitExtensions.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//

import UIKit

@IBDesignable class DesignableSegmentedControl: UISegmentedControl {}

@IBDesignable class PickerTableView: UITableView {}

@IBDesignable class RevuTextField: UITextField {}

@IBDesignable class RevuTextView: UITextView {}

extension UIView {
  /// Allows corner radius of any view to be set in storyboards
  @IBInspectable public var cornerRadius: CGFloat {
    set {
      clipsToBounds = true
      layer.cornerRadius = newValue
    }
    get {
      return layer.cornerRadius
    }
  }
  
  /// Allows border color of any view to be set in storyboards
  @IBInspectable public var borderColor: UIColor {
    set {
      layer.borderColor = newValue.cgColor
    }
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
  }
  
  /// Allows border width of any view to be set in storyboards
  @IBInspectable public var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIViewController {
    /// Show an Alert with an "Ok" button.
    ///
    /// - Parameters:
    ///   - title: The title for the Alert.
    ///   - message: The message for the Alert.
    func showOkayAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .cancel, handler: handler)
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
}
