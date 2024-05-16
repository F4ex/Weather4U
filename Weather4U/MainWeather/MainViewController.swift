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
    let contentView = UIView()
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
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 2
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
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints(){
            $0.edges.equalTo(view)
        }
        scrollView.addSubview(contentView)
        [location, moveToDress, moveToSearch, weatherImage, temperature, tempHigh, tempLow, weatherExplanation, status, todayWeather, weekWeather].forEach() {
            contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
             $0.width.equalTo(scrollView)
             $0.height.equalTo(1763)
        }
        
        location.snp.makeConstraints(){
            $0.top.equalTo(contentView).offset(29)
            $0.centerX.equalTo(contentView)
        }
        moveToDress.snp.makeConstraints(){
            $0.top.equalTo(contentView).offset(13)
            $0.left.equalTo(contentView).inset(29)
            $0.width.equalTo(30)
            $0.height.equalTo(24)
        }
        moveToSearch.snp.makeConstraints(){
            $0.top.equalTo(contentView).offset(13)
            $0.right.equalTo(contentView).inset(29)
            $0.width.equalTo(30)
            $0.height.equalTo(24)
        }
        weatherImage.snp.makeConstraints(){
            $0.width.height.equalTo(235)
            $0.top.equalTo(location.snp.bottom).offset(24)
            $0.centerX.centerX.equalTo(contentView)
        }
        temperature.snp.makeConstraints(){
            $0.top.equalTo(weatherImage.snp.bottom).offset(19)
            $0.left.equalTo(contentView).offset(164)
        }
        tempHigh.snp.makeConstraints(){
            $0.top.equalTo(temperature.snp.bottom)
            $0.right.equalTo(contentView.snp.centerX).inset(7.5)
        }
        tempLow.snp.makeConstraints(){
            $0.top.equalTo(temperature.snp.bottom)
            $0.left.equalTo(contentView.snp.centerX).offset(7.5)
        }
        weatherExplanation.snp.makeConstraints(){
            $0.top.equalTo(tempHigh.snp.bottom).offset(6)
            $0.horizontalEdges.equalTo(contentView).inset(47)
        }
        status.snp.makeConstraints(){
            $0.top.equalTo(weatherExplanation.snp.bottom).offset(18)
            $0.left.right.equalTo(contentView).inset(16)
            $0.height.equalTo(110)
        }
        todayWeather.snp.makeConstraints(){
            $0.top.equalTo(status.snp.bottom).offset(14)
            $0.left.right.equalTo(contentView).inset(16)
            $0.height.equalTo(164)
        }
        weekWeather.snp.makeConstraints(){
            $0.top.equalTo(todayWeather.snp.bottom).offset(14)
            $0.left.right.equalTo(contentView).inset(16)
            $0.height.equalTo(473)
        }
    }
    
    
    
    
    override func configureUI() {
        location.text = "내 위치"
        location.font = UIFont(name: "Apple SD Gothic Neo", size: 34)
        location.textColor = UIColor(named: "font")
        
        moveToDress.setImage(UIImage(systemName: "hanger"), for: .normal)
        moveToDress.tintColor = UIColor(named: "font")
        
        moveToSearch.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        moveToSearch.tintColor = UIColor(named: "font")
        moveToSearch.addTarget(self, action: #selector(clickToSearch), for: .touchUpInside)
        
        weatherImage.image = UIImage(systemName: "sun.max.fill")
        
        
        temperature.font = UIFont(name: "Alata-Regular", size: 50)
        temperature.text = "\(30)°"
        temperature.textColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1.0)
        temperature.shadowColor = UIColor(red: 81/255, green: 51/255, blue: 0/255, alpha: 0.25)
        temperature.layer.shadowRadius = 2
        temperature.shadowOffset = CGSize(width: 0, height: 4)
        
        
        tempHigh.text = "H: \(01)"
        tempHigh.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        tempHigh.textColor = UIColor(named: "font")
        
        tempLow.text = "L: \(01)"
        tempLow.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        tempLow.textColor = UIColor(named: "font")
        
        weatherExplanation.text = "Sunny conditions will continue for the rest of the day.Wind gusts are up to 8 m/s"
        weatherExplanation.textAlignment = .center
        weatherExplanation.numberOfLines = 2
        weatherExplanation.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        weatherExplanation.textColor = UIColor(named: "font")
        
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
