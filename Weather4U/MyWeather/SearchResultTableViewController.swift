//
//  SearchResultTableViewController.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/17/24.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let result = SearchViewController.result[indexPath.row]
        cell.locationNameLabel.text = result.Region
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchViewController.result.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        MainViewController.isModal = true
        
        let modalVC = MainViewController()
        
        MainViewController.selectRegion = SearchViewController.result[indexPath.row] // 클릭한 지역의 값이 array 안으로
        
        present(modalVC, animated: true, completion: nil)
    }




}
