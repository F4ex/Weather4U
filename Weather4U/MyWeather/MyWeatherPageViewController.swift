//
//  MyWeatherPageViewController.swift
//  Weather4U
//
//  Created by 강태영 on 5/13/24.
//

import SnapKit
import UIKit

class MyWeatherPageViewController: BaseViewController {
   
    let myWeatherTable = MyWeatherPageTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 전체 화면을 덮는 배경 뷰 추가
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)

        configureUI()
    }
    
    override func configureUI() {
        // 테이블 뷰 컨트롤러의 뷰를 추가
        addChild(myWeatherTable) // 뷰 컨트롤러를 자식으로 추가
        view.addSubview(myWeatherTable.view) // 뷰 컨트롤러의 뷰를 추가
        myWeatherTable.didMove(toParent: self) // 부모 뷰 컨트롤러를 설정
        
        myWeatherTable.view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
    }
}
