//
//  ViewController.swift
//  Yelp
//
//  Created by Shaz Rajput on 7/25/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var summaryTable: UITableView!
    
    let businessCellIdentifier = "com.walmart.shaz.yelp.businesscell"
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchBar: UISearchBar!
    var isSearchActive = false
    var appliedFilters: [String: AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.summaryTable.dataSource = self
        self.summaryTable.delegate = self
        self.summaryTable.rowHeight = UITableViewAutomaticDimension
        self.summaryTable.estimatedRowHeight = 120
        
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        navigationItem.titleView = self.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.businesses != nil {
            return self.businesses.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.summaryTable.dequeueReusableCellWithIdentifier(self.businessCellIdentifier) as! BusinessCell
        
        if isSearchActive {
            cell.business = self.filteredBusinesses[indexPath.row]
        } else {
            cell.business = self.businesses[indexPath.row]
        }
        
        return cell
    }
    
    func searchWithLatestFilters(append: Bool = false) {
        var currentFilters = [String: AnyObject]()
        currentFilters = self.appliedFilters!
        
        let categories = currentFilters["categories"] as? [String]
        let dealsOn = currentFilters["deals"] as? Bool
        let sortMethod = currentFilters["sort_method"] as? Int
        let distanceSelected = currentFilters["distance"] as? String
        let offset = currentFilters["offset"] as? String
        var searchTerm = currentFilters["search_term"] as? String
        if searchTerm == nil {
            searchTerm = "Restaurants"
        }
        
        Business.searchWithTerm(searchTerm!, sort: YelpSortMode(rawValue: sortMethod!), categories: categories, deals: dealsOn, distance: distanceSelected, offset: offset,completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.summaryTable.reloadData()
            
            }
        )
    }
}
