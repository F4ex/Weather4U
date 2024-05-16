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
    
    let property = UILabel()
    let icon = UIImageView()
    let down = UIImageView()
    let up = UIImageView()
    let tempHigh = UILabel()
    let tempLow = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureUI()
//        constraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configureUI() {
//        [property, icon, down, up, tempHigh, tempLow].forEach(){
//            addSubview($0)
//        }
//        property.text = "UV INDEX"
//        property.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
//        property.textColor = UIColor(named: "font")
//        
//        icon.
//        
//        icon.text = "00"
//        num.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
//        
//        num.textColor = UIColor(named: "font")
//        
//        background.backgroundColor = UIColor(named: "cell")
//        background.layer.cornerRadius = 15
//    }
//    
//    func constraintLayout() {
//        
//        background.snp.makeConstraints(){
//            $0.width.height.equalTo(110)
//        }
//        icon.snp.makeConstraints(){
//            $0.top.equalToSuperview().offset(29)
//            $0.width.height.equalTo(20)
//            $0.left.equalToSuperview().offset(10)
//        }
//        property.snp.makeConstraints(){
//            $0.top.equalToSuperview().offset(29)
//            $0.left.equalTo(icon.snp.right).offset(6)
//        }
//        num.snp.makeConstraints(){
//            $0.top.equalToSuperview().offset(58)
//            $0.centerX.equalToSuperview()
        }
    }
}
