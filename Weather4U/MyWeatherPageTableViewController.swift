//
//  MyWeatherPageTableViewController.swift
//  Weather4U
//
//  Created by 강태영 on 5/13/24.
//

import UIKit

class MyWeatherPageTableViewController: UITableViewController {
    
    let data = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 설정
        tableView.register(MyWeatherPageTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyWeatherPageTableViewCell
        
        // 데이터 설정
        cell.cityLabel.text = "CityName \(indexPath.row)"
        cell.tempLabel.text = "Temp \(indexPath.row)"
        cell.highLabel.text = "H\(indexPath.row)"
        cell.lowLabel.text = "L\(indexPath.row)"
        cell.weatherLabel.text = "Sunny\(indexPath.row)"
        // 이미지 설정
        if let image = UIImage(named: "weatherImage") {
            cell.cellImageView.image = image
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 높이 설정
        return 150
    }
}
