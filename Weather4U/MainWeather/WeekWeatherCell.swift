//
//  tableViewCell.swift
//  Weather4U
//
//  Created by 이시안 on 5/14/24.
//

import Foundation
import UIKit

class WeekWeatherCell: UITableViewCell {
    static let identifier = "WeekWeatherCell"
    
    let day = UILabel()
    let drop = UIImageView()
    let pop = UILabel()
    let icon = UIImageView()
    var tempHigh = UILabel()
    var tempLow = UILabel()
    var weatherStatus: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        constraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [day, drop, pop, icon, tempHigh, tempLow].forEach(){
            contentView.addSubview($0)
        }
        day.text = "Now"
        day.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        
        drop.image = UIImage(systemName: "drop")
        icon.contentMode = .scaleAspectFill //가져온 물방울과 동일하게 사이즈를 맞추려면 영역에 아이콘을 맞추는 방법 사용
        
        pop.text = "00%"
        pop.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        
        icon.contentMode = .scaleAspectFit //기본제공 아이콘 찌그러지지 않게 하려면 비율고정 필요
        
        tempHigh.text = "00°"
        tempHigh.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        
        tempLow.text = "00°"
        tempLow.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        
    }
    
    func constraintLayout() {
        
        day.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        drop.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.width.equalTo(12)
            $0.height.equalTo(17.25)
            $0.centerX.equalToSuperview().offset(-15)
        }
        
        pop.snp.makeConstraints(){
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(drop.snp.right).offset(6)
        }
        
        icon.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(35)
            $0.right.equalTo(tempHigh.snp.left).offset(-24)
        }
        
        tempHigh.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.right.equalTo(tempLow.snp.left).offset(-13)
        }
        
        tempLow.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    func setDay(indexPath: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .day, value: indexPath, to: Date()) {
            let dayString = dateFormatter.string(from: date)
            self.day.text = dayString
        } else {
            self.day.text = "N/A"
        }
    }
    
    func setIcon(status: String) {
        // 날씨 상태에 따른 이미지 변경
        switch status {
        case "Sunny", "맑음":
            self.icon.image = UIImage(systemName: "sun.min")
        case "Mostly Cloudy", "구름많음":
            self.icon.image = UIImage(systemName: "cloud")
        case "Cloudy", "흐림":
            self.icon.image = UIImage(systemName: "cloud.sun")
        case "흐리고 비", "흐리고 소나기", "구름많고 비":
            self.icon.image = UIImage(systemName: "cloud.rain")
        case "구름많고 눈", "흐리고 눈":
            self.icon.image = UIImage(systemName: "cloud.snow")
        case "구름많고 비/눈", "흐리고 비/눈":
            self.icon.image = UIImage(systemName: "cloud.sleet")
        default:
            self.icon.image = UIImage(systemName: "sun.min")
        }
    }
    
    func setDrop(rainPercent: Int) {
        // 강수 확률에 따른 이미지 변경
        switch rainPercent {
        case 0..<25:
            self.drop.image = UIImage(systemName: "drop")
        case 25..<50:
            self.drop.image = UIImage(named: "drop_Little")
        case 50..<75:
            self.drop.image = UIImage(named: "drop_Half")
        case 75...100:
            self.drop.image = UIImage(systemName: "drop.fill")
        default:
            self.drop.image = UIImage(systemName: "drop")
        }
    }
    
    func updateAppearanceBasedOnWeather(for weatherStatus: String) {
        switch weatherStatus {
        case "Sunny", "Cloudy":
            contentView.backgroundColor = UIColor(named: "cell")
            day.textColor = UIColor(named: "font")!
            drop.tintColor = UIColor(named: "font")!
            pop.textColor = UIColor(named: "font")!
            icon.tintColor = UIColor(named: "font")!
            tempHigh.textColor = UIColor(named: "font")!
            tempLow.textColor = UIColor(named: "font")!
        case "Mostly Cloudy", "비", "소나기":
            contentView.backgroundColor = UIColor(named: "cellR")
            day.textColor = UIColor(named: "fontR")!
            drop.tintColor = UIColor(named: "fontR")!
            pop.textColor = UIColor(named: "fontR")!
            icon.tintColor = UIColor(named: "fontR")!
            tempHigh.textColor = UIColor(named: "fontR")!
            tempLow.textColor = UIColor(named: "fontR")!
        case "비/눈", "눈":
            contentView.backgroundColor = UIColor(named: "cellS")
            day.textColor = UIColor(named: "fontS")!
            drop.tintColor = UIColor(named: "fontS")!
            pop.textColor = UIColor(named: "fontS")!
            icon.tintColor = UIColor(named: "fontS")!
            tempHigh.textColor = UIColor(named: "fontS")!
            tempLow.textColor = UIColor(named: "fontS")!
        default:
            contentView.backgroundColor = UIColor(named: "cell")
            day.textColor = UIColor(named: "font")!
            drop.tintColor = UIColor(named: "font")!
            pop.textColor = UIColor(named: "font")!
            icon.tintColor = UIColor(named: "font")!
            tempHigh.textColor = UIColor(named: "font")!
            tempLow.textColor = UIColor(named: "font")!
        }
        if traitCollection.userInterfaceStyle == .dark {
            switch weatherStatus {
            default:
                contentView.backgroundColor = UIColor(named: "cell")
                day.textColor = UIColor(named: "font")!
                drop.tintColor = UIColor(named: "font")!
                pop.textColor = UIColor(named: "font")!
                icon.tintColor = UIColor(named: "font")!
                tempHigh.textColor = UIColor(named: "font")!
                tempLow.textColor = UIColor(named: "font")!
            }
        }
    }
}
