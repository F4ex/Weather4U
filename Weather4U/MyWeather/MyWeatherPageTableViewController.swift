//
//  MyWeatherPageTableViewController.swift
//  Weather4U
//
//  Created by 강태영 on 5/13/24.
//

import UIKit
import Alamofire
import SnapKit

class MyWeatherPageTableViewController: UITableViewController {
   
    
    var weatherData: [Item] = []
    var city: String = "Seoul"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀 간격 조정
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        // 테이블 뷰 설정
        tableView.register(MyWeatherPageTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        
        // 테이블 뷰 삭제
        tableView.isEditing = false
        
        // 날씨 데이터 가져오기
        fetchWeatherData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyWeatherPageTableViewCell
        
        // 데이터 설정
        let item = weatherData[indexPath.row]
        cell.cityLabel.text = city
        cell.tempLabel.text = "\(item.fcstValue)°C"
        cell.highLabel.text = "H: \(item.fcstValue)°C"
        cell.lowLabel.text = "L: \(item.fcstValue)°C"
        cell.weatherLabel.text = "Sunny"
        // 이미지 설정
        if let weatherImage = UIImage(named: "sunny") {
            cell.cellImageView.image = weatherImage
        } else {
            cell.cellImageView.image = UIImage(named: "defaultWeatherImage")
        }
        
        // 셀의 contentView를 뒤로 보내기
        cell.contentView.sendSubviewToBack(cell.cellImageView)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 // 각 섹션 사이의 공간을 조절하는 높이
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 높이 설정
        return 150
    }
    
    // MARK: - Data Fetching
    
    func fetchWeatherData() {
        let currentDate = Date()
        NetworkManager.shared.fetchWeatherData(completion: { result in
            switch result {
            case .success(let data):
                // 날씨 데이터 업데이트
                self.weatherData = data
                // TableView 새로고침
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        })
    }
}
