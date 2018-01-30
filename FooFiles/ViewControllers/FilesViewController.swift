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
    
    let viewModel = FilesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.connectionStatus.asDriver().drive(navigationItem.rx.title).disposed(by: disposeBag)
        
        viewModel.startFetching()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
