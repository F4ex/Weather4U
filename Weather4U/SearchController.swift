//
//  SearchController.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/13/24.
//

import SnapKit
import UIKit

class SearchController: MyWeatherPageViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    
    let settingButton = UIButton()
    let doneButton = UIButton()
    
    
//    let searchBar = UISearchBar()
    let weatherLabel = UILabel()
//    let myWeatherTable = MyWeatherPageTableViewController()
    
    var isEditMode = false
    var isCelsius = true
    var isFahrenheit = false
    
    let celsius : Int = 17
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        doneButton.isHidden = true
        
        
        setSearchController(searchBar)
        
        setCelsius()
        
    }
    
    //MARK: - searchController
    
    func setSearchController( _ searchBar : UISearchBar ) {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchController.searchResultsUpdater = self
        
        searchBar.placeholder = "Search for a city."
        self.navigationItem.title = "Weather"
        searchController.hidesNavigationBarDuringPresentation = true
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        // 검색 결과를 업데이트하는 뷰 컨트롤러로 searchController를 설정
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text) // 디버깅을 위한 출력
        
        guard let text = searchController.searchBar.text?.lowercased() else {
            return
        }
        //        performSearch(with: text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 키보드를 숨깁니다.
        
        guard let text = searchBar.text?.lowercased() else {
            return
        }
        
        //            performSearch(with: text)
    }
    
    
    //    func performSearch(with text: String) {
    //        searchDebounceTimer?.invalidate()  // 기존 타이머를 취소합니다.
    //        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
    //            self?.networkManager.BookData(keyword: text) { result in
    //                DispatchQueue.main.async {
    //                    switch result {
    //                    case .success(let a):
    //                        self?.result = a
    //                        self?.tableView.reloadData()
    //                    case .failure(_):
    //                        // 에러 처리
    //                        break
    //                    }
    //                }
    //            }
    //
    //            self?.setTableView()
    //        })
    //    }
    
    //MARK: - Pop up button (정렬방식)
    
    func setSettingButton(_ button: UIButton) {
        let configuration = UIButton.Configuration.plain()
        settingButton.configuration = configuration
        
        let seletedPriority = {(action: UIAction) in
            if action.title == "Edit List" {
                self.tappedEditList()
                //                self.myWeatherTable.dragInteractionEnabled = true
            }
            else if action.title == "Celsius" {
                self.setCelsius()
            } else if action.title == "Fahrenheit"{
                self.setFahrenheit()
            }
            
            //            self.weatherTableView.reloadData()
            print(action.title)}
        
        
        
        let editList = UIAction(title: "Edit List", image: UIImage(systemName: "pencil"), handler: seletedPriority)
        let celsiusAction = UIAction(title: "Celsius", image: UIImage(named: "Celsius"),state: (isCelsius == true) ? .on : .off, handler: seletedPriority)
        let fahrenheitAction = UIAction(title: "Fahrenheit", image: UIImage(named: "Fahrenheit"), state: (isFahrenheit == true) ? .on : .off, handler: seletedPriority)
        
        let menu = UIMenu(options: .displayInline, children: [editList])
        
        var settingMenu : UIMenu {
            return UIMenu(options: [], children: [menu,celsiusAction, fahrenheitAction])
        }
        
        self.settingButton.menu = settingMenu
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: settingMenu)
        self.settingButton.showsMenuAsPrimaryAction = true
    }

    func tappedEditList() {
        isEditMode = true
        settingButton.isHidden = true
        doneButton.isHidden = false
        self.myWeatherTable.setEditing(true, animated: true)
        print("EditList")
    }
    
    //섭씨 세팅
    func setCelsius() {
        isCelsius = true
        isFahrenheit = false
        setSettingButton(settingButton)
        print(self.celsius)
    }
    
    //화씨 세팅
    func setFahrenheit() {
        isCelsius = false
        isFahrenheit = true
        setSettingButton(settingButton)
        print(Int((Double(self.celsius) * 1.8 + 32).rounded()))
    }
    
    
    // 편집 끝
    @objc func tappedDone() {
        isEditMode = false
        settingButton.isHidden = false
        doneButton.isHidden = true
        self.myWeatherTable.setEditing(false, animated: true)
        print("Done")
    }
    
    
    //MARK: - UI 구현 및 오토레이아웃
    override func configureUI() {
        
        [settingButton, doneButton, searchBar, weatherLabel].forEach {
            view.addSubview($0)
        }
        
        
        settingButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        settingButton.frame.size = CGSize(width: 30, height: 30)
        settingButton.tintColor = .black
        
        let attributedTitle = NSAttributedString(string: "Done", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        doneButton.setAttributedTitle(attributedTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(tappedDone), for: .touchUpInside)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        doneButton.frame.size = CGSize(width: 30, height: 50)
        
        
        weatherLabel.text = "Weather"
        weatherLabel.font = .systemFont(ofSize: 35, weight: .black)
        
        searchBar.searchBarStyle = .minimal
        
        
        // 테이블 뷰 컨트롤러의 뷰를 추가
        addChild(myWeatherTable) // 뷰 컨트롤러를 자식으로 추가
        view.addSubview(myWeatherTable.view) // 뷰 컨트롤러의 뷰를 추가
        myWeatherTable.didMove(toParent: self) // 부모 뷰 컨트롤러를 설정
        
        
    }
    
    
    override func constraintLayout() {
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.right.equalToSuperview().inset(25)
            $0.height.equalTo(30)
        }
        
        weatherLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(weatherLabel.snp_bottomMargin).offset(5)
            $0.left.right.equalToSuperview().inset(10)
        }
        
        myWeatherTable.view.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(0)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
        
    }
    
    
} // class

//MARK: - tableView edit


