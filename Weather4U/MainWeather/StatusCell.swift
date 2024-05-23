//
//  StatusCell.swift
//  Weather4U
//
//  Created by 이시안 on 5/14/24.
//

import Foundation
import UIKit

class StatusCell: UICollectionViewCell {
    static let identifier = "StatusCell"
    
    let background = UIImageView()
    let property = UILabel()
    let icon = UIImageView()
    let num = UILabel()
    var weatherStatus: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        constraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [background, property, icon, num].forEach(){
            addSubview($0)
        }
        property.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        
        num.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        
        background.layer.cornerRadius = 15
    }
    
    // 컨테이너 뷰를 선언, 이유는 statusCell의 property와 icon을 하나로 묶어 가운데 정렬을 하기 위해서
    let containerView = UIView()
    
    func constraintLayout() {
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(27)
        }
        
        background.snp.makeConstraints {
            $0.width.height.equalTo(110)
        }
        
        containerView.addSubview(icon)
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-2)
            $0.left.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        containerView.addSubview(property)
        property.snp.makeConstraints {
            $0.left.equalTo(icon.snp.right).offset(6)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        addSubview(num)
        num.snp.makeConstraints {
            $0.top.equalToSuperview().offset(58)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with viewModel: StatusCellViewModel) {
        property.text = viewModel.propertyName
        icon.image = viewModel.iconImage
        num.text = viewModel.num
    }
    
    func updateAppearanceBasedOnWeather(for weatherStatus: String) {
        var backgroundColor = UIColor()
        var propertyC = UIColor()
        var iconC = UIColor()
        var numC = UIColor()
 
        
        switch weatherStatus {
        case "Sunny", "Cloudy":
            backgroundColor = UIColor(named: "cell")!
            propertyC = UIColor(named: "font")!
            iconC = UIColor(named: "font")!
            numC = UIColor(named: "font")!

        case "Mostly Cloudy", "비", "소나기":
            backgroundColor = UIColor(named: "cellR")!
            propertyC = UIColor(named: "fontR")!
            iconC = UIColor(named: "fontR")!
            numC = UIColor(named: "fontR")!

        case "비/눈", "눈":
            backgroundColor = UIColor(named: "cellS")!
            propertyC = UIColor(named: "fontS")!
            iconC = UIColor(named: "fontS")!
            numC = UIColor(named: "fontS")!

        default:
            backgroundColor = UIColor(named: "cell")!
            propertyC = UIColor(named: "font")!
            iconC = UIColor(named: "font")!
            numC = UIColor(named: "font")!
        }
        if traitCollection.userInterfaceStyle == .dark {
            switch weatherStatus {
            default:
                backgroundColor = UIColor(named: "cell")!
                propertyC = UIColor(named: "font")!
                iconC = UIColor(named: "font")!
                numC = UIColor(named: "font")!
            }
        }
        background.backgroundColor = backgroundColor
        property.textColor = propertyC
        icon.tintColor = iconC
        num.textColor = numC
    }
}

