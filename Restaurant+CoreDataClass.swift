//
//  Restaurant+CoreDataClass.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Restaurant)
public class Restaurant: NSManagedObject {
    func starAverage() -> String {
        let a = averageScore()
        let str = a > 0 ? String(averageScore()) : "0"
        return str
    }
    
    func averageScore() -> Float {
        var total = 0
        guard let reviews = reviews else { return 0 }
        for review in reviews {
            if let r = review as? Review {
                total += Int(r.stars)
            }
        }
        if reviews.count > 0 {
            var div = Float(total) / Float(reviews.count)
            div = (div * 10).rounded()
            div = div / 10
            return div
        }
        return 0
    }
}
