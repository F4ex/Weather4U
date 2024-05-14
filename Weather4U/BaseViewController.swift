//
//  BaseViewController.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/14/24.
//

import UIKit

class BaseViewController: UIViewController {
    let defaultFont = UIFont(name: "Apple SD Gothic Neo", size: 0)
    let numFont = UIFont(name: "Alata-Regular", size: 0)
    let defaultFontB = UIFont.defaultFont(weight: .semibold)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        
    }
    
    func configureUI() {
        // UI 구성 코드
    }
    
    func constraintLayout() {
        // 레이아웃 설정 코드
    }
}

//폰트 커스텀 하여 선언해주기 위해서
extension UIFont {
    static func defaultFont(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: weight)
    }
}
