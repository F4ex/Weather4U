//
//  FeelsCollectionViewCell.swift
//  Weather4U
//
//  Created by 이시안 on 5/17/24.
//

import UIKit

class FeelsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeelsCollectionViewCell"
    
    let background = UIImageView()
    let property = UILabel()
    let icon = UIImageView()
    let faceIcon = UIImageView()
    let num = UILabel()
    let descriptionLabel = UILabel()
    let gradeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        constraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [background, property, icon, faceIcon, num, descriptionLabel, gradeLabel].forEach(){
            addSubview($0)
        }
        background.backgroundColor = UIColor(named: "cell")
        background.layer.cornerRadius = 15
        
        property.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        property.textColor = UIColor(named: "font")
        
        icon.tintColor = UIColor(named: "font")
        
        faceIcon.tintColor = UIColor(named: "font")
        
        num.text = "00"
        num.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 32)
        num.textColor = UIColor(named: "font")
        num.textAlignment = .center
        
        descriptionLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        descriptionLabel.textColor = UIColor(named: "font")
        descriptionLabel.numberOfLines = 2
        
        gradeLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        gradeLabel.textColor = UIColor(named: "font")
        gradeLabel.textAlignment = .center
        
    }
    
    // 컨테이너 뷰를 선언, 이유는 statusCell의 property와 icon을 하나로 묶어 가운데 정렬을 하기 위해서
    let containerView = UIView()
    
    func constraintLayout() {
        addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        background.snp.makeConstraints {
            $0.width.equalTo(173)
            $0.height.equalTo(129)
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
        
        num.snp.makeConstraints() {
            $0.top.equalToSuperview().offset(39)
            $0.centerX.equalToSuperview().offset(3)
        }
        
        faceIcon.snp.makeConstraints() {
            $0.top.equalToSuperview().offset(39)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints(){
            $0.top.equalTo(num.snp.bottom).offset(7)
            $0.left.right.equalTo(background).inset(17)
        }
        
        gradeLabel.snp.makeConstraints(){
            $0.top.equalTo(faceIcon.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(59)
        }
    }
    
    func configure(with viewModel: FeelsCellViewModel) {
        property.text = viewModel.PropertyName
        icon.image = viewModel.IconImage
        
        // FaceIcon이 nil이 아닐 경우에만 이미지를 설정합니다.
        if let faceIconImage = viewModel.FaceIcon {
            faceIcon.image = faceIconImage
            faceIcon.isHidden = false // 이미지가 있으면 faceIcon을 보여줍니다.
        } else {
            faceIcon.isHidden = true // 이미지가 없으면 faceIcon을 숨깁니다.
        }
        
        num.text = viewModel.Num
        descriptionLabel.text = viewModel.DescriptionLabel
        descriptionLabel.textAlignment = .center
        
        // GradeLabel이 nil이 아닐 경우에만 텍스트를 설정하고 대문자로 변환합니다.
        if let grade = viewModel.GradeLabel {
            gradeLabel.text = grade.uppercased()
            gradeLabel.isHidden = false // 텍스트가 있으면 gradeLabel을 보여줍니다.
        } else {
            gradeLabel.isHidden = true // 텍스트가 없으면 gradeLabel을 숨깁니다.
        }
    }
}

