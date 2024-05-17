//
//  MyWeatherPageTableViewCell.swift
//  Weather4U
//
//  Created by 강태영 on 5/13/24.
//

import UIKit
import SnapKit
import SwiftUI
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
        self.backgroundColor = UIColor(named: "cell")
        contentView.backgroundColor = UIColor(named: "Background")
        
        self.contentView.layer.cornerRadius = 20 // 반경을 조정하여 원하는 둥근 정도를 설정할 수 있습니다.
        self.contentView.layer.masksToBounds = true // 셀의 내용이 경계를 벗어날 때 잘라내기 설정
        
        
        cityLabel.textColor = .black
        tempLabel.textColor = .black
        weatherLabel.textColor = .black
        cellImageView.backgroundColor = .white
        highLabel.textColor = .black
        lowLabel.textColor = .black
        
        
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
            make.height.equalTo(40)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(190)
            make.bottom.equalToSuperview().inset(10)
            
        }
        
        highLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.leading.equalToSuperview().inset(55)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(lowLabel.snp.width)
        }
        
        lowLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(200)
            make.leading.equalTo(highLabel.snp.trailing).offset(5)
        }
        
        cellImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
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

struct MyWeatherPageViewControllerRepresentable: UIViewControllerRepresentable {
typealias UIViewControllerType = MyWeatherPageViewController

func makeUIViewController(context: Context) -> MyWeatherPageViewController {
    return MyWeatherPageViewController()
}

func updateUIViewController(_ uiViewController: MyWeatherPageViewController, context: Context) {
    // 필요한 경우 UIViewController를 업데이트하는 코드를 여기에 추가
}
}

@available(iOS 13.0, *)
struct MyWeatherPageViewControllerPreview: PreviewProvider {
static var previews: some View {
    MyWeatherPageViewControllerRepresentable()
}
}
