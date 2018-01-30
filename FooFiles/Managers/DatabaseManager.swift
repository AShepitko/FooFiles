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

    func fetchEntity<T: Persistable>(with type: T.Type, id: String) -> Observable<T?> {
        return mainContext.rx.entities(T.self, predicate: NSPredicate(format: "%K = %@", T.primaryAttributeName, id), sortDescriptors: nil).flatMapFirst({ entities in
            return Observable<T?>.just(entities.first)
        })
    }
    
    func fetchAll<T: Persistable>(with type: T.Type) -> Observable<[T]> {
        return mainContext.rx.entities()
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
