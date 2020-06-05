//
//  ReviewsTVC.swift
//  Revu
//
//  Created by Arthur Mayes on 6/4/20.
//  Copyright © 2020 Arthur Mayes. All rights reserved.
//

import UIKit
import CoreData

class ReviewsTVC: UITableViewController {
    
    var restaurant: Restaurant?
    var reviews: [Review] {
        return restaurant?.reviews?.allObjects as? [Review] ?? []
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 105
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let r = restaurant else { return }
        var str = "Reviews"
        if let c = r.reviews?.count, c > 0 {
            str.append(" (\(c))")
        }
        title = str
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 105
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ReviewCell else { fatalError() }

        cell.configure(for: reviews[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "header") as? HeaderCell, let r = restaurant else { fatalError() }
        cell.configure(for: r)
        return cell.contentView
    }

    @IBAction func addReview(_ sender: Any) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // edit previous review
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddReview" {
            guard let vc = segue.destination as? AddReviewVC else { fatalError() }
            vc.restaurant = restaurant
            vc.delegate = self
        }
    }

}

// MARK: - AddReviewDelegate
extension ReviewsTVC: AddReviewDelegate {
    func added(_ review: Review, context: NSManagedObjectContext) {
        restaurant?.addToReviews(review)
        
        do {
          try context.save()
            tableView.reloadData()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - HeaderCell
class HeaderCell: UITableViewCell {
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    
    func configure(for restaurant: Restaurant) {
        averageLabel.text = restaurant.starAverage() + "\n" + "avg"
        nameLabel.text = restaurant.name
        cuisineLabel.text = restaurant.cuisine
    }
}

// MARK: - ReviewCell
class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func configure(for review: Review) {
        starLabel.text = "\(review.stars)"
        dateLabel.text = review.date?.stringFromDate()
        contentLabel.text = review.text
    }
}
