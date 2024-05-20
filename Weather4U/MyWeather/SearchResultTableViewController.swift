//
//  SearchResultTableViewController.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/17/24.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    var result: [LocationDatum] = []
    
    override func viewDidLoad() {
        
        setTableView()
        
        tableView.reloadData()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.backgroundColor = .white
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
        
        let result = result[indexPath.row]
        cell.locationNameLabel.text = result.city.rawValue
    
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
}
