//
//  MyWeatherPageTableViewCell.swift
//  Weather4U
//
//  Created by 강태영 on 5/13/24.
//

import UIKit
import SnapKit

class MyWeatherPageTableViewCell: UITableViewCell {
    
    let cityLabel = UILabel()
    let tempLabel = UILabel()
    let highLabel = UILabel()
    let lowLabel = UILabel()
    let weatherLabel = UILabel()
    let cellImageView = UIImageView() // imageView 이름 변경
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cityLabel.backgroundColor = .red
        tempLabel.backgroundColor = .green
        weatherLabel.backgroundColor = .blue
        cellImageView.backgroundColor = .systemYellow
        highLabel.backgroundColor = .brown
        lowLabel.backgroundColor = .orange
        
        
        addSubview(cityLabel)
        addSubview(tempLabel)
        addSubview(highLabel)
        addSubview(lowLabel)
        addSubview(weatherLabel)
        addSubview(cellImageView)
        
        // Auto Layout constraints 설정
        cityLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(170)
            make.height.equalTo(40)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(190)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(190)
            
        }
        
        highLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(50)
        }
        
        lowLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(250)
            make.leading.equalTo(highLabel.snp.trailing).offset(10)
        }
        
        cellImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(200)
            make.height.equalTo(130) // 이미지 뷰의 높이 설정
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
