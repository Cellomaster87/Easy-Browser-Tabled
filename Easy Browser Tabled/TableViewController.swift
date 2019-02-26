//
//  TableViewController.swift
//  Easy Browser Tabled
//
//  Created by Michele Galvagno on 26/02/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var websites = ["apple.com", "hackingwithswift.com", "dnd.wizards.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser Tabled"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webViewController = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            webViewController.websiteToLoad = websites[indexPath.row]
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}
