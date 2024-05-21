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
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let location = UILabel()
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
    
    //그라데이션 레이어와 마스크 해줄 레이어 만들기
    let maskedUpView = UIView(frame: CGRect(x: 0, y: 782, width: 393, height: 70))
    let maskedDownView = UIView(frame: CGRect(x: 0, y: 0, width: 393, height: 67))
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
        CategoryManager.shared.delegate = self
        
        weekWeather.sectionHeaderTopPadding = 0
        
        maskedUpView.backgroundColor = view.backgroundColor //마스킹 컬러는 백그라운드 컬러로
        gradientUp.frame = maskedUpView.bounds
        gradientUp.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor] // 그라디언트 색상 정하기
        gradientUp.locations = [0, 0.2, 0.9, 1] //그라디언트 색상 넣을 영역 정하기
        //젠체 화면을 1이라 생각했을때 0%에 clear, 20%엔 white, 90%, 100%에도 화이트 넣기
        maskedUpView.layer.mask = gradientUp // 그라데이션한 레이어를 화면에 마스킹하기
        view.addSubview(maskedUpView)
        
        maskedDownView.backgroundColor = view.backgroundColor //마스킹 컬러는 백그라운드 컬러로
        gradientDown.frame = maskedDownView.bounds
        gradientDown.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientDown.locations = [0, 0.4, 0.9, 1]
        maskedDownView.layer.mask = gradientDown
        view.addSubview(maskedDownView)
        
        
        NetworkManager.shared.receiveWeatherData()
        NetworkManager.shared.receiveWeatherStatus()
        NetworkManager.shared.receiveWeatherSentence()
        NetworkManager.shared.receiveWeatherTemperature()
        JSONManager.shared.loadJSONToLocationData()
        //여기서 한번 적어주면 아래에는 shared 까지만 써줘도 됨
        //아 그러네 받아온다! 라는 함수니깐
        //아래에는 정보를 입력해주는거고!
        
        if MainViewController.isModal == true {
            moveToSearch.isHidden = true
            moveToDress.isHidden = true

            gradientDown.colors = [UIColor.clear.cgColor]

            setModalPage()
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // 인터페이스 스타일이 변경될 때마다 UI 업데이트
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearanceBasedOnWeather(for: weatherStatus)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - 오토레이아웃
    override func constraintLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints(){
            $0.top.equalTo(view)
            $0.left.right.bottom.equalTo(view)
        }
        scrollView.addSubview(contentView)
        
        [location, moveToDress, moveToSearch, imageView, weatherImage, temperature, tempHigh, tempLow, weatherExplanation, status, todayWeather, weekWeather,todayPrecipitation, feels, footerMessage, logo].forEach() {
            contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(1763)
        }
        
        location.snp.makeConstraints(){
            $0.top.equalTo(contentView).offset(33)
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
        imageView.snp.makeConstraints(){
            $0.top.equalTo(location.snp.bottom).offset(-5)
            $0.bottom.equalTo(temperature.snp.top)
        }
        weatherImage.snp.makeConstraints(){
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.centerY.equalTo(imageView)
        }
        temperature.snp.makeConstraints(){
            $0.top.equalTo(contentView).offset(383)
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
        location.font = UIFont(name: "Apple SD Gothic Neo", size: 34)
        location.textColor = UIColor(named: "font")
        
        moveToDress.setImage(UIImage(systemName: "hanger"), for: .normal)
        moveToDress.tintColor = UIColor(named: "font")
        moveToDress.addTarget(self, action: #selector(clickToStyle), for: .touchUpInside)
        
        moveToSearch.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        moveToSearch.tintColor = UIColor(named: "font")
        moveToSearch.addTarget(self, action: #selector(clickToSearch), for: .touchUpInside)
        
        temperature.font = UIFont(name: "Alata-Regular", size: 50)
        temperature.layer.shadowRadius = 2
        temperature.shadowOffset = CGSize(width: 0, height: 4)
        
        tempHigh.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        tempHigh.textColor = UIColor(named: "font")
        
        tempLow.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        tempLow.textColor = UIColor(named: "font")
        
        weatherExplanation.text = NetworkManager.weatherSentenceData ?? "No Data"
        weatherExplanation.textAlignment = .center
        weatherExplanation.numberOfLines = 2
        weatherExplanation.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        weatherExplanation.textColor = UIColor(named: "font")
        
        status.register(StatusCell.self, forCellWithReuseIdentifier: "StatusCell")
        status.backgroundColor = view.backgroundColor
        
        todayWeather.register(TodayWeatherCell.self, forCellWithReuseIdentifier: "TodayWeatherCell")
        //헤더뷰 등록하기
        todayWeather.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView")
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
        
        logo.image = UIImage(named: "weather4U")
        
        feels.register(FeelsCollectionViewCell.self, forCellWithReuseIdentifier: "FeelsCollectionViewCell")
        feels.backgroundColor = view.backgroundColor
    }
    
    
    // MARK: - 버튼 연결
    @objc func clickToSearch() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func clickToStyle() {
        let vc = StyleViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK: - 날씨별 배경 및 메인아이콘 변경
    func updateAppearanceBasedOnWeather(for weatherStatus: String) {
        var Icon = UIImage()
        var backgroundColor = UIColor()
        var temperatureColor = UIColor()
        
        switch weatherStatus {
        case "Sunny":
            Icon = UIImage(named: "sun")!
            backgroundColor = UIColor(named: "Background")!
            temperatureColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
        case "Mostly Cloudy":
            Icon = UIImage(named: "sun&cloud")!
            backgroundColor = UIColor(named: "BackGroundR")!
            temperatureColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
        case "Cloudy":
            Icon = UIImage(named: "cloudy")!
            backgroundColor = UIColor(named: "BackGroundR")!
            temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
        case "비":
            Icon = UIImage(named: "rain")!
            backgroundColor = UIColor(named: "BackGroundR")!
            temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
        case "소나기":
            Icon = UIImage(named: "heavyRain")!
            backgroundColor = UIColor(named: "BackGroundR")!
            temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
        case "비/눈":
            Icon = UIImage(named: "snow&rain")!
            backgroundColor = UIColor(named: "BackGroundS")!
            temperatureColor = UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
        case "눈":
            Icon = UIImage(named: "snow")!
            backgroundColor = UIColor(named: "BackGroundS")!
            temperatureColor = UIColor(red: 235/255, green: 252/255, blue: 255/255, alpha: 1)
        default:
            Icon = UIImage(named: "sun")!
            backgroundColor = UIColor(named: "Background")!
            temperatureColor = UIColor(red: 255/255, green: 168/255, blue: 0/255, alpha: 1)
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            switch weatherStatus {
            case "Cloudy":
                Icon = UIImage(named: "moon&cloud")!
                backgroundColor = UIColor(named: "Background")!
                temperatureColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 1)
            default:
                Icon = UIImage(named: "moon")!
                backgroundColor = UIColor(named: "Background")!
                temperatureColor = UIColor(red: 148/255, green: 139/255, blue: 183/255, alpha: 1)
            }
        }
        weatherImage.image = Icon
        view.backgroundColor = backgroundColor
        temperature.textColor = temperatureColor
    }
    
    
    func setModalPage() {
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
            //            $0.height.equalTo(20)
            //            $0.width.equalTo(50)
        }
        
        addButton.snp.makeConstraints {
            $0.top.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            //            $0.height.equalTo(cancelButton.snp.height)
            //            $0.width.equalTo(cancelButton.snp.width)
        }
        
    }
    
    
    @objc func tappedCancelButton() {
        print("Cancel")
        
        MyWeatherPageTableViewController().tableView.reloadData()
        MainViewController.isModal = false
        dismiss(animated: true)
        
    }
    
    @objc func tappedAddButton() {
        print("Add")
        
        //코어데이터에 저장
        guard let context = persistentContainer?.viewContext else { return }
        
        let addLocation = LocationAllData(context: context)

        //        addLocation.bookTitle = detailBook?.title
        //        addLocation.bookPrice = Int64(detailBook!.salePrice)
        //        addLocation.bookAuthor = detailBook?.authors.joined(separator: ", ")
        //        addLocation.bookThumbnail = detailBook?.thumbnail
        
        try? context.save()
        
        let request = LocationAllData.fetchRequest()
        _ = try? context.fetch(request)
        
        MyWeatherPageTableViewController().tableView.reloadData()
        MainViewController.isModal = false
        dismiss(animated: true)
    }
}
    
//MARK: - 컬렉션뷰 설정
//헤더뷰 정의하기
//헤더에 어떤 내용 넣어줄지 정하기
//헤더뷰 등록은 위쪽 configureUI에 함
class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionViewHeaderView"
    
    let titleLabel = UILabel()
    let icon = UIImageView()
    
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
        } else if collectionView == feels {
            guard let cell = feels.dequeueReusableCell(withReuseIdentifier: FeelsCollectionViewCell.identifier, for: indexPath) as? FeelsCollectionViewCell else {
                return UICollectionViewCell()
            }
            //뷰모델에 있는 정보들을 가지고 셀을 만들겠다
            let viewModel = cellViewModel2[indexPath.item]
            cell.configure(with: viewModel)
            return cell
        }
        return UICollectionViewCell()
    }
    
    // 헤더 뷰 제공하기
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        if collectionView == todayWeather {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.identifier, for: indexPath) as! CollectionHeaderView
            return header
        }
        return UICollectionReusableView()
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
        if let data = NetworkManager.weatherTemperatureData {
            cell.tempHigh.text = "\(data[0].taMax3)°"
            cell.tempLow.text = "\(data[0].taMin3)°"
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

//MARK: - 데이터 가져오기
extension MainViewController: DataReloadDelegate {
    func dataReload() {
        DispatchQueue.main.async {
            self.temperature.text = "\(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "-")°"
            self.tempHigh.text = "H: \(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "-")°"
            self.tempLow.text = "L: \(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "-")°"
            self.weatherExplanation.text = NetworkManager.weatherSentenceData
            self.weekWeather.reloadData()
            self.status.reloadData()
            self.todayWeather.reloadData()
            self.todayPrecipitation.reloadData()
            self.updateAppearanceBasedOnWeather(for: self.weatherStatus)
        }
    }
}
