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
            addSubview($0)
        }
        day.text = "Now"
        day.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        day.textColor = UIColor(named: "font")
        
        drop.image = UIImage(systemName: "drop")
        drop.tintColor = UIColor(named: "font")
        
        pop.text = "00%"
        pop.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        pop.textColor = UIColor(named: "font")
        
        icon.tintColor = UIColor(named: "font")
        
        tempHigh.text = "00°"
        tempHigh.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        tempHigh.textColor = UIColor(named: "font")
        
        tempLow.text = "00°"
        tempLow.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        tempLow.textColor = UIColor(named: "font")
        
    }
    
    func constraintLayout() {
        
        day.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        drop.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.width.equalTo(12) // -> 물방울 수정!!!!!!!!
            $0.height.equalTo(17.25)
            $0.right.equalTo(pop.snp.left).offset(-5)
        }
        
        pop.snp.makeConstraints(){
            $0.top.equalToSuperview().offset(20)
            $0.right.equalTo(icon.snp.left).offset(-24)
        }
        
        icon.snp.makeConstraints(){
            $0.centerY.equalToSuperview()
            $0.height.equalTo(35) //-> 과연 아이콘은 수정됐을까 !!!!!!!!
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
            self.drop.image = UIImage(systemName: "drop_Half")
        case 75...100:
            self.drop.image = UIImage(systemName: "drop.fill")
        default:
            self.drop.image = UIImage(systemName: "drop")
        }
    }
}
