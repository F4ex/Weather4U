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
    
    
    static var array: [LocationAllData] = []
    
    var city: String = "Seoul"
    
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
        
        CoreDataManager.shared.readData()
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyWeatherPageTableViewController.array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let firstCell: FirstTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FirstCellIdentifier", for: indexPath) as! FirstTableViewCell

            firstCell.locationLabel.text = "My Location"
            firstCell.cityLabel.text = "Seoul"
            
            let tempCelsius = Double(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "0") ?? 0.0
            let highTempCelsius = Double(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "0") ?? 0.0
            let lowTempCelsius = Double(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "0") ?? 0.0
            
            if SearchViewController.isCelsius {
                let tCelsius = (tempCelsius).rounded()
                let hCelsius = (highTempCelsius).rounded()
                let lCelsius = (lowTempCelsius).rounded()
                
                firstCell.tempLabel.text = "\(Int(tCelsius))°"
                firstCell.highLabel.text = "H: \(Int(hCelsius))°"
                firstCell.lowLabel.text = "L: \(Int(lCelsius))°"
                firstCell.weatherLabel.text = (CategoryManager.shared.getTodayWeatherDataValue(dataKey: .SKY) ?? "-")
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
                firstCell.highLabel.textColor = UIColor.black
                firstCell.lowLabel.textColor = UIColor.black
                firstCell.weatherLabel.textColor = UIColor.black
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            case "cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "fontR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named:"cloudy2")
            case "Mostly Cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "fontR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named:"cloudy2")
            case "rainy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherImageView.image = UIImage(named: "heavyRain2")
            case "snow":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                firstCell.tempLabel.textColor = UIColor(named: "fontS")
                firstCell.highLabel.textColor = UIColor(named: "fontS")
                firstCell.lowLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherImageView.image = UIImage(named: "snow2")
            default:
                firstCell.contentView.backgroundColor = UIColor(named: "Background")
                firstCell.tempLabel.textColor = UIColor(named: "cell")
                firstCell.highLabel.textColor = UIColor.black
                firstCell.lowLabel.textColor = UIColor.black
                firstCell.weatherLabel.textColor = UIColor.black
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            }
            return firstCell
        } else {
            // 일반적인 셀을 생성하고 반환하는 로직
            let cell = tableView.dequeueReusableCell(withIdentifier: "NormalCellIdentifier", for: indexPath) as! MyWeatherPageTableViewCell

            cell.cityLabel.text = MainViewController.selectRegion?.City
            cell.cityDetailLabel.text = "\(MainViewController.selectRegion?.Town ?? "") \(MainViewController.selectRegion?.Village ?? "")"
            cell.weatherLabel.text = (CategoryManager.shared.getTodayWeatherDataValue(dataKey: .SKY) ?? "-")
            
            let tempCelsius = Double(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "0") ?? 0.0
            let highTempCelsius = Double(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "0") ?? 0.0
            let lowTempCelsius = Double(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "0") ?? 0.0
            
            
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
                    cell.highLabel.textColor = UIColor.black
                    cell.lowLabel.textColor = UIColor.black
                    cell.weatherLabel.textColor = UIColor.black
                    cell.cellImageView.image = UIImage(named: "sun2")
                case "cloudy":
                    cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                    cell.tempLabel.textColor = UIColor(named: "fontR")
                    cell.highLabel.textColor = UIColor(named: "fontR")
                    cell.lowLabel.textColor = UIColor(named: "fontR")
                    cell.weatherLabel.textColor = UIColor(named: "fontR")
                    cell.cellImageView.image = UIImage(named:"cloudy2")
                case "Mostly Cloudy":
                    cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                    cell.tempLabel.textColor = UIColor(named: "fontR")
                    cell.highLabel.textColor = UIColor(named: "fontR")
                    cell.lowLabel.textColor = UIColor(named: "fontR")
                    cell.weatherLabel.textColor = UIColor(named: "fontR")
                    cell.cellImageView.image = UIImage(named:"cloudy2")
                case "rainy":
                    cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                    cell.tempLabel.textColor = UIColor(named: "cellR")
                    cell.highLabel.textColor = UIColor(named: "fontR")
                    cell.lowLabel.textColor = UIColor(named: "fontR")
                    cell.weatherLabel.textColor = UIColor(named: "fontR")
                    cell.cellImageView.image = UIImage(named: "heavyRain2")
                case "snow":
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
            MyWeatherPageTableViewController.array.remove(at: indexPath.row)
            CoreDataManager.shared.deleteData(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        } else {
            print("Selected: \(MyWeatherPageTableViewController.array[indexPath.row])")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 드래그 앤 드롭
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = MyWeatherPageTableViewController.array[indexPath.row]
        
        return [ dragItem ]
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0 ? true : false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = MyWeatherPageTableViewController.array.remove(at: sourceIndexPath.row)
        MyWeatherPageTableViewController.array.insert(mover, at: destinationIndexPath.row)
        
        CoreDataManager.shared.updateCoreDataOrder()
    }
    
}


