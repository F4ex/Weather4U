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
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configureUI() {
        view.addSubview(myWeatherTable.tableView)
        
        myWeatherTable.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(5)
        }
    }
}
