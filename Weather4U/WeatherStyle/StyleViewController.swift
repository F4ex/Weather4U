//
//  StyleViewController.swift
//  Weather4U
//
//  Created by 이시안 on 5/19/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class StyleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
    }
    
    //MARK: - 날씨별 배경 및 메인아이콘 변경
    func updateAppearanceBasedOnWeather(for weatherStatus: String) {
        var backgroundColor = UIColor()
        
        switch weatherStatus {
        case "Sunny":
            backgroundColor = UIColor(named: "Background")!
            
        case "Mostly Cloudy":
            backgroundColor = UIColor(named: "BackGroundR")!
            
        case "Cloudy":
            backgroundColor = UIColor(named: "BackGroundR")!
            
        case "비":
            backgroundColor = UIColor(named: "BackGroundR")!

        case "소나기":
            backgroundColor = UIColor(named: "BackGroundR")!

        case "비/눈":
            backgroundColor = UIColor(named: "BackGroundS")!

        case "눈":
            backgroundColor = UIColor(named: "BackGroundS")!

        default:
            backgroundColor = UIColor(named: "Background")!
        }
        
        if traitCollection.userInterfaceStyle == .dark {
            switch weatherStatus {
            case "Cloudy":
                backgroundColor = UIColor(named: "Background")!

            default:
                backgroundColor = UIColor(named: "Background")!

            }
        }
        view.backgroundColor = backgroundColor
    }
}
