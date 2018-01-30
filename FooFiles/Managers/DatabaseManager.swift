//
//  DatabaseManager.swift
//  FooFiles
//
//  Created by Alexei Shepitko on 30/01/2018.
//  Copyright © 2018 Alexei Shepitko. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCoreData

class DatabaseManager {
    static let shared = DatabaseManager()
    
    lazy var mainContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("ERROR: unable to create application delegate. DatabaseManager")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    fileprivate init() {}

    func fetchFile(with id: String) -> Observable<File?> {
        return mainContext.rx.entities(File.self, predicate: NSPredicate(format: "%K = %@", File.primaryAttributeName, id), sortDescriptors: nil).flatMapFirst({ files in
            return Observable<File?>.just(files.first)
        })
    }
    
    func createOrUpdate<T: Persistable>(entity: T) -> Observable<T> {
        do {
            try mainContext.rx.update(entity)
        }
        catch let error {
            return Observable<T>.error(error)
        }
        return Observable<T>.just(entity)
    }

}
