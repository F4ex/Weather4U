//
//  ViewController.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.executeNetwork(date: "20240513", time: "1500")
    }


}

