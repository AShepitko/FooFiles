//
//  File+Extension.swift
//  FooFiles
//
//  Created by Alexei Shepitko on 30/01/2018.
//  Copyright © 2018 Alexei Shepitko. All rights reserved.
//
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

func == (lhs: File, rhs: File) -> Bool {
    return lhs.id == rhs.id
}

extension File : Equatable { }

extension File : IdentifiableType {
    typealias Identity = String
    
    var identity: Identity { return id }
}

extension File : Persistable {
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "File"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! String
        remoteUrl = entity.value(forKey: "remoteUrl") as? URL
        localUrl = entity.value(forKey: "localUrl") as? URL
        name = entity.value(forKey: "name") as! String
        created = entity.value(forKey: "created") as? Date
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(remoteUrl, forKey: "remoteUrl")
        entity.setValue(localUrl, forKey: "localUrl")
        entity.setValue(name, forKey: "name")
        entity.setValue(created, forKey: "created")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}
