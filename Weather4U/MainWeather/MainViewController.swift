//
//  File.swift
//  Weather4U
//
//  Created by 이시안 on 5/14/24.
//

import Foundation
import UIKit
import SnapKit
import Then

class MainViewController: BaseViewController, UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate,UITableViewDataSource {
   
    let scrollView = UIScrollView()
    let location = UILabel()
    let moveToSearch = UIButton()
    let moveToDress = UIButton()
    let weatherImage = UIImageView()
    let temperature = UILabel()
    let tempHigh = UILabel()
    let tempLow = UILabel()
    let weatherExplanation = UILabel()
    let status = UICollectionView().then {
        let layout = UICollectionViewFlowLayout().then {
            $0.minimumInteritemSpacing = 15
            $0.itemSize = CGSize(width: 110, height: 110)
        }
        $0.collectionViewLayout = layout
    }
    
    let todayWeather = UICollectionView().then(){
        let layout = UICollectionViewFlowLayout().then(){
            $0.minimumInteritemSpacing = 15
            $0.itemSize = CGSize(width: 56, height: 110)
        }
        $0.collectionViewLayout = layout
    }
    
    let weekWeather = UITableView()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background") 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    override func constraintLayout(){
        [scrollView, location, moveToDress, moveToSearch, weatherImage, temperature, tempHigh, tempLow, weatherExplanation, status, todayWeather, weekWeather].forEach(){
            view.addSubview($0)
        }
        scrollView.snp.makeConstraints(){
            $0.top.equalTo(view).offset(54)
            $0.horizontalEdges.equalTo(view)
            $0.height.equalTo(1704)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints(){
            $0.top.equalTo(view).offset(54)
            $0.horizontalEdges.equalTo(view)
            $0.height.equalTo(1531)
        }
        location.snp.makeConstraints(){
            $0.top.equalTo(view).offset(83)
            $0.centerX.equalTo(view)
        }
        moveToDress.snp.makeConstraints(){
            $0.top.equalTo(view).offset(67)
            $0.left.equalTo(view).inset(29)
            $0.width.equalTo(22)
            $0.height.equalTo(16)
        }
        moveToSearch.snp.makeConstraints(){
            $0.top.equalTo(view).offset(67)
            $0.right.equalTo(view).inset(29)
            $0.width.equalTo(20)
            $0.height.equalTo(16)
        }
        weatherImage.snp.makeConstraints(){
            $0.width.height.equalTo(235)
            $0.top.equalTo(location.snp.bottom).offset(24)
            $0.centerX.centerX.equalTo(view)
        }
        temperature.snp.makeConstraints(){
            $0.top.equalTo(weatherImage.snp.bottom).offset(1)
            $0.left.equalTo(view).offset(164)
        }
        tempHigh.snp.makeConstraints(){
            $0.top.equalTo(temperature.snp.bottom)
            $0.right.equalTo(view.snp.centerX).inset(7.5)
        }
        tempLow.snp.makeConstraints(){
            $0.top.equalTo(temperature.snp.bottom)
            $0.left.equalTo(view.snp.centerX).offset(7.5)
        }
        weatherExplanation.snp.makeConstraints(){
            $0.top.equalTo(tempHigh).offset(3)
            $0.centerX.equalTo(view)
        }
        status.snp.makeConstraints(){
            $0.top.equalTo(weatherExplanation.snp.bottom).offset(18)
            $0.left.right.equalTo(view).inset(16)
            $0.height.equalTo(110)
        }
        todayWeather.snp.makeConstraints(){
            $0.top.equalTo(status.snp.bottom).offset(14)
            $0.left.right.equalTo(view).inset(16)
            $0.height.equalTo(164)
        }
        weekWeather.snp.makeConstraints(){
            $0.top.equalTo(todayWeather.snp.bottom).offset(14)
            $0.left.right.equalTo(view).inset(16)
            $0.height.equalTo(473)
        }
    }
    
    override func configureUI() {
        location.text = "내 위치"
        location.font = UIFont(name: "a", size: <#T##CGFloat#>)
    }
}
