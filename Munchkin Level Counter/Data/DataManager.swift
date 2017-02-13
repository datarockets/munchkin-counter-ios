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
    private let mPreferencesHelper: PreferencesHelper
    
    init(databaseHelper: DatabaseHelper,
         preferencesHelper: PreferencesHelper) {
        mDatabaseHelper = databaseHelper
        mPreferencesHelper = preferencesHelper
    }
    
    func addPlayer(playerName: String) -> Observable<Player> {
        let player = Player()
        player.playerName = playerName
        player.playerLevel = 1
        player.playerStrength = 1
        return mDatabaseHelper.addPlayer(player: player)
    
    }
    
    func getPlayer(playerId: String) -> Observable<Player> {
        return Observable.create { observer in
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getPlayers() -> Observable<Player> {
        return Observable.create { observer in
            observer.on(.next(Player()))
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    func getPlayingPlayers() {
        
    }
    
}
