//
//  FirstTableViewCell.swift
//  Weather4U
//
//  Created by 강태영 on 5/21/24.
//

import UIKit
import SnapKit
import Kingfisher

class FirstTableViewCell: UITableViewCell {
    let locationLabel = UILabel()
    let cityLabel = UILabel()
    let tempLabel = UILabel()
    let highLabel = UILabel()
    let lowLabel = UILabel()
    let weatherLabel = UILabel()
    let weatherImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor(named: "Background")
        self.contentView.layer.cornerRadius = 20 // 반경을 조정하여 원하는 둥근 정도를 설정할 수 있습니다.
        self.contentView.layer.masksToBounds = true // 셀의 내용이 경계를 벗어날 때 잘라내기 설정
        
        // 폰트 및 색상 설정
        locationLabel.textColor = UIColor(named: "font")
        locationLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 22)
        
        cityLabel.textColor = UIColor(named: "font")
        cityLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        
        tempLabel.textColor = UIColor(named: "cell")
        tempLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 34)
        
        highLabel.textColor = UIColor(named: "font")
        highLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        
        lowLabel.textColor = UIColor(named: "font")
        lowLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        
        weatherLabel.textColor = UIColor(named: "font")
        weatherLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        
        weatherImageView.image = UIImage(named: "sun2")
        weatherImageView.contentMode = .scaleAspectFit
        
        // contentView에 추가
        [locationLabel, cityLabel, tempLabel, highLabel, lowLabel, weatherLabel, weatherImageView].forEach {
            contentView.addSubview($0)
        }
        
        // 오토레이아웃 설정
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(20)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(20)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(63)
            make.leading.equalToSuperview().offset(96)
        }
        
        highLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(96)
        }
        
        lowLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().inset(140)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(22)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // contentView 프레임을 수정하여 패딩 추가
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left:0, bottom: 5, right: 5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
