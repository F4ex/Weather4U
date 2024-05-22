//
//  MyWeatherPageTableViewCell.swift
//  Weather4U
//
//  Created by 강태영 on 5/13/24.
//

import UIKit
import SnapKit
import Kingfisher

class MyWeatherPageTableViewCell: UITableViewCell {
    
    let cityLabel = UILabel()
    let cityDetailLabel = UILabel()
    let tempLabel = UILabel()
    let highLabel = UILabel()
    let lowLabel = UILabel()
    let weatherLabel = UILabel()
    let cellImageView = UIImageView() // imageView 이름 변경
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor(named: "Background")
        self.contentView.layer.cornerRadius = 20 // 반경을 조정하여 원하는 둥근 정도를 설정할 수 있습니다.
        self.contentView.layer.masksToBounds = true // 셀의 내용이 경계를 벗어날 때 잘라내기 설정
        
        // 폰트 및 색상 설정
        cityLabel.textColor = UIColor(named: "font")
        cityLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 22)
        
        cityDetailLabel.textColor = UIColor(named: "font")
        cityDetailLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        
        tempLabel.textColor = UIColor(named: "cell")
        tempLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 34)
        
        highLabel.textColor = UIColor(named: "font")
        highLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        
        lowLabel.textColor = UIColor(named: "font")
        lowLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        
        weatherLabel.textColor = UIColor(named: "font")
        weatherLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        
        cellImageView.image = UIImage(named: "sun2")
        cellImageView.contentMode = .scaleAspectFit
        
        [cityLabel, cityDetailLabel, tempLabel, highLabel, lowLabel, weatherLabel, cellImageView].forEach {
            contentView.addSubview($0)
        }
        
        // 오토레이아웃 설정
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(20)
        }
        
        cityDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(20)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityDetailLabel.snp.bottom).offset(8)
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
        
        cellImageView.snp.makeConstraints { make in
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
