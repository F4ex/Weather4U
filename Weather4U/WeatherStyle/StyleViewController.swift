//
//  StyleViewController.swift
//  Weather4U
//
//  Created by 이시안 on 5/19/24.
//

import UIKit
import SnapKit

class StyleViewController: BaseViewController, DataReloadDelegate {
    
    let logo = UILabel()
    let styleTitle = UILabel()
    let styleImage = UIImageView()
    let styleDetail = UILabel()
    let temperature = UILabel()
    var weatherData: [WeatherData] = []
    var temperatureNow: String = ""
    var weatherStatus: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        constraintLayout()
        configureUI()
        NetworkManager.shared.delegate = self
        DataProcessingManager.shared.delegate = self
        updateAppearanceBasedOnWeather(for: weatherStatus)
        updateTextBasedOnTemperature(for: temperatureNow)
    }
    
    override func constraintLayout() {
        [logo, styleTitle, styleImage, styleDetail, temperature].forEach(){
            view.addSubview($0)
        }
        logo.snp.makeConstraints(){
            $0.top.equalTo(view).offset(30)
            $0.centerX.equalTo(view)
        }
        styleTitle.snp.makeConstraints(){
            $0.top.equalTo(logo.snp.bottom).offset(40)
            $0.centerX.equalTo(view)
        }
        styleImage.snp.makeConstraints(){
            $0.top.equalTo(styleTitle.snp.bottom).offset(25)
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(297)
        }
        styleDetail.snp.makeConstraints(){
            $0.top.equalTo(styleImage.snp.bottom).offset(33)
            $0.centerX.equalTo(view)
            $0.left.right.equalTo(view).inset(30)
        }
        temperature.snp.makeConstraints(){
            $0.top.equalTo(styleImage.snp.bottom).offset(76)
            $0.centerX.equalTo(view)
        }
    }
    
    
    //MARK: - 날씨별 배경 및 메인아이콘 변경
    func updateAppearanceBasedOnWeather(for weatherStatus: String) {
        var backgroundColor = UIColor()
        var logoColor = UIColor()
        var styleTitleColor = UIColor()
        var image = UIImage()
        var styleDetailColor = UIColor()
        var temperatureColor = UIColor()
        
        switch weatherStatus {
        case "Sunny", "Mostly Cloudy":
            backgroundColor = UIColor(named: "Background")!
            logoColor = UIColor(named: "font")!
            styleDetailColor = UIColor(named: "font")!
            styleTitleColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
            temperatureColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 0.3)
        case "Cloudy", "비", "소나기":
            backgroundColor = UIColor(named: "BackGroundR")!
            logoColor = UIColor(named: "fontR")!
            styleDetailColor = UIColor(named: "fontR")!
            styleTitleColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
            temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 0.3)
        case "비/눈", "눈":
            backgroundColor = UIColor(named: "BackGroundS")!
            logoColor = UIColor(named: "fontS")!
            styleDetailColor = UIColor(named: "fontS")!
            styleTitleColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
            temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 0.3)
        default:
            backgroundColor = UIColor(named: "Background")!
            logoColor = UIColor(named: "font")!
            image = UIImage(named: "day")!
            styleDetailColor = UIColor(named: "font")!
            styleTitleColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
            temperatureColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 0.3)
        }
        if traitCollection.userInterfaceStyle == .dark {
            switch weatherStatus {
            default:
                backgroundColor = UIColor(named: "Background")!
                logoColor = UIColor(named: "font")!
                image = UIImage(named: "night")!
                styleDetailColor = UIColor(named: "font")!
                styleTitleColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 1)
                temperatureColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 0.3)
            }
        }
        view.backgroundColor = backgroundColor
        logo.textColor = logoColor
        styleTitle.textColor = styleTitleColor
        styleImage.image = image
        styleDetail.textColor = styleDetailColor
        temperature.textColor = temperatureColor
    }
    
    
    func updateTextBasedOnTemperature(for temperatureNow: String) {
        var styleDetailText = String()
        // 정해진 숫자 영역에 따라 다른 문장 내보내기
        if let temperature = Int(temperatureNow) {
            switch temperature {
            case ..<5:
                styleDetailText = "It is very cold weather. \nThick padding, A heavy down jacket, A hat, Gloves. You should minimize heat loss as much as possible."
            case 5..<10:
                styleDetailText = "It's cold weather. \nThick coats or Padded jackets. * Keep your body temperature maintained."
            case 10..<15:
                styleDetailText = "It's chilly weather. \nthick jackets, knits, and scarves."
            case 15..<20:
                styleDetailText = "It's a bit chilly. \nLight jacket, Sweater, Jeans, or Cotton pants."
            case 20..<23:
                styleDetailText = "It's cool weather. \nLong-sleeve t-shirts, Thin knits, Cotton pants, Long skirts. In the morning and evening, you may need a light jacket."
            case 23..<28:
                styleDetailText = "It's warm or slightly hot. \nShorts, Skirts, Thin shirts or short-sleeved T-shirts."
            case 28...:
                styleDetailText = "It's very hot weather.  \nShorts, Short-sleeved T-shirts, Thin dresses. Apply sunscreen for UV protection."
            default:
                styleDetailText = "We don't have temperature data"
            }
            styleDetail.text = styleDetailText
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // 인터페이스 스타일이 변경될 때마다 UI 업데이트
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearanceBasedOnWeather(for: weatherStatus)
        }
    }
    
    override func configureUI() {
        logo.text = "Weather4U"
        logo.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        logo.textAlignment = .center
        
        styleTitle.text = "Style Today"
        styleTitle.font = UIFont(name: "Alata-Regular", size: 33)
        styleTitle.textAlignment = .center
        
        styleDetail.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
        styleDetail.textAlignment = .center
        styleDetail.numberOfLines = 0
        
        temperature.font = UIFont(name: "BarlowSemiCondensed-Regular", size: 270)
        temperature.textAlignment = .center
        temperature.text = "\(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "-")"
        temperatureNow = self.temperature.text ?? "" //temperatureNow는 temperature.text에 받아오는 값으로 해주겠다
        updateTextBasedOnTemperature(for: self.temperatureNow) //온도별 조건문 self.temperatureNow 의 정보 사용하겠다
    }
    
    func dataReload() {
        DispatchQueue.main.async {
            self.temperature.text = "\(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "-")"
            self.temperatureNow = self.temperature.text ?? "" //temperatureNow는 temperature.text에 받아오는 값으로 해주겠다
            self.updateTextBasedOnTemperature(for: self.temperatureNow) //온도별 조건문 self.temperatureNow 의 정보 사용하겠다
        }
    }
}
