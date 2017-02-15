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
    
    func getPreferencesHelper() -> PreferencesHelper {
        return mPreferencesHelper
    }
    
    func addPlayer(playerName: String) -> Observable<Player> {
        let player = Player()
        player.playerName = playerName
        player.playerLevel = 1
        player.playerStrength = 1
        return mDatabaseHelper.setPlayer(player: player)
    
    }
    
    func getPlayer(playerId: String) -> Observable<Player> {
        return mDatabaseHelper.getPlayer(playerId: playerId)
    }
    
    func getPlayers() -> Observable<[Player]> {
        return mDatabaseHelper.getPlayers().toArray()
    }
    
    func getPlayingPlayers() -> Observable<[Player]>{
        return mDatabaseHelper.getPlayingPlayers().toArray()
    }
    
}
