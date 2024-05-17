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
        
        view.backgroundColor = UIColor(named: "cell")
        
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
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyWeatherPageTableViewCell
        
        // 데이터 설정
        cell.cityLabel.text = city
        cell.tempLabel.text = (CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "-") + "°C"
        cell.highLabel.text = (CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "-") + "°C"
        cell.lowLabel.text = (CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "-") + "°C"
        cell.weatherLabel.text = (CategoryManager.shared.getTodayWeatherDataValue(dataKey: .SKY) ?? "-")

        // 이미지 설정
        if let weatherImage = UIImage(named: "sunny") {
            cell.cellImageView.image = weatherImage
        } else {
            cell.cellImageView.image = UIImage(named: "defaultWeatherImage")
        }
        
        // 배경색 설정
                switch cell.weatherLabel.text {
                case "sunny":
                    cell.backgroundColor = UIColor(named: "cell")
                    view.backgroundColor = UIColor(named: "Background")
                case "cloudy":
                    cell.backgroundColor = UIColor.purple
                    view.backgroundColor = UIColor.systemPurple
                case "rainy":
                    cell.backgroundColor = UIColor.purple
                    view.backgroundColor = UIColor.systemPurple
                default:
                    cell.backgroundColor = UIColor(named: "cell")
                    view.backgroundColor = UIColor(named: "Background")
                }

        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 // 각 섹션 사이의 공간을 조절하는 높이
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 높이 설정
        if SearchViewController.isEditMode == false {
            return 150
        } else {
            return 100
        }
    }
}

extension MyWeatherPageTableViewController {
    
    // 0번 셀은 수정이 안되도록 설정
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.row > 0
    }
    
    // 행 삭제
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        indexPath.row > 0 ? .delete : .none
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(weatherData[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 드래그 앤 드롭
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = weatherData[indexPath.row]
        return [ dragItem ]
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0 ? true : false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = weatherData.remove(at: sourceIndexPath.row)
        weatherData.insert(mover, at: destinationIndexPath.row)
    }
    
}
