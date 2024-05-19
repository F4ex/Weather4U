//
//  File.swift
//  Weather4U
//
//  Created by 이시안 on 5/14/24.
//

import SnapKit
import Then
import UIKit

class MainViewController: BaseViewController {
    
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
    
    let todayPrecipitation = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then() {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 360, height: 110)
    }
    
    let weekWeather = UITableView()
    let footerMessage = UILabel()
    let logo = UIImageView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        status.delegate = self
        status.dataSource = self
        todayWeather.delegate = self
        todayWeather.dataSource = self
        weekWeather.delegate = self
        weekWeather.dataSource = self
        todayPrecipitation.delegate = self
        todayPrecipitation.dataSource = self
        
        weekWeather.sectionHeaderTopPadding = 0
        //stickyheader 사용 -> y축의 몇 픽셀에서 멈추는지 정하면 되는것 같다..
        //그렇다면 접히면서 사라리는건?

        NetworkManager.shared.receiveWeatherData()
        NetworkManager.shared.receiveWeatherStatus()
        NetworkManager.shared.receiveWeatherSentence()
        NetworkManager.shared.receiveWeatherTemperature()
        JSONManager.shared.loadJSONToLocationData()
    }
    
    override func constraintLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints(){
            $0.edges.equalTo(view)
        }
        scrollView.addSubview(contentView)
        
        [location, moveToDress, moveToSearch, weatherImage, temperature, tempHigh, tempLow, weatherExplanation, status, todayWeather, weekWeather,todayPrecipitation, footerMessage, logo].forEach() {
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
            $0.top.equalTo(location.snp.bottom).offset(34)
            $0.centerX.equalTo(contentView.snp.centerX).offset(12)
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
            $0.height.equalTo(470)
        }
        
        footerMessage.snp.makeConstraints(){
            $0.bottom.equalTo(logo.snp.top).offset(-9)
            $0.horizontalEdges.equalTo(contentView).inset(102)
        }
        
        logo.snp.makeConstraints(){
            $0.bottom.equalTo(contentView).inset(54)
            $0.width.height.equalTo(43)
            $0.centerX.equalTo(contentView)
        }
        
        todayPrecipitation.snp.makeConstraints() {
            $0.top.equalTo(weekWeather.snp.bottom).offset(14)
            $0.left.right.equalTo(contentView).inset(16)
            $0.height.equalTo(164)
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
        
        weatherImage.image = UIImage(named: "sun3")
        
        
        temperature.font = UIFont(name: "Alata-Regular", size: 50)
        temperature.text = "\(30)°"
        temperature.textColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1.0)
        temperature.shadowColor = UIColor(red: 81/255, green: 51/255, blue: 0/255, alpha: 0.25)
        temperature.layer.shadowRadius = 2
        temperature.shadowOffset = CGSize(width: 0, height: 4)
        
        
        tempHigh.text = "H: \(01)°"
        tempHigh.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        tempHigh.textColor = UIColor(named: "font")
        
        tempLow.text = "L: \(01)°"
        tempLow.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        tempLow.textColor = UIColor(named: "font")
        
        weatherExplanation.text = NetworkManager.weaterSentenceData ?? "Sunny conditions will continue for the rest of the day.Wind gusts are up to 8 m/s"
        weatherExplanation.textAlignment = .center
        weatherExplanation.numberOfLines = 2
        weatherExplanation.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        weatherExplanation.textColor = UIColor(named: "font")
        
        status.register(StatusCell.self, forCellWithReuseIdentifier: "StatusCell")
        status.backgroundColor = view.backgroundColor
        
        todayWeather.register(TodayWeatherCell.self, forCellWithReuseIdentifier: "TodayWeatherCell")
        //헤더뷰 등록하기
        todayWeather.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.identifier)
        todayWeather.backgroundColor = UIColor(named: "cell")
        todayWeather.layer.cornerRadius = 15
        
        todayPrecipitation.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: "ChartCollectionViewCell")
        todayPrecipitation.backgroundColor = UIColor(named: "cell")
        todayPrecipitation.layer.cornerRadius = 15
        
        weekWeather.register(WeekWeatherCell.self, forCellReuseIdentifier: "WeekWeatherCell")
        weekWeather.backgroundColor = UIColor(named: "cell")
        weekWeather.layer.cornerRadius = 15
        
        
        footerMessage.text = "Weather4U will be by your side, cheering you on through your day."
        footerMessage.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        footerMessage.textAlignment = .center
        footerMessage.numberOfLines = 2
        
        logo.backgroundColor = .white
    }
    
    @objc func clickToSearch() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//헤더뷰 정의하기
//헤더에 어떤 내용 넣어줄지 정하기
//헤더뷰 등록은 위쪽 configureUI에 함
class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionViewHeaderView"
    
    private let titleLabel = UILabel()
    private let icon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(icon)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        titleLabel.text = "Hourly Forcast"
        titleLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        titleLabel.textColor = UIColor(named: "font")
        
        icon.image = UIImage(systemName: "clock")
        icon.tintColor = UIColor(named: "font")
        
    }
}

//헤더뷰의 크기 정하기
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 38)
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case status:
            return 3
        case todayWeather:
            return 24
        default :
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == status {
            guard let cell = status.dequeueReusableCell(withReuseIdentifier: StatusCell.identifier, for: indexPath) as? StatusCell else {
                return UICollectionViewCell()
            }
            //뷰모델에 있는 정보들을 가지고 셀을 만들겠다
            let viewModel = cellViewModels[indexPath.item]
            cell.configure(with: viewModel)
            
            return cell
        } else if collectionView == todayWeather {
            guard let cell = todayWeather.dequeueReusableCell(withReuseIdentifier: "TodayWeatherCell", for: indexPath) as? TodayWeatherCell else {
                return UICollectionViewCell()
            }
            return cell
        } else if collectionView == todayPrecipitation {
            guard let cell = todayPrecipitation.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.identifier, for: indexPath) as? ChartCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    //헤더뷰 제공하기
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
        return header
    }
}



extension MainViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekWeather.dequeueReusableCell(withIdentifier: "WeekWeatherCell", for: indexPath) as? WeekWeatherCell else {
            return UITableViewCell()
        }
        return cell
    }
    //셀 높이 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    //테이블뷰 배경색 지정
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(named: "cell")
    }
    //헤더크기 지정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        38
    }
    //뷰델리게이트 안에 헤더뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let weekWeatherH = UIView() //헤더로 사용할 뷰 만들기
        weekWeatherH.backgroundColor = UIColor(named: "cell")
        
        let label = UILabel()
        label.text = "Week Forcast"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        label.textColor = UIColor(named: "font")
        
        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = UIColor(named: "font")
        
        weekWeatherH.addSubview(label)
        weekWeatherH.addSubview(icon)
        
        icon.snp.makeConstraints(){
            $0.centerY.equalTo(weekWeatherH)
            $0.left.equalTo(weekWeatherH).offset(22)
            $0.width.height.equalTo(20)
        }
        
        label.snp.makeConstraints(){
            $0.centerY.equalTo(weekWeatherH)
            $0.left.equalTo(icon.snp.right).offset(6)
        }
        return weekWeatherH
    }
}
