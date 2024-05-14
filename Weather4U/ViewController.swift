//
//  ViewController.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import UIKit

class ViewController: UIViewController {
    let lable = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        JSONManager.shared.loadJSONToLocationData(fileName: "locationData", extensionType: "json")
    }


}

