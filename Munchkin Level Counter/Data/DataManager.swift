//
//  DataManager.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift

class DataManager {
    
    private let mDatabaseHelper: DatabaseHelper
    
    init(databaseHelper: DatabaseHelper) {
        mDatabaseHelper = databaseHelper
    }
    
    func getPlayer() {
        
    }
    
    func getPlayers() -> Observable<PlayerItem> {
        return Observable.create { observer in
            observer.on(.next(PlayerItem()))
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    func getPlayingPlayers() {
        
    }
    
}
