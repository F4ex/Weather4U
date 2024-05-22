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
        time.textColor = UIColor(named: "font")
        
        temperature.text = "-°"
        temperature.font = UIFont(name: "Apple SD Gothic Neo", size: 20)
        temperature.textColor = UIColor(named: "font")
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
}
