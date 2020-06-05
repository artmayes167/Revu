//
//  StarReviewControl.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//

import UIKit

class StarReviewControl: UIView {
    
    // buttons are tagged according to placement in the control
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    var stars: [UIButton] = []
    var selectedRating = 0
    
    func configure() {
        stars = [star1, star2, star3, star4, star5]
    }
    
    @IBAction func selectedStar(_ sender: UIButton) {
        selectedRating = sender.tag
        for s in stars {
            s.isSelected = s.tag <= selectedRating ? true : false
        }
    }
}
