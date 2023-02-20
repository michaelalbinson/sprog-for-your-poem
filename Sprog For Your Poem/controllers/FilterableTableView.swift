//
//  FilterableTableView.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/19/23.
//

import Foundation
import UIKit

class FilterableTableView: UITableViewController, UISearchResultsUpdating {
    var filteredList: [Any] = []
    var unfilteredList: [Any] = []
    var searchController: UISearchController?
    var placeholderText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the search controller
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.searchBar.placeholder = self.placeholderText
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    // TODO: Override!
    func filterRows(_ filterList: [Any], searchText: String) -> [Any] {
        // needs to be overriden
        return []
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if (self.isFiltering() && self.filteredList.count == 0) || self.unfilteredList.count == 0 {
            // if there's no data to display
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            if self.unfilteredList.count == 0 {
                noDataLabel.text      = "Nothing Here Yet!"
            } else {
                noDataLabel.text      = "No Results Found"
            }
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        } else {
            // if there's data to display
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.filteredList.count
        }
        
        return self.unfilteredList.count
    }
    
    // MARK: Private filtering methods
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return self.searchController?.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return self.searchController?.isActive ?? false && !searchBarIsEmpty()
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.filteredList = self.filterRows(self.unfilteredList, searchText: searchText)
        tableView.reloadData()
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text!)
    }
}
