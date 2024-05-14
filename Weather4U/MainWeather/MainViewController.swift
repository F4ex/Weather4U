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
    let status = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then() {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 110, height: 110)
    }

    let todayWeather = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then() {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 56, height: 110)
    }
    
    let weekWeather = UITableView()
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background") 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == status ? 3 : 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == status {
            guard let cell = status.dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as? StatusCell else {
                return UICollectionViewCell()
            } 
            return cell
        } else if collectionView == todayWeather {
            guard let cell = todayWeather.dequeueReusableCell(withReuseIdentifier: "TodayWeatherCell", for: indexPath) as? TodayWeatherCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekWeather.dequeueReusableCell(withIdentifier: "WeekWeatherCell", for: indexPath) as? WeekWeatherCell else {
            return UITableViewCell()
        }
        return cell
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
            $0.width.equalTo(30)
            $0.height.equalTo(24)
        }
        moveToSearch.snp.makeConstraints(){
            $0.top.equalTo(view).offset(67)
            $0.right.equalTo(view).inset(29)
            $0.width.equalTo(30)
            $0.height.equalTo(24)
        }
        weatherImage.snp.makeConstraints(){
            $0.width.height.equalTo(235)
            $0.top.equalTo(location.snp.bottom).offset(24)
            $0.centerX.centerX.equalTo(view)
        }
        temperature.snp.makeConstraints(){
            $0.top.equalTo(weatherImage.snp.bottom).offset(19)
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
            $0.top.equalTo(tempHigh.snp.bottom).offset(6)
            $0.horizontalEdges.equalTo(view).inset(47)
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
        location.font = defaultFont?.withSize(34)
        location.tintColor = UIColor(named: "font")
        
        moveToDress.setImage(UIImage(systemName: "hanger"), for: .normal)
        moveToDress.tintColor = UIColor(named: "font")
        
        moveToSearch.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        moveToSearch.tintColor = UIColor(named: "font")
        moveToSearch.addTarget(self, action: #selector(clickToSearch), for: .touchUpInside)
        
        weatherImage.image = UIImage(systemName: "sun.max.fill")
        
        
        temperature.font = numFont?.withSize(50)
        temperature.text = "\(30)°"
        temperature.tintColor = UIColor(named: "font")
        
        tempHigh.text = "H: \(01)"
        tempHigh.font = defaultFontB.withSize(15)
        tempHigh.tintColor = UIColor(named: "font")
        
        tempLow.text = "L: \(01)"
        tempLow.font = defaultFontB.withSize(15)
        tempLow.tintColor = UIColor(named: "font")
        
        weatherExplanation.text = "Sunny conditions will continue for the rest of the day.Wind gusts are up to 8 m/s"
        weatherExplanation.textAlignment = .center
        weatherExplanation.numberOfLines = 2
        weatherExplanation.font = defaultFont?.withSize(13)
        weatherExplanation.tintColor = UIColor(named: "font")
        
        status.register(StatusCell.self, forCellWithReuseIdentifier: "StatusCell")
        status.delegate = self
        status.dataSource = self
        status.backgroundColor = view.backgroundColor
        
        todayWeather.register(TodayWeatherCell.self, forCellWithReuseIdentifier: "TodayWeatherCell")
        todayWeather.delegate = self
        todayWeather.dataSource = self
        todayWeather.backgroundColor = UIColor(named: "cell")
        todayWeather.layer.cornerRadius = 15
        
        weekWeather.register(WeekWeatherCell.self, forCellReuseIdentifier: "WeekWeatherCell")
        weekWeather.delegate = self
        weekWeather.dataSource = self
        weekWeather.backgroundColor = UIColor(named: "cell")
        weekWeather.layer.cornerRadius = 15
        
    }
    
    @objc func clickToSearch() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
