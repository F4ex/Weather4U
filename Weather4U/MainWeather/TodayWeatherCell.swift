//
//  TodayWeatherCell.swift
//  Weather4U
//
//  Created by 이시안 on 5/14/24.
//

import Foundation
import UIKit

class TodayWeatherCell: UICollectionViewCell {
    static let identifier = "TodayWeatherCell"
    
    let time = UILabel()
    let icon = UIImageView()
    let temperature = UILabel()
    var weatherStatus = ""
    var weatherType = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        constraintLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [time, icon, temperature].forEach(){
            addSubview($0)
        }
        time.text = "시간"
        time.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        time.textColor = setFontColor()
        
        icon.tintColor = setFontColor()
        icon.contentMode = .scaleAspectFit
        
        temperature.text = "-°"
        temperature.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        temperature.textColor = setFontColor()
    }
    
    func constraintLayout() {
        time.snp.makeConstraints(){
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        }
        icon.snp.makeConstraints(){
            $0.top.equalTo(time.snp.bottom).offset(7)
            $0.width.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        temperature.snp.makeConstraints(){
            $0.top.equalTo(icon.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setIcon(status: String) {
        // 날씨 상태에 따른 이미지 변경
        switch status {
        case "Sunny":
            self.icon.image = UIImage(systemName: "sun.min")
        case "Mostly Cloudy":
            self.icon.image = UIImage(systemName: "cloud.rain")
        case "Cloudy":
            self.icon.image = UIImage(systemName: "cloud")
        default:
            self.icon.image = UIImage(systemName: "sun.min")
        }
    }
    
    func setFontColor() -> UIColor {
        switch self.weatherStatus {
        case "Sunny":
            return UIColor(named: "font")!
        case "Mostly Cloudy":
            switch self.weatherType {
            case "비", "소나기":
                return UIColor(named: "fontR")!
            case "눈", "비/눈":
                return UIColor(named: "fontS")!
            default:
                return UIColor(named: "fontR")!
            }
        default:
            return UIColor(named: "font")!
        }
    }
    
    func setCellColor() -> UIColor {
        switch self.weatherStatus {
        case "Sunny":
            return UIColor(named: "cell")!
        case "Mostly Cloudy":
            switch self.weatherType {
            case "비", "소나기":
                return UIColor(named: "cellR")!
            case "눈", "비/눈":
                return UIColor(named: "cellS")!
            default:
                return UIColor(named: "cellR")!
            }
        default:
            return UIColor(named: "cell")!
        }
    }
}
