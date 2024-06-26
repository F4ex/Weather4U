//
//  File.swift
//  Weather4U
//
//  Created by 이시안 on 5/14/24.
//
import CoreData
import SnapKit
import Then
import UIKit

class MainViewController: BaseViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    static var isModal = false
    static var isModal2 = false
    static var selectRegion : CombinedData? // 배열이 아닌 값 하나
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let location = UILabel()
    let locationDetail = UILabel()
    let moveToSearch = UIButton()
    let moveToDress = UIButton()
    let imageView = UIView().then(){
        $0.frame.size = CGSize(width: 393, height: 259)
    }
    var weatherImage = UIImageView()
    let temperature = UILabel()
    let tempHigh = UILabel()
    let tempLow = UILabel()
    let weatherExplanation = UILabel()
    let status = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then() {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 110, height: 110)
    }
    //UICollectionViewFlowLayout은 기본적으로 컬렉션뷰와 셀 간 센터x,센터y에 맞추도록 설정되어 있어서 여기를 커스텀 플로우레이아웃으로 설정 = 527번째 줄
    let todayWeather = UICollectionView(frame: .zero, collectionViewLayout: CustomFlowLayout()).then() {
        let layout = $0.collectionViewLayout as! CustomFlowLayout
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
    let weekWeatherH = UIView() //헤더로 사용할 뷰 만들기
    let feels = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then() {
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 173, height: 129)
    }
    let footerMessage = UILabel()
    let logo = UIImageView()
    var city: City = .서울특별시 //City의 디폴트 값인 서울로 현재의 위치를 표시하겠다
    var weatherData: [WeatherData] = []
    var weatherStatus: String = "Sunny"
    var weatherType: String = "없음"
    
    //그라데이션 레이어와 마스크 해줄 레이어 만들기
    let maskedUpView = UIView(frame: CGRect(x: 0, y: 782, width: 393, height: 70))
    let maskedDownView = UIView(frame: CGRect(x: 0, y: 123, width: 393, height: 67))
    let gradientUp = CAGradientLayer()
    let gradientDown = CAGradientLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        updateAppearanceBasedOnWeather(for: weatherStatus)
        
        status.delegate = self
        status.dataSource = self
        todayWeather.delegate = self
        todayWeather.dataSource = self
        weekWeather.delegate = self
        weekWeather.dataSource = self
        todayPrecipitation.delegate = self
        todayPrecipitation.dataSource = self
        feels.delegate = self
        feels.dataSource = self
        NetworkManager.shared.delegate = self
        NetworkManager.shared.alertDelegate = self
        DataProcessingManager.shared.delegate = self
        
        if MainViewController.selectRegion == nil {
            CoreDataManager.shared.readFirstData()
        }
        
        
        weekWeather.sectionHeaderTopPadding = 0
        
        maskedUpView.backgroundColor = view.backgroundColor //마스킹 컬러는 백그라운드 컬러로
        gradientUp.frame = maskedUpView.bounds
        gradientUp.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor] // 그라디언트 색상 정하기
        gradientUp.locations = [0, 0.2, 0.9, 1] //그라디언트 색상 넣을 영역 정하기
        //전체 화면을 1이라 생각했을때 0%에 clear, 20%엔 white, 90%, 100%에도 화이트 넣기
        maskedUpView.layer.mask = gradientUp // 그라데이션한 레이어를 화면에 마스킹하기
        view.addSubview(maskedUpView)
        
        maskedDownView.backgroundColor = view.backgroundColor //마스킹 컬러는 백그라운드 컬러로
        gradientDown.frame = maskedDownView.bounds
        gradientDown.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientDown.locations = [0, 0.4, 0.9, 1]
        maskedDownView.layer.mask = gradientDown
        view.addSubview(maskedDownView)
        
        self.networkDataManager()
        
        if MainViewController.isModal == true {
            moveToSearch.isHidden = true
            moveToDress.isHidden = true
            
            gradientDown.colors = [UIColor.clear.cgColor]
            
            setModalPage()
        }
        
        if MainViewController.isModal2 == true {
            moveToSearch.isHidden = true
            moveToDress.isHidden = false
            
            gradientDown.colors = [UIColor.clear.cgColor]
            
            setModalPage2()
            
        }
        
        setupHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - 네트워크 & 데이터 매니저
    func networkDataManager() {
        guard let unwrapArray = MainViewController.selectRegion else { return }
        NetworkManager.shared.fetchAllWeatherData(x: Int16(unwrapArray.X), y: Int16(unwrapArray.Y), status: unwrapArray.Status, temperature: unwrapArray.Temperature, areaNo: Int64(unwrapArray.AreaNo))
        JSONManager.shared.loadJSONToLocationData()
        CoreDataManager.shared.readData()
        CoreDataManager.shared.updateCoreDataOrder()
    }
    
    //MARK: - 오토레이아웃
    override func constraintLayout() {
        [location, locationDetail, moveToDress, moveToSearch, scrollView].forEach() {
            view.addSubview($0)
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
        location.snp.makeConstraints(){
            $0.top.equalTo(view).offset(82)
            $0.centerX.equalTo(view)
        }
        locationDetail.snp.makeConstraints(){
            $0.top.equalTo(location.snp.bottom).offset(5)
            $0.centerX.equalTo(view)
        }
        scrollView.snp.makeConstraints(){
            $0.top.equalTo(view).offset(146)
            $0.left.right.bottom.equalTo(view)
        }
        
        scrollView.addSubview(contentView)
        
        [imageView, weatherImage, temperature, tempHigh, tempLow, weatherExplanation, status, todayWeather, weekWeather,todayPrecipitation, feels, footerMessage, logo].forEach() {
            contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(1680)
        }
        
        imageView.snp.makeConstraints(){
            $0.top.equalTo(contentView)
            $0.height.equalTo(200)
        }
        weatherImage.snp.makeConstraints(){
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.centerY.equalTo(imageView).offset(53)
        }
        temperature.snp.makeConstraints(){
            $0.top.equalTo(contentView).offset(300)
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
            $0.left.right.equalTo(contentView).inset(20)
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
        todayPrecipitation.snp.makeConstraints() {
            $0.top.equalTo(weekWeather.snp.bottom).offset(14)
            $0.left.right.equalTo(contentView).inset(16)
            $0.height.equalTo(164)
        }
        feels.snp.makeConstraints(){
            $0.top.equalTo(todayPrecipitation.snp.bottom).offset(14)
            $0.left.right.equalTo(contentView).inset(16)
            $0.height.equalTo(129)
        }
        logo.snp.makeConstraints(){
            $0.bottom.equalTo(footerMessage.snp.top).offset(-15)
            $0.width.height.equalTo(60)
            $0.centerX.equalTo(contentView)
        }
        footerMessage.snp.makeConstraints(){
            $0.bottom.equalTo(contentView).offset(-10)
            $0.horizontalEdges.equalTo(contentView).inset(102)
        }
    }
    
    
    //MARK: - UI 디테일
    override func configureUI() {
        
        location.text = city.rawValue
        location.font = UIFont(name: "Apple SD Gothic Neo", size: 30)
        location.textAlignment = .center
        
        locationDetail.text = ""
        locationDetail.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        locationDetail.textAlignment = .center
        
        
        moveToDress.setImage(UIImage(systemName: "hanger"), for: .normal)
        moveToDress.addTarget(self, action: #selector(clickToStyle), for: .touchUpInside)
        
        moveToSearch.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        moveToSearch.addTarget(self, action: #selector(clickToSearch), for: .touchUpInside)
        
        temperature.font = UIFont(name: "Alata-Regular", size: 50)
        temperature.layer.shadowRadius = 2
        temperature.shadowOffset = CGSize(width: 0, height: 4)
        
        tempHigh.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        
        tempLow.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        
        weatherExplanation.textAlignment = .center
        weatherExplanation.numberOfLines = 2
        weatherExplanation.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        
        status.register(StatusCell.self, forCellWithReuseIdentifier: "StatusCell")
        status.backgroundColor = .clear
        
        todayWeather.register(TodayWeatherCell.self, forCellWithReuseIdentifier: "TodayWeatherCell")
        todayWeather.layer.cornerRadius = 15
        
        todayPrecipitation.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: "ChartCollectionViewCell")
        todayPrecipitation.layer.cornerRadius = 15
        
        weekWeather.register(WeekWeatherCell.self, forCellReuseIdentifier: "WeekWeatherCell")
        weekWeather.layer.cornerRadius = 15
        
        footerMessage.text = "Weather4U will be by your side, cheering you on through your day."
        footerMessage.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        footerMessage.textAlignment = .center
        footerMessage.numberOfLines = 2
        
        logo.image = UIImage(named: "weather4U")
        
        feels.register(FeelsCollectionViewCell.self, forCellWithReuseIdentifier: "FeelsCollectionViewCell")
        feels.backgroundColor = .clear
    }
    
    
    //MARK: - 날씨별 배경 및 메인아이콘 변경
    func updateAppearanceBasedOnWeather(for weatherStatus: String) {
        var Icon = UIImage()
        var backgroundColor = UIColor()
        var temperatureColor = UIColor()
        var locationC = UIColor()
        var locationDetailC = UIColor()
        var moveToDressC = UIColor()
        var moveToSearchC = UIColor()
        var tempHighC = UIColor()
        var tempLowC = UIColor()
        var statusC = UIColor()
        var weatherExplanationC = UIColor()
        var weatherExplanationText = String()
        var todayWeatherC = UIColor()
        var todayPrecipitationC = UIColor()
        var weekWeatherC = UIColor()
        var weekHeaderC = UIColor()
        
        
        switch weatherStatus {
        case "Sunny", "Cloudy":
            Icon = (weatherStatus == "Sunny" ? UIImage(named: "sun") : UIImage(named: "sun&cloud"))!
            backgroundColor = UIColor(named: "Background")!
            temperatureColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
            locationC = UIColor(named: "font")!
            locationDetailC = UIColor(named: "font")!
            moveToDressC = UIColor(named: "font")!
            moveToSearchC = UIColor(named: "font")!
            tempHighC = UIColor(named: "font")!
            tempLowC = UIColor(named: "font")!
            statusC = UIColor(named: "cell")!
            weatherExplanationC = UIColor(named: "font")!
            weatherExplanationText = (weatherStatus == "Sunny" ? "It's a beautiful sunny day, perfect for a walk." : "The sky is moderately cloudy, providing a nice shade.")
            todayWeatherC = UIColor(named: "cell")!
            todayPrecipitationC = UIColor(named: "cell")!
            weekWeatherC = UIColor(named: "cell")!
            weekHeaderC = UIColor(named: "cell")!
        case "Mostly Cloudy":
            switch weatherType {
            case "비", "소나기":
                Icon = (weatherStatus == "비" ? UIImage(named: "rain") : UIImage(named: "heavyRain"))!
                backgroundColor = UIColor(named: "BackGroundR")!
                temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                locationC = UIColor(named: "fontR")!
                locationDetailC = UIColor(named: "fontR")!
                moveToDressC = UIColor(named: "fontR")!
                moveToSearchC = UIColor(named: "fontR")!
                tempHighC = UIColor(named: "fontR")!
                tempLowC = UIColor(named: "fontR")!
                statusC = UIColor(named: "cellR")!
                weatherExplanationC = UIColor(named: "fontR")!
                weatherExplanationText = (weatherStatus == "비" ? "Rain is pouring down today. Remember to take your umbrella." : "Watch out for sudden showers. Keeping an umbrella handy is a smart choice!")
                todayWeatherC = UIColor(named: "cellR")!
                todayPrecipitationC = UIColor(named: "cellR")!
                weekWeatherC = UIColor(named: "cellR")!
                weekHeaderC = UIColor(named: "cellR")!
            case "비/눈", "눈":
                Icon = (weatherStatus == "비/눈" ? UIImage(named: "snow&rain") : UIImage(named: "snow"))!
                backgroundColor = UIColor(named: "BackGroundS")!
                temperatureColor = weatherStatus == "눈" ? UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1) : UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                locationC = UIColor(named: "fontS")!
                locationDetailC = UIColor(named: "fontS")!
                moveToDressC = UIColor(named: "fontS")!
                moveToSearchC = UIColor(named: "fontS")!
                tempHighC = UIColor(named: "fontS")!
                tempLowC = UIColor(named: "fontS")!
                statusC = UIColor(named: "cellS")!
                weatherExplanationC = UIColor(named: "fontS")!
                weatherExplanationText = (weatherStatus == "비/눈" ? "Today's weather is a mix of rain and snow. Take extra caution on slippery roads" : "A snowy blanket covers the ground today. Bundle up warmly and revel in the winter magic.")
                todayWeatherC = UIColor(named: "cellS")!
                todayPrecipitationC = UIColor(named: "cellS")!
                weekWeatherC = UIColor(named: "cellS")!
                weekHeaderC = UIColor(named: "cellS")!
            default:
                Icon = UIImage(named: "cloudy")!
                backgroundColor = UIColor(named: "BackGroundR")!
                temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
                locationC = UIColor(named: "fontR")!
                locationDetailC = UIColor(named: "fontR")!
                moveToDressC = UIColor(named: "fontR")!
                moveToSearchC = UIColor(named: "fontR")!
                tempHighC = UIColor(named: "fontR")!
                tempLowC = UIColor(named: "fontR")!
                statusC = UIColor(named: "cellR")!
                weatherExplanationC = UIColor(named: "fontR")!
                weatherExplanationText = "It's a gloomy day outside, a perfect time for a warm cup of tea and some cozy indoor activities."
                todayWeatherC = UIColor(named: "cellR")!
                todayPrecipitationC = UIColor(named: "cellR")!
                weekWeatherC = UIColor(named: "cellR")!
                weekHeaderC = UIColor(named: "cellR")!
            }
        default:
            Icon = UIImage(named: "sun")!
            backgroundColor = UIColor(named: "Background")!
            temperatureColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
            locationC = UIColor(named: "font")!
            locationDetailC = UIColor(named: "font")!
            moveToDressC = UIColor(named: "font")!
            moveToSearchC = UIColor(named: "font")!
            tempHighC = UIColor(named: "font")!
            tempLowC = UIColor(named: "font")!
            statusC = UIColor(named: "cell")!
            weatherExplanationC = UIColor(named: "font")!
            weatherExplanationText = "It's a beautiful sunny day, perfect for a walk."
            todayWeatherC = UIColor(named: "cell")!
            todayPrecipitationC = UIColor(named: "cell")!
            weekWeatherC = UIColor(named: "cell")!
            weekHeaderC = UIColor(named: "cell")!
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            switch weatherStatus {
            case "Cloudy", "Mostly Cloudy":
                switch weatherType {
                case "비", "소나기":
                    Icon = (weatherStatus == "비" ? UIImage(named: "rain") : UIImage(named: "heavyRain"))!
                    backgroundColor = UIColor(named: "Background")!
                    temperatureColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 1)
                    locationC = UIColor(named: "font")!
                    locationDetailC = UIColor(named: "font")!
                    moveToDressC = UIColor(named: "font")!
                    moveToSearchC = UIColor(named: "font")!
                    tempHighC = UIColor(named: "font")!
                    tempLowC = UIColor(named: "font")!
                    statusC = UIColor(named: "cell")!
                    weatherExplanationC = UIColor(named: "font")!
                    weatherExplanationText = (weatherStatus == "비" ? "Rain is pouring down today. Remember to take your umbrella." : "Watch out for sudden showers. Keeping an umbrella handy is a smart choice!")
                    todayWeatherC = UIColor(named: "cell")!
                    todayPrecipitationC = UIColor(named: "cell")!
                    weekWeatherC = UIColor(named: "cell")!
                    weekHeaderC = UIColor(named: "cell")!
                case "비/눈", "눈":
                    Icon = (weatherStatus == "비/눈" ? UIImage(named: "snow&rain") : UIImage(named: "snow"))!
                    backgroundColor = UIColor(named: "Background")!
                    temperatureColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 1)
                    locationC = UIColor(named: "font")!
                    locationDetailC = UIColor(named: "font")!
                    moveToDressC = UIColor(named: "font")!
                    moveToSearchC = UIColor(named: "font")!
                    tempHighC = UIColor(named: "font")!
                    tempLowC = UIColor(named: "font")!
                    statusC = UIColor(named: "cell")!
                    weatherExplanationC = UIColor(named: "font")!
                    weatherExplanationText = (weatherStatus == "비/눈" ? "Today's weather is a mix of rain and snow. Take extra caution on slippery roads" : "A snowy blanket covers the ground today. Bundle up warmly and revel in the winter magic.")
                    todayWeatherC = UIColor(named: "cell")!
                    todayPrecipitationC = UIColor(named: "cell")!
                    weekWeatherC = UIColor(named: "cell")!
                    weekHeaderC = UIColor(named: "cell")!
                default:
                    Icon = UIImage(named: "moon&cloud")!
                    backgroundColor = UIColor(named: "Background")!
                    temperatureColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 1)
                    locationC = UIColor(named: "font")!
                    locationDetailC = UIColor(named: "font")!
                    moveToDressC = UIColor(named: "font")!
                    moveToSearchC = UIColor(named: "font")!
                    tempHighC = UIColor(named: "font")!
                    tempLowC = UIColor(named: "font")!
                    statusC = UIColor(named: "cell")!
                    weatherExplanationC = UIColor(named: "font")!
                    weatherExplanationText = "Despite the cloudy night, let the light within your heart guide you through darkness."
                    todayWeatherC = UIColor(named: "cell")!
                    todayPrecipitationC = UIColor(named: "cell")!
                    weekWeatherC = UIColor(named: "cell")!
                    weekHeaderC = UIColor(named: "cell")!
                }
            default:
                Icon = UIImage(named: "moon")!
                backgroundColor = UIColor(named: "Background")!
                temperatureColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 1)
                locationC = UIColor(named: "font")!
                locationDetailC = UIColor(named: "font")!
                moveToDressC = UIColor(named: "font")!
                moveToSearchC = UIColor(named: "font")!
                tempHighC = UIColor(named: "font")!
                tempLowC = UIColor(named: "font")!
                statusC = UIColor(named: "cell")!
                weatherExplanationC = UIColor(named: "font")!
                weatherExplanationText = "The night sky is clear and stars are twinkling brightly. It's a perfect moment for stargazing and wishes."
                todayWeatherC = UIColor(named: "cell")!
                todayPrecipitationC = UIColor(named: "cell")!
                weekWeatherC = UIColor(named: "cell")!
                weekHeaderC = UIColor(named: "cell")!
            }
        }
        weatherImage.image = Icon
        view.backgroundColor = backgroundColor
        maskedUpView.backgroundColor = backgroundColor
        maskedDownView.backgroundColor = backgroundColor
        temperature.textColor = temperatureColor
        location.textColor = locationC
        locationDetail.textColor = locationDetailC
        moveToDress.tintColor = moveToDressC
        moveToSearch.tintColor = moveToSearchC
        tempHigh.textColor = tempHighC
        tempLow.textColor = tempLowC
        status.tintColor = statusC
        weatherExplanation.textColor = weatherExplanationC
        weatherExplanation.text = weatherExplanationText
        todayWeather.backgroundColor = todayWeatherC
        todayPrecipitation.backgroundColor = todayPrecipitationC
        weekWeather.backgroundColor = weekWeatherC
        weekWeatherH.backgroundColor = weekHeaderC
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // 인터페이스 스타일이 변경될 때마다 UI 업데이트
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearanceBasedOnWeather(for: self.weatherStatus)
        }
    }
    
    // MARK: - 버튼 연결
    @objc func clickToSearch() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        NetworkManager.shared.receiveMyWeatherData(addLocationData: CoreDataManager.addLocationData)
    }
    @objc func clickToStyle() {
        let vc = StyleViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func setModalPage() {
        if MainViewController.isModal == true {
            location.text = MainViewController.selectRegion?.City
            locationDetail.text = "\(String(describing: MainViewController.selectRegion?.Town ?? "")) \(String(describing: MainViewController.selectRegion?.Village ?? ""))"
            print(MainViewController.selectRegion?.Region ?? "-")
            
        }
        
        let cancelButton = UIButton()
        let addButton = UIButton()
        
        [cancelButton, addButton].forEach {
            view.addSubview($0)
        }
        
        //        cancelButton.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        cancelButton.setTitleColor(UIColor(named: "font"), for: .normal)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        
        
        //        addButton.backgroundColor = UIColor(white: 1, alpha: 0.5)
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        addButton.setTitleColor(UIColor(named: "font"), for: .normal)
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        
        cancelButton.snp.makeConstraints {
            $0.top.left.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        addButton.snp.makeConstraints {
            $0.top.right.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
    
    @objc func tappedCancelButton() {
        print("Cancel")
        
        MainViewController.isModal = false
        dismiss(animated: true)
        
    }
    
    @objc func tappedAddButton() {
        print("Add")
        
        guard let unwrapArray = MainViewController.selectRegion else {
            return
        }
        
        CoreDataManager.shared.createCoreData(combinedData: unwrapArray)
        CoreDataManager.shared.readData()
        NetworkManager.shared.receiveMyWeatherData(addLocationData: CoreDataManager.addLocationData)
        
        // Add 버튼 클릭 시 검색결과 화면이 아닌 바로 MyWeatherPage 로 이동
        if let navigationController = self.presentingViewController as? UINavigationController {
            for controller in navigationController.viewControllers {
                if let searchViewController = controller as? SearchViewController {
                    searchViewController.searchController.isActive = false
                    break
                }
            }
        }
        
        // 현재 모달을 닫습니다.
        dismiss(animated: true) {
            MainViewController.isModal = false
        }
    }
    func setModalPage2() {
        if MainViewController.isModal2 == true {
            location.text = MainViewController.selectRegion?.City
            locationDetail.text = "\(String(describing: MainViewController.selectRegion?.Town ?? "")) \(String(describing: MainViewController.selectRegion?.Village ?? ""))"
            print(MainViewController.selectRegion?.Region ?? "-")
        }
        
        let backButton = UIButton()
        
        view.addSubview(backButton)
        
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Heavy", size: 17)
        backButton.setTitleColor(UIColor(named: "font"), for: .normal)
        backButton.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view).offset(67)
            $0.right.equalTo(view.safeAreaLayoutGuide).inset(29)
        }
    }
    
    @objc func tappedBackButton() {
        
        print("Back")
        
        MainViewController.isModal2 = false
        dismiss(animated: true)
    }
}


//MARK: - 컬렉션뷰 설정

class CustomFlowLayout: UICollectionViewFlowLayout {
    //layoutAttributesForElements 매서드 = 설정한 영역과 셀 서브뷰의 속성 가져오기
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil //UICollectionViewLayout이 없으면 nil
        }
        
        for attribute in attributes {
            // 위에서 컬렉션뷰 설정할때 영역과 서브뷰간 속성이 존재하지 않는다면. 즉, collectionViewLayout: UICollectionViewFlowLayout() 으로 설정한게 아니라면
            // 컬렉션 뷰의 높이의 원하는 지점에 셀을 배치합니다. 셀 서브뷰 높이의 가운데를 컬렉션뷰 높이의 57% 지점에 맞추기
            if attribute.representedElementKind == nil {
                attribute.center.y = collectionView!.frame.height * 0.57
            }
        }
        return attributes
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case status:
            return 3
        case todayWeather:
            return 24
        case todayPrecipitation:
            return 1
        default :
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == status {
            guard let cell = status.dequeueReusableCell(withReuseIdentifier: StatusCell.identifier, for: indexPath) as? StatusCell else {
                return UICollectionViewCell()
            }
            //뷰모델에 있는 정보들을 가지고 셀을 만들겠다
            setViewModels()
            let viewModel = cellViewModels[indexPath.item]
            cell.configure(with: viewModel)
            cell.updateAppearanceBasedOnWeather(for: self.weatherStatus)
            return cell
        } else if collectionView == todayWeather {
            guard let cell = todayWeather.dequeueReusableCell(withReuseIdentifier: "TodayWeatherCell", for: indexPath) as? TodayWeatherCell else {
                return UICollectionViewCell()
            }
            cell.weatherType = self.weatherType
            cell.weatherStatus = self.weatherStatus
            if !DataProcessingManager.dayForecast.isEmpty {
                let timeString = DataProcessingManager.dayForecast[indexPath.row].time
                let hourString = String(timeString.prefix(2))
                cell.configureUI()
                cell.time.text = hourString + "시"
                cell.setIcon(status: DataProcessingManager.dayForecast[indexPath.row].status)
                cell.temperature.text = DataProcessingManager.dayForecast[indexPath.row].temp + "°"
            }
            return cell
        } else if collectionView == todayPrecipitation {
            guard let cell = todayPrecipitation.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.identifier, for: indexPath) as? ChartCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.weatherStatus = self.weatherStatus
            cell.weatherType = self.weatherType
            if !DataProcessingManager.threeDaysWeatherData.isEmpty {
                cell.setEntries()
            }
            return cell
        } else if collectionView == feels {
            guard let cell = feels.dequeueReusableCell(withReuseIdentifier: FeelsCollectionViewCell.identifier, for: indexPath) as? FeelsCollectionViewCell else {
                return UICollectionViewCell()
            }
            //뷰모델에 있는 정보들을 가지고 셀을 만들겠다
            setViewModels2()
            let viewModel = cellViewModel2[indexPath.item]
            cell.configure(with: viewModel)
            cell.updateAppearanceBasedOnWeather(for: self.weatherStatus)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    //오토레이아웃 제대로 잡기
    //viewDidLoad에서 함수 호출해주지 않아서 보이지 않았다!
    func setupHeaderView() {
        let headerView = UIView()
        contentView.addSubview(headerView)
        //뷰에다 서브뷰를 추가하면 제일 상단 서브뷰로 올라오면서 배경색도 함께 반영이 된다
        //view.addSubview(headerView)
        //headerView.backgroundColor = .red
        headerView.snp.makeConstraints(){
            $0.top.equalTo(todayWeather.snp.top)
            $0.left.right.equalTo(todayWeather)
            $0.height.equalTo(38)
        }
        let label = UILabel()
        label.text = "Hourly Forecast"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        label.textColor = setFontColor(status: self.weatherStatus)
        headerView.addSubview(label)
        
        let icon = UIImageView(image: UIImage(systemName: "clock"))
        icon.tintColor = setFontColor(status: self.weatherStatus)
        headerView.addSubview(icon)
        
        icon.snp.makeConstraints(){
            $0.top.equalTo(headerView.snp.top).offset(8)
            $0.left.equalTo(headerView.snp.left).offset(22)
            $0.width.height.equalTo(20)
        }
        label.snp.makeConstraints(){
            $0.top.equalTo(headerView.snp.top).offset(10)
            $0.left.equalTo(icon.snp.right).offset(6)
            
        }
    }
}


//MARK: - 테이블뷰 설정
extension MainViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekWeather.dequeueReusableCell(withIdentifier: "WeekWeatherCell", for: indexPath) as? WeekWeatherCell else {
            return UITableViewCell()
        }
        if !DataProcessingManager.weekForecast.isEmpty {
            cell.setDay(indexPath: indexPath.row)
            cell.pop.text = "\(DataProcessingManager.weekForecast[indexPath.row].rainPercent)%"
            cell.setDrop(rainPercent: Int(DataProcessingManager.weekForecast[indexPath.row].rainPercent) ?? 0)
            cell.setIcon(status: DataProcessingManager.weekForecast[indexPath.row].status)
            cell.tempHigh.text = "\(DataProcessingManager.weekForecast[indexPath.row].highTemp)°"
            cell.tempLow.text = "\(DataProcessingManager.weekForecast[indexPath.row].lowTemp)°"
            cell.updateAppearanceBasedOnWeather(for: self.weatherStatus)
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

        let label = UILabel()
        label.text = "Week Forecast"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        label.textColor = setFontColor(status: self.weatherStatus)
        
        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = setFontColor(status: self.weatherStatus)
        
        weekWeatherH.addSubview(label)
        weekWeatherH.addSubview(icon)
        
        icon.snp.makeConstraints(){
            $0.top.equalTo(weekWeatherH.snp.top).offset(8)
            $0.left.equalTo(weekWeatherH).offset(22)
            $0.width.height.equalTo(21)
        }
        
        label.snp.makeConstraints(){
            $0.top.equalTo(weekWeatherH.snp.top).offset(10)
            $0.left.equalTo(icon.snp.right).offset(6)
        }
        return weekWeatherH
    }
}

//MARK: - 데이터 가져오기
extension MainViewController: DataReloadDelegate {
    func dataReload() {
        DispatchQueue.main.async {
            self.location.text = MainViewController.selectRegion?.City
            self.locationDetail.text = "\(MainViewController.selectRegion?.Town ?? "") \(MainViewController.selectRegion?.Village ?? "")"
            self.weatherStatus = DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .SKY) ?? "-"
            self.weatherType = DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .PTY) ?? "-"
            self.temperature.text = "\(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "-")°"
            self.tempHigh.text = "H: \(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "-")°"
            self.tempLow.text = "L: \(DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "-")°"
            self.weekWeather.reloadData()
            self.status.reloadData()
            self.todayWeather.reloadData()
            self.todayPrecipitation.reloadData()
            self.feels.reloadData()
            self.updateAppearanceBasedOnWeather(for: self.weatherStatus)
        }
    }
}

extension MainViewController: AlertViewDelegate {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MainViewController {
    func setFontColor(status: String) -> UIColor {
        switch status {
        case "Sunny":
            return UIColor(named: "font")!
        case "Mostly Cloudy":
            return UIColor(named: "fontR")!
        default:
            return UIColor(named: "font")!
        }
    }
    
    func setCellColor(status: String) -> UIColor {
        switch status {
        case "Sunny":
            return UIColor(named: "cell")!
        case "Mostly Cloudy":
            switch self.weatherType {
            case "비", "소나기":
                return UIColor(named: "cellR")!
            case "눈", "비/눈":
                return UIColor(named: "cellS")!
            default:
                return UIColor(named: "cellR")!
            }
        default:
            return UIColor(named: "cell")!
        }
    }
}
