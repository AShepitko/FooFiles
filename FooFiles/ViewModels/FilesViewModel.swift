//
//  FilesViewModel.swift
//  FooFiles
//
//  Created by Alexei Shepitko on 30/01/2018.
//  Copyright © 2018 Alexei Shepitko. All rights reserved.
//

import Foundation
import RxSwift
import Reachability

class FilesViewModel {
    
    let disposeBag = DisposeBag()
    
    // Output
    private(set) var files = Variable<[File]>([])
    private(set) var connectionStatus = Variable<String?>(nil)
    
    func startFetching() {
        addTestFiles() // add test data

        RxReachability.shared.connection.subscribe(onNext: { [weak self] status in
            var statusString: String?
            switch status {
            case .wifi:
                statusString = "WiFi"
            case .cellular:
                statusString = "Cellular"
            case .none:
                statusString = "Offline"
                break
            }
            self?.connectionStatus.value = statusString
        })
            .disposed(by: disposeBag)

        
        DatabaseManager.shared.fetchAll(with: File.self)
            .subscribe(onNext: { [weak self] files in
                self?.files.value = files
            })
            .disposed(by: disposeBag)
    }
    
    private func addTestFiles() {
        let filenames = [ "1.txt", "2.txt", "3.txt" ]
        for filename in filenames {
            DatabaseManager.shared.fetchEntity(with: File.self, id: filename)
                .filter { $0 == nil }
                .map { _ in
                    File(id: filename, remoteUrl: nil, localUrl: nil, name: filename, created: Date())
                }
                .flatMap { DatabaseManager.shared.createOrUpdate(entity: $0) }
                .subscribe(onNext: { file in
                    print("Created file: \(file.id) - \(file.created!)")
                })
                .disposed(by: disposeBag)
        }
    }
}
