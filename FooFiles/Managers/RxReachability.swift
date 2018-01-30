//
//  RxReachability.swift
//  FooFiles
//
//  Created by Alexei Shepitko on 29/01/2018.
//  Copyright © 2018 Alexei Shepitko. All rights reserved.
//

import RxSwift
import Reachability

class RxReachability {
    static let shared = RxReachability()
    
    fileprivate var reachability: Reachability?
    
    private static var _connection = Variable<Reachability.Connection>(.none)
    var connection: Observable<Reachability.Connection> {
        get {
            return RxReachability._connection.asObservable().distinctUntilChanged()
        }
    }
    
    fileprivate init() {}

    func startMonitor(host: String) -> Bool {
        guard let reachability = Reachability(hostname: host) else {
            return true
        }
        
        reachability.whenReachable = { reachability in
            RxReachability._connection.value = reachability.connection
        }
        
        reachability.whenUnreachable = { _ in
            RxReachability._connection.value = .none
        }
        
        do {
            try reachability.startNotifier()
            
            self.reachability = reachability
        }
        catch {
            return false
        }
        return true
    }
    
    func stopMonitor() {
        guard let reachability = self.reachability else {
            return
        }
        reachability.stopNotifier()
        self.reachability = nil
    }

}
