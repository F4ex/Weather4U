//
//  SearchController.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/13/24.
//
import CoreData
import SnapKit
import UIKit


class SearchViewController: MyWeatherPageViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    let searchTable = SearchResultTableViewController()
    let settingButton = UIButton()
    let doneButton = UIButton()
    
    static var isEditMode = false
    static var isCelsius = true
    static var isFahrenheit = false
    
    let celsius : Int = 17
    
    let weatherLabel = UILabel()
    
    //    var locationData : LocationData?
    //    let networkManager = NetworkManager()
    
    var searchDebounceTimer: Timer?
    var result: [LocationDatum] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        doneButton.isHidden = true
        
        searchTable.tableView.isHidden = true
        
        setSearchController()
        setSettingButton(settingButton)
        
        setCelsius()
        
        //뒤로 가기 버튼 숨기기
        self.navigationItem.hidesBackButton = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        setProductList()
        
        myWeatherTable.tableView.reloadData()
    }
    
    
    // 코어데이터에 저장된 데이터를 불러오기 (데이터조회)
    //    private func setProductList() {
    //        guard let context = self.persistentContainer?.viewContext else { return }
    //
    //        let request = MyLocation.fetchRequest()
    //
    //        if let array = try? context.fetch(request) {
    //            self.array = array
    //        }
    //    }
    
    //MARK: - searchController
    
    func setSearchController() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search for a city."
        searchController.hidesNavigationBarDuringPresentation = true
        
        self.navigationItem.title = "Weather"
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 35, weight: .black)
                   ]
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text) // 디버깅을 위한 출력
        
        guard let text = searchController.searchBar.text?.lowercased() else {
            return
        }
      
    
        if text.isEmpty {
            searchTable.tableView.isHidden = true
            myWeatherTable.view.isHidden = false
        } else {
            searchTable.tableView.isHidden = false
            myWeatherTable.view.isHidden = true
            performSearch(with: text)
            print("히든")
        }
    }
    
    
    // 검색
    func performSearch(with text: String) {
        
        searchDebounceTimer?.invalidate()  // 이전 타이머 취소
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            // JSON 데이터를 로드합니다.
            JSONManager.shared.loadJSONToLocationData()
            
            // 검색어가 포함된 데이터 필터링하기
            let locationData = JSONManager.locationData.filter { datum in
                // 도시 이름, 동 이름
                let cityNameContainsText = datum.city.rawValue.contains(text)
                let townContainsText = datum.town.contains(text)
                let villageContainsText = datum.village.contains(text)
                
                return cityNameContainsText || townContainsText || villageContainsText
            }
            
            // 필터링된 locationData로 검색결과 업로드하기
            DispatchQueue.main.async {
                self?.result = locationData
                self?.searchTable.tableView.reloadData()
            }
        })
    }
    
    
    
    //MARK: - Pop up button (정렬방식)
    
    
    func setSettingButton(_ button: UIButton) {
        let configuration = UIButton.Configuration.plain()
        settingButton.configuration = configuration
        
        
        let seletedPriority = {(action: UIAction)  in
            
            if action.title == "Edit List" {
                self.tappedEditList()
                self.myWeatherTable.setEditing(true, animated: true)
                print("edit list")
            } else if action.title == "Celsius" {
                self.setCelsius()
            } else if action.title == "Fahrenheit"{
                self.setFahrenheit()
            }
            
            //            self.searchCollectionView.reloadData()
            print(action.title)}
        
        let editList = UIAction(title: "Edit List", image: UIImage(systemName: "pencil"), handler: seletedPriority)
        let celsiusAction = UIAction(title: "Celsius", image: UIImage(named: "Celsius"),state: (SearchViewController.isCelsius == true) ? .on : .off, handler: seletedPriority)
        let fahrenheitAction = UIAction(title: "Fahrenheit", image: UIImage(named: "Fahrenheit"), state: (SearchViewController.isFahrenheit == true) ? .on : .off, handler: seletedPriority)
        
        let menu = UIMenu(options: .displayInline, children: [editList])
        
        self.settingButton.menu = UIMenu(children: [menu,celsiusAction, fahrenheitAction])
        
        self.settingButton.showsMenuAsPrimaryAction = true
        
    }
    
    func setCelsius() {
        SearchViewController.isCelsius = true
        SearchViewController.isFahrenheit = false
        setSettingButton(settingButton)
        
        myWeatherTable.tableView.reloadData()
    }
    
    func setFahrenheit() {
        SearchViewController.isCelsius = false
        SearchViewController.isFahrenheit = true
        setSettingButton(settingButton)
        
        myWeatherTable.tableView.reloadData()
        
    }
    
    //Edit List 버튼 선택
    func tappedEditList() {
        SearchViewController.isEditMode = true
        settingButton.isHidden = true
        doneButton.isHidden = false
        self.myWeatherTable.setEditing(true, animated: true)
        print("EditList")
        
        myWeatherTable.tableView.beginUpdates()
        myWeatherTable.tableView.visibleCells.forEach { cell in
            guard let cell = cell as? MyWeatherPageTableViewCell else {return}
            cell.highLabel.isHidden = true
            cell.lowLabel.isHidden = true
            cell.weatherLabel.isHidden = true
        }
        myWeatherTable.tableView.endUpdates()
        
    }
    
    
    // 편집 끝
    @objc func tappedDone() {
        SearchViewController.isEditMode = false
        settingButton.isHidden = false
        doneButton.isHidden = true
        
        myWeatherTable.tableView.beginUpdates()
        self.myWeatherTable.setEditing(false, animated: true)
        
        myWeatherTable.tableView.visibleCells.forEach { cell in
            guard let cell = cell as? MyWeatherPageTableViewCell else {return}
            //            cell.cityLabel.isHidden = false
            //            cell.tempLabel.isHidden = false
            cell.highLabel.isHidden = false
            cell.lowLabel.isHidden = false
            cell.weatherLabel.isHidden = false
        }
        myWeatherTable.tableView.endUpdates()
        
        print("Done")
    }
    
    
    //MARK: - UI 구현 및 오토레이아웃
    override func configureUI() {
        
        [settingButton, doneButton,/* searchBar,*/ /*weatherLabel*/].forEach {
            view.addSubview($0)
        }
        
        settingButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        settingButton.frame.size = CGSize(width: 30, height: 30)
        settingButton.tintColor = .black
        
        let attributedTitle = NSAttributedString(string: "Done", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        doneButton.setAttributedTitle(attributedTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(tappedDone), for: .touchUpInside)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        doneButton.frame.size = CGSize(width: 30, height: 50)
        
        
//        weatherLabel.text = "Weather"
//        weatherLabel.font = .systemFont(ofSize: 35, weight: .black)
        
//        searchBar.searchBarStyle = .minimal
        
        
        // 테이블 뷰 컨트롤러의 뷰를 추가
        addChild(myWeatherTable) // 뷰 컨트롤러를 자식으로 추가
        view.addSubview(myWeatherTable.view) // 뷰 컨트롤러의 뷰를 추가
        myWeatherTable.didMove(toParent: self) // 부모 뷰 컨트롤러를 설정
        
        view.addSubview(searchTable.tableView)
        
        
    }
    
    override func constraintLayout() {
        
        settingButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(settingButton.snp.top)
            $0.right.equalToSuperview().inset(25)
            $0.height.equalTo(30)
        }
        
       
        myWeatherTable.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }

//        searchTable.tableView.snp.makeConstraints {
//            $0.top.equalTo(searchController.searchBar.snp_bottomMargin)
//            $0.leading.trailing.equalToSuperview().inset(15)
//            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(5)
            
//        }
        
    }
    
    
} // class


