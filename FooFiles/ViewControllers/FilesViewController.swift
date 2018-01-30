//
//  FilesViewController.swift
//  FooFiles
//
//  Created by Alexei Shepitko on 29/01/2018.
//  Copyright © 2018 Alexei Shepitko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FilesViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if !RxReachability.shared.startMonitor(host: "distillery.com") {
            print("Unable to start monitoring Distillery host")
        }

        RxReachability.shared.connection.subscribe(onNext: { [unowned self] status in
            switch status {
            case .wifi:
                self.navigationItem.title = "WiFi"
            case .cellular:
                self.navigationItem.title = "Cellular"
            case .none:
                self.navigationItem.title = "Offline"
                break
            }
        })
        .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}