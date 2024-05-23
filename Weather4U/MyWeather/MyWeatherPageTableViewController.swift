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
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name("ReloadTableViewNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.updateCoreDataOrder()
        
        //        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.addLocationData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "FirstCellIdentifier", for: indexPath) as! FirstTableViewCell
            firstCell.selectionStyle = .none
            firstCell.locationLabel.text = "My Location"
            firstCell.cityLabel.text = "Seoul"
            
            let tempCelsius = Double(DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .TMP, indexPath: indexPath.row) ?? "0") ?? 0.0
            let highTempCelsius = Double(DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .TMX, indexPath: indexPath.row, currentTime: false, highTemp: true) ?? "0") ?? 0.0
            let lowTempCelsius = Double(DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .TMN, indexPath: indexPath.row, currentTime: false) ?? "0") ?? 0.0
            
            if SearchViewController.isCelsius {
                let tCelsius = (tempCelsius).rounded()
                let hCelsius = (highTempCelsius).rounded()
                let lCelsius = (lowTempCelsius).rounded()
                
                firstCell.tempLabel.text = "\(Int(tCelsius))°"
                firstCell.highLabel.text = "H: \(Int(hCelsius))°"
                firstCell.lowLabel.text = "L: \(Int(lCelsius))°"
                firstCell.weatherLabel.text = (DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .SKY, indexPath: indexPath.row) ?? "-")
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
                firstCell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "font" : "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            case "Mostly Cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "font" : "cell")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named:"sun&cloud2")
            case "cloudy":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontR" : "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                firstCell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                firstCell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherImageView.image = UIImage(named:"cloudy2")
            case "cloudy":
                firstCell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                firstCell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                firstCell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherImageView.image = UIImage(named:"cloud&sun2")
            case "비":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                firstCell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontR" : "cellR")
                firstCell.highLabel.textColor = UIColor(named: "fontR")
                firstCell.lowLabel.textColor = UIColor(named: "fontR")
                firstCell.weatherLabel.textColor = UIColor(named: "fontR")
                firstCell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                firstCell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                firstCell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherImageView.image = UIImage(named: "rain2")
            case "소나기":
                firstCell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                firstCell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                firstCell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                firstCell.weatherImageView.image = UIImage(named: "heavyRain2")
            case "비/눈":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                firstCell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontS" : "cellS")
                firstCell.highLabel.textColor = UIColor(named: "fontS")
                firstCell.lowLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherImageView.image = UIImage(named: "snow&rain2")
            case "눈":
                firstCell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                firstCell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontS" : "cellS")
                firstCell.highLabel.textColor = UIColor(named: "fontS")
                firstCell.lowLabel.textColor = UIColor(named: "fontS")
                firstCell.weatherLabel.textColor = UIColor(named: "fontS")
                firstCell.contentView.backgroundColor = UIColor(red: 171/255, green: 211/255, blue: 240/255, alpha: 1)
                firstCell.cityLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.tempLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.highLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.lowLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.weatherLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.weatherImageView.image = UIImage(named: "snow&rain2")
            case "눈":
                firstCell.contentView.backgroundColor = UIColor(red: 171/255, green: 211/255, blue: 240/255, alpha: 1)
                firstCell.cityLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.tempLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.highLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.lowLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.weatherLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                firstCell.weatherImageView.image = UIImage(named: "snow2")
            default:
                firstCell.contentView.backgroundColor = UIColor(named: "Background")
                firstCell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontS" : "cellS")
                firstCell.highLabel.textColor = UIColor(named: "font")
                firstCell.lowLabel.textColor = UIColor(named: "font")
                firstCell.weatherLabel.textColor = UIColor(named: "font")
                firstCell.weatherImageView.image = UIImage(named: "sun2")
            }
            return firstCell
        } else {
            let cell: MyWeatherPageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalCellIdentifier", for: indexPath) as! MyWeatherPageTableViewCell
            cell.selectionStyle = .none
            cell.cityLabel.text = CoreDataManager.addLocationData[indexPath.row].city
            cell.cityDetailLabel.text = "\(CoreDataManager.addLocationData[indexPath.row].town ?? "") \(CoreDataManager.addLocationData[indexPath.row].village ?? "")"
            cell.weatherLabel.text = (DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .SKY, indexPath: indexPath.row) ?? "-")
            
            let tempCelsius = Double(DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .TMP, indexPath: indexPath.row) ?? "0") ?? 0.0
            let highTempCelsius = Double(DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .TMX, indexPath: indexPath.row, currentTime: false, highTemp: true) ?? "0") ?? 0.0
            let lowTempCelsius = Double(DataProcessingManager.shared.getMyWeatherDataValue(dataKey: .TMN, indexPath: indexPath.row, currentTime: false) ?? "0") ?? 0.0
            
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
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "font" : "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
                cell.cellImageView.image = UIImage(named: "sun2")
            case "Mostly Cloudy":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "font" : "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
                cell.cellImageView.image = UIImage(named:"sun&cloud2")
            case "cloudy":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontR" : "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                cell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cityDetailLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                cell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cellImageView.image = UIImage(named:"cloudy2")
            case "cloudy":
                cell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                cell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cityDetailLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                cell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cellImageView.image = UIImage(named:"cloud&sun2")
            case "비":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontR" : "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named: "rain2")
            case "소나기":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundR")
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "fontR" : "cellR")
                cell.highLabel.textColor = UIColor(named: "fontR")
                cell.lowLabel.textColor = UIColor(named: "fontR")
                cell.weatherLabel.textColor = UIColor(named: "fontR")
                cell.cellImageView.image = UIImage(named: "heavyRain2")
            case "비/눈":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "cellS" : "fontS")
                cell.highLabel.textColor = UIColor(named: "fontS")
                cell.lowLabel.textColor = UIColor(named: "fontS")
                cell.weatherLabel.textColor = UIColor(named: "fontS")
                cell.cellImageView.image = UIImage(named: "snow&rain2")
            case "눈":
                cell.contentView.backgroundColor = UIColor(named: "BackGroundS")
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "cellS" : "fontS")
                cell.highLabel.textColor = UIColor(named: "fontS")
                cell.lowLabel.textColor = UIColor(named: "fontS")
                cell.weatherLabel.textColor = UIColor(named: "fontS")
                cell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                cell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cityDetailLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                cell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cellImageView.image = UIImage(named: "rain2")
            case "소나기":
                cell.contentView.backgroundColor = UIColor(red: 122/255, green: 131/255, blue: 135/255, alpha: 1)
                cell.cityLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cityDetailLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.tempLabel.textColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                cell.highLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.lowLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.weatherLabel.textColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
                cell.cellImageView.image = UIImage(named: "heavyRain2")
            case "비/눈":
                cell.contentView.backgroundColor = UIColor(red: 171/255, green: 211/255, blue: 240/255, alpha: 1)
                cell.cityLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.cityDetailLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.tempLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.highLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.lowLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.weatherLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.cellImageView.image = UIImage(named: "snow&rain2")
            case "눈":
                cell.contentView.backgroundColor = UIColor(red: 171/255, green: 211/255, blue: 240/255, alpha: 1)
                cell.cityLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.cityDetailLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.tempLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.highLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.lowLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.weatherLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
                cell.cellImageView.image = UIImage(named: "snow2")
            default:
                cell.contentView.backgroundColor = UIColor(named: "Background")
                cell.tempLabel.textColor = UIColor(named: traitCollection.userInterfaceStyle == .dark ? "font" : "cell")
                cell.highLabel.textColor = UIColor(named: "font")
                cell.lowLabel.textColor = UIColor(named: "font")
                cell.weatherLabel.textColor = UIColor(named: "font")
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
            CoreDataManager.shared.deleteData(withOrder: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        } else {
            MainViewController.isModal2 = true
            let modalVC = MainViewController()
            MainViewController.selectRegion = CombinedData(AreaNo: Int(CoreDataManager.addLocationData[indexPath.row].areaNo),
                                                           Region: CoreDataManager.addLocationData[indexPath.row].region ?? "-",
                                                           City: CoreDataManager.addLocationData[indexPath.row].city ?? "-",
                                                           Town: CoreDataManager.addLocationData[indexPath.row].town ?? "-",
                                                           Village: CoreDataManager.addLocationData[indexPath.row].village ?? "-",
                                                           X: Int(CoreDataManager.addLocationData[indexPath.row].x),
                                                           Y: Int(CoreDataManager.addLocationData[indexPath.row].y),
                                                           Sentence: Int(CoreDataManager.addLocationData[indexPath.row].sentence),
                                                           Status: CoreDataManager.addLocationData[indexPath.row].status ?? "-",
                                                           Temperature: CoreDataManager.addLocationData[indexPath.row].temperature ?? "-")
            modalVC.modalPresentationStyle = .fullScreen
            present(modalVC, animated: true)
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
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // 첫 번째 셀 자리에는 다른 셀이 이동되지 않도록 설정
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath // 0번째 셀은 자리 유지
        }
        // 첫 번째 셀 외의 셀은 이동 허용
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        CoreDataManager.shared.moveLocationData(from: sourceIndexPath.row, to: destinationIndexPath.row)
        
        CoreDataManager.shared.updateCoreDataOrder()
        
    }
    
    @objc func reloadTableData() {
        tableView.reloadData()
    }
    
    
}
