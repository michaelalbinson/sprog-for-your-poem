//
//  BrowsePoemTableVC.swift
//  Sprog For Your Poem
//
//  Created by Michael Albinson on 2/19/23.
//

import Foundation
import UIKit

class BrowsePoemTableVC: FilterableTableView {
    override func viewDidLoad() {
        self.placeholderText = "Search Poems"
        self.tableView.register(UINib(nibName: "PoemListItem", bundle: nil), forCellReuseIdentifier: "Cell")
        self.unfilteredList = Poem.selectAll()
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PoemListItem
        if self.isFiltering() {
            cell.setPoem(poem: self.filteredList[indexPath.row] as! Poem)
        } else {
            cell.setPoem(poem: self.unfilteredList[indexPath.row] as! Poem)
        }
        
        return cell
    }
    
    override func filterRows(_ filterList: [Any], searchText: String) -> [Any] {
        return filterList.filter({ (item) -> Bool in
            if let poem = item as? Poem {
                return "\(poem.content) \(poem.submission()?.content) \(poem.submission()?.title) \(poem.submission()?.user)"
                    .lowercased()
                    .contains(searchText.lowercased())
            }
            
            return false
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "browseToDetail", sender: selectedCell)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PoemContentVC {
            if let cell = sender as? PoemListItem {
                dest.setPoem(poem: cell.poem!)
            }
        }
    }
}

