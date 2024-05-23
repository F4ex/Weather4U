//
//  MyWeatherPageTableViewController.swift
//  Weather4U
//
//  Created by 강태영 on 5/13/24.
//
import CoreData
import UIKit
import Alamofire
import SnapKit

class MyWeatherPageTableViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    let currentTime = CategoryManager.shared.currentFormattedTime()
    var weatherStatus = ""
    static var array: [LocationAllData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀 간격 조정
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        // 테이블 뷰 설정
        tableView.register(MyWeatherPageTableViewCell.self, forCellReuseIdentifier: "NormalCellIdentifier")
        tableView.register(FirstTableViewCell.self, forCellReuseIdentifier: "FirstCellIdentifier")
        tableView.delegate = self
        
        // 테이블 뷰 삭제
        tableView.isEditing = false
        
        CoreDataManager.shared.readData()
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        CoreDataManager.shared.readData()
        
//        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.addLocationData.count
    }
    // MARK: - First Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "FirstCellIdentifier", for: indexPath) as! FirstTableViewCell
            firstCell.selectionStyle = .none
            firstCell.locationLabel.text = "My Location"
            firstCell.cityLabel.text = "Seoul"
            
            let tempCelsius = Double(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "0") ?? 0.0
            let highTempCelsius = Double(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "0") ?? 0.0
            let lowTempCelsius = Double(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "0") ?? 0.0
            
            if SearchViewController.isCelsius {
                let tCelsius = (tempCelsius).rounded()
                let hCelsius = (highTempCelsius).rounded()
                let lCelsius = (lowTempCelsius).rounded()
                
                firstCell.tempLabel.text = "\(Int(tCelsius))°"
                firstCell.highLabel.text = "H: \(Int(hCelsius))°"
                firstCell.lowLabel.text = "L: \(Int(lCelsius))°"
                firstCell.weatherLabel.text = (DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .SKY) ?? "-")
            } else {
                let tempFahrenheit = (tempCelsius * 1.8 + 32).rounded()
                let highTempFahrenheit = (highTempCelsius * 1.8 + 32).rounded()
                let lowTempFahrenheit = (lowTempCelsius * 1.8 + 32).rounded()
                
                firstCell.tempLabel.text = "\(Int(tempFahrenheit))°"
                firstCell.highLabel.text = "H: \(Int(highTempFahrenheit))°"
                firstCell.lowLabel.text = "L: \(Int(lowTempFahrenheit))°"
            }
            // 배경색 설정
            switch firstCell.weatherLabel.text {
            case "sunny":
                firstCell.contentView.backgroundColor = UIColor(named: "Background")
                firstCell.tempLabel.textColor = UIColor(named: "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            case "Mostly Cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named:"sun&cloud2")
            case "cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named:"cloudy2")
            case "비":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named: "rain2")
            case "비/눈":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                firstCell.tempLabel.textColor = UIColor(named: "cellS")
                firstCell.highLabel.textColor = UIColor(named: "fontS")
                firstCell.lowLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherImageView.image = UIImage(named: "snow&rain2")
            case "눈":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                firstCell.tempLabel.textColor = UIColor(named: "cellS")
                firstCell.highLabel.textColor = UIColor(named: "fontS")
                firstCell.lowLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherImageView.image = UIImage(named: "snow2")
            default:
                firstCell.contentView.backgroundColor = UIColor(named: "Background")
                firstCell.tempLabel.textColor = UIColor(named: "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            }
            switch currentTime {
            case "2000", "2100", "2200", "2300", "0000", "0100", "0200", "0300", "0400", "0500", "0600":
                firstCell.contentView.backgroundColor = UIColor.purple
                firstCell.locationLabel.textColor = UIColor.white
                firstCell.cityLabel.textColor = UIColor.white
                firstCell.tempLabel.textColor = UIColor.white
                firstCell.highLabel.textColor = UIColor.white
                firstCell.lowLabel.textColor = UIColor.white
                firstCell.weatherLabel.textColor = UIColor.white
                firstCell.weatherImageView.image = UIImage(named: "moon2")
            case _ where weatherStatus == "sunny":
                firstCell.contentView.backgroundColor = UIColor(named: "Background")
                firstCell.tempLabel.textColor = UIColor(named: "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            case _ where weatherStatus == "Mostly Cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named:"sun&cloud2")
            case _ where weatherStatus == "cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named:"cloudy2")
            case _ where weatherStatus == "비":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named: "rain2")
            case _ where weatherStatus == "소나기":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named: "heavyRain2")
            case _ where weatherStatus == "비/눈":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                firstCell.tempLabel.textColor = UIColor(named: "fontS")
                firstCell.highLabel.textColor = UIColor(named: "fontS")
                firstCell.lowLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherImageView.image = UIImage(named: "snow&rain2")
            case _ where weatherStatus == "눈":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                firstCell.tempLabel.textColor = UIColor(named: "fontS")
                firstCell.highLabel.textColor = UIColor(named: "fontS")
                firstCell.lowLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherImageView.image = UIImage(named: "snow2")
            default:
                firstCell.contentView.backgroundColor = UIColor(named: "Background")
                firstCell.tempLabel.textColor = UIColor(named: "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            }
            return firstCell
            // MARK: - Cell
        } else {
            let cell: MyWeatherPageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalCellIdentifier", for: indexPath) as! MyWeatherPageTableViewCell
            cell.selectionStyle = .none
            cell.cityLabel.text = CoreDataManager.addLocationData[indexPath.row].city
            cell.cityDetailLabel.text = "\(CoreDataManager.addLocationData[indexPath.row].town ?? "") \(CoreDataManager.addLocationData[indexPath.row].village ?? "")"
            cell.weatherLabel.text = (DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .SKY) ?? "-")
            
            let tempCelsius = Double(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "0") ?? 0.0
            let highTempCelsius = Double(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "0") ?? 0.0
            let lowTempCelsius = Double(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "0") ?? 0.0
            
            if SearchViewController.isCelsius {
                let tCelsius = (tempCelsius).rounded()
                let hCelsius = (highTempCelsius).rounded()
                let lCelsius = (lowTempCelsius).rounded()
                
                cell.tempLabel.text = "\(Int(tCelsius))°"
                cell.highLabel.text = "H: \(Int(hCelsius))°"
                cell.lowLabel.text = "L: \(Int(lCelsius))°"
                
            } else {
                let tempFahrenheit = (tempCelsius * 1.8 + 32).rounded()
                let highTempFahrenheit = (highTempCelsius * 1.8 + 32).rounded()
                let lowTempFahrenheit = (lowTempCelsius * 1.8 + 32).rounded()
                
                cell.tempLabel.text = "\(Int(tempFahrenheit))°"
                cell.highLabel.text = "H: \(Int(highTempFahrenheit))°"
                cell.lowLabel.text = "L: \(Int(lowTempFahrenheit))°"
            }
            
            // 이미지 설정
            if let weatherImage = UIImage(named: "sun2") {
                cell.cellImageView.image = weatherImage
            } else {
                cell.cellImageView.image = UIImage(named: "defaultWeatherImage")
            }
            
            // 배경색 설정
            switch cell.weatherLabel.text {
            case "sunny":
                cell.contentView.backgroundColor = UIColor(named: "Background")
                cell.tempLabel.textColor = UIColor(named: "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
                cell.cellImageView.image = UIImage(named: "sun2")
            case "Mostly Cloudy":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
                cell.cellImageView.image = UIImage(named:"sun&cloud2")
            case "cloudy":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named:"cloudy2")
            case "비":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named: "rain2")
            case "소나기":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named: "heavyRain2")
            case "비/눈":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                cell.tempLabel.textColor = UIColor(named: "fontS")
                cell.highLabel.textColor = UIColor(named: "fontS")
                cell.lowLabel.textColor = UIColor(named: "fontS")
                cell.weatherLabel.textColor = UIColor(named: "fontS")
                cell.cellImageView.image = UIImage(named: "snow&rain2")
            case "눈":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                cell.tempLabel.textColor = UIColor(named: "fontS")
                cell.highLabel.textColor = UIColor(named: "fontS")
                cell.lowLabel.textColor = UIColor(named: "fontS")
                cell.weatherLabel.textColor = UIColor(named: "fontS")
                cell.cellImageView.image = UIImage(named: "snow2")
            default:
                cell.contentView.backgroundColor = UIColor(named: "Background")
                cell.tempLabel.textColor = UIColor(named: "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
                cell.cellImageView.image = UIImage(named: "sun2")
            }
            switch currentTime {
            case "2000", "2100", "2200", "2300", "0000", "0100", "0200", "0300", "0400", "0500", "0600":
                cell.contentView.backgroundColor = UIColor.purple
                cell.cityLabel.textColor = UIColor.white
                cell.tempLabel.textColor = UIColor.white
                cell.highLabel.textColor = UIColor.white
                cell.lowLabel.textColor = UIColor.white
                cell.weatherLabel.textColor = UIColor.white
                cell.cellImageView.image = UIImage(named: "moon2")
            case _ where weatherStatus == "sunny":
                cell.contentView.backgroundColor = UIColor(named: "Background")
                cell.tempLabel.textColor = UIColor(named: "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
                cell.cellImageView.image = UIImage(named: "sun2")
            case _ where weatherStatus == "Mostly Cloudy":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
                cell.cellImageView.image = UIImage(named:"sun&cloud2")
            case _ where weatherStatus == "cloudy":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named:"cloudy2")
            case _ where weatherStatus == "비":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named: "rain2")
            case _ where weatherStatus == "소나기":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named: "heavyRain2")
            case _ where weatherStatus == "비/눈":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                cell.tempLabel.textColor = UIColor(named: "fontS")
                cell.highLabel.textColor = UIColor(named: "fontS")
                cell.lowLabel.textColor = UIColor(named: "fontS")
                cell.weatherLabel.textColor = UIColor(named: "fontS")
                cell.cellImageView.image = UIImage(named: "snow&rain2")
            case _ where weatherStatus == "눈":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                cell.tempLabel.textColor = UIColor(named: "fontS")
                cell.highLabel.textColor = UIColor(named: "fontS")
                cell.lowLabel.textColor = UIColor(named: "fontS")
                cell.weatherLabel.textColor = UIColor(named: "fontS")
                cell.cellImageView.image = UIImage(named: "snow2")
            default:
                cell.contentView.backgroundColor = UIColor(named: "Background")
                cell.tempLabel.textColor = UIColor(named: "cell")
                cell.highLabel.textColor = UIColor.black
                cell.lowLabel.textColor = UIColor.black
                cell.weatherLabel.textColor = UIColor.black
                cell.cellImageView.image = UIImage(named: "sun2")
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 // 각 섹션 사이의 공간을 조절하는 높이
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 높이 설정
        if SearchViewController.isEditMode == false {
            return 111
        } else {
            return 110
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
            CoreDataManager.addLocationData.remove(at: indexPath.row)
            CoreDataManager.shared.deleteData(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let navigationController = self.navigationController {
                print("Navigating to root view controller")
                navigationController.popToRootViewController(animated: true)
            } else {
                print("Navigation controller is nil")
            }
        } else {
            MainViewController.isModal2 = true
            let modalVC = MainViewController()
            modalVC.modalPresentationStyle = .fullScreen
            present(modalVC, animated: true) {
                }
            }

            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    
    // 드래그 앤 드롭
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = CoreDataManager.addLocationData[indexPath.row]
        
        return [ dragItem ]
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0 ? true : false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = CoreDataManager.addLocationData.remove(at: sourceIndexPath.row)
        CoreDataManager.addLocationData.insert(mover, at: destinationIndexPath.row)
        
        CoreDataManager.shared.updateCoreDataOrder()
    }
    
    
    
    
    
}
