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
    let tempLabel = UILabel()
    let highLabel = UILabel()
    let lowLabel = UILabel()
    let weatherLabel = UILabel()
    let cellImageView = UIImageView() // imageView 이름 변경
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        
        self.contentView.layer.cornerRadius = 20 // 반경을 조정하여 원하는 둥근 정도를 설정할 수 있습니다.
        self.contentView.layer.masksToBounds = true // 셀의 내용이 경계를 벗어날 때 잘라내기 설정
        
        // 폰트 및 색상 설정
                cityLabel.textColor = .black

                cityLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
                
                tempLabel.textColor = .black
                tempLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
                
                highLabel.textColor = .black
                highLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                
                lowLabel.textColor = .black
                lowLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                
                weatherLabel.textColor = .black
                weatherLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                
                cellImageView.backgroundColor = .white
                
                [cityLabel, tempLabel, highLabel, lowLabel, weatherLabel, cellImageView].forEach {
                    contentView.addSubview($0)
                }
        
        
        [cityLabel, tempLabel, highLabel, lowLabel, weatherLabel, cellImageView].forEach {
            contentView.addSubview($0)
        }
        
        
        // Auto Layout constraints 설정
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(170)
            make.height.equalTo(55)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(190)
            make.height.equalTo(30)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(190)
            make.bottom.equalToSuperview().inset(10)
        }
        
        highLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.leading.equalTo(weatherLabel.snp.trailing).offset(15)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(lowLabel.snp.width)
        }
        
        lowLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(180)
            make.leading.equalTo(highLabel.snp.trailing).offset(5)
        }
        
        cellImageView.contentMode = .scaleAspectFit
        
        cellImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(200)
            make.height.equalTo(130) // 이미지 뷰의 높이 설정
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
