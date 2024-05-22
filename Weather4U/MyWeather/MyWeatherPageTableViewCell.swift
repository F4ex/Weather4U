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
        cityLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 24)
        
        
        cityDetailLabel.textColor = UIColor(named: "font")
        cityDetailLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        
        tempLabel.textColor = UIColor(named: "cell")
        tempLabel.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        
        highLabel.textColor = UIColor(named: "font")
        highLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        lowLabel.textColor = UIColor(named: "font")
        lowLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        weatherLabel.textColor = UIColor(named: "font")
        weatherLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        cellImageView.image = UIImage(named: "sun2")
        cellImageView.contentMode = .scaleAspectFit
        
        [cityLabel, cityDetailLabel, tempLabel, highLabel, lowLabel, weatherLabel, cellImageView].forEach {
            contentView.addSubview($0)
        }
        
        // Auto Layout constraints 설정
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(190)
            make.height.equalTo(29)
        }
        
        cityDetailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(38)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(cellImageView).offset(-20)
            make.width.equalTo(57)
            make.height.equalTo(16)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(57)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(41)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.leading.equalToSuperview().offset(96)
            make.width.equalTo(70)
            make.height.equalTo(16)
        }
        
        highLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(81)
            make.leading.equalToSuperview().offset(96)
            make.width.equalTo(40)
            make.height.equalTo(16)
        }
        
        lowLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(81)
            make.leading.equalToSuperview().inset(140)
            make.width.equalTo(37)
            make.height.equalTo(16)
        }
        
        cellImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(218)
            make.width.equalTo(121)
            make.height.equalTo(111)
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
