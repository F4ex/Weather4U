//
//  SearchController.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/13/24.
//

import SnapKit
import UIKit

class SearchController: BaseViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
   

    let settingButton = UIButton()
    let searchBar = UISearchBar()
    let weatherLabel = UILabel()
    
    
    let celsius : Int = 17
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        setSearchController(searchBar)
        configureUI()
        constraintLayout()
        setSettingButton(settingButton)
        
    }

    //MARK: - searchController
    
    func setSearchController( _ searchBar : UISearchBar ) {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        
        searchController.searchResultsUpdater = self
        
        searchBar.placeholder = "Search for a city or airport."
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
        
        
        let seletedPriority = {(action: UIAction)  in
            
 
            if action.title == "Edit List" {
                print("edit list")
            }
            else if action.title == "Celsius" {
                print(self.celsius)
            } else if action.title == "Fahrenheit"{
                print(Int((Double(self.celsius) * 1.8 + 32).rounded()))
            }
            
//            self.searchCollectionView.reloadData()
            print(action.title)}
        
        let celsiusAction = UIAction(title: "Celsius", image: UIImage(named: "Celsius"),state: .on, handler: seletedPriority)
        let fahrenheitAction = UIAction(title: "Fahrenheit", image: UIImage(named: "Fahrenheit"), state: .off, handler: seletedPriority)
        
        self.settingButton.menu = UIMenu( children: [
            UIAction(title: "Edit List", image: UIImage(systemName: "pencil"), handler: seletedPriority),
           celsiusAction, fahrenheitAction
            ])
        
        self.settingButton.showsMenuAsPrimaryAction = true
        
    }
    
    //MARK: - UI 구현 및 오토레이아웃
    override func configureUI() {
        
        [settingButton, searchBar, weatherLabel].forEach {
            view.addSubview($0)
        }
        
        settingButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        settingButton.tintColor = .black


        
        weatherLabel.text = "Weather"
        weatherLabel.font = .systemFont(ofSize: 35, weight: .black)
        
        searchBar.searchBarStyle = .minimal
    
    }

    
    override func constraintLayout() {
        
        settingButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.right.equalToSuperview().inset(20)
            $0.width.equalTo(30)
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
        
    }

    
} // class
