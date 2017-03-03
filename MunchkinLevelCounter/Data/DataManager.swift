//
//  DataManager.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift
import CoreData
import Charts

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
        player.playerId = NSUUID().uuidString
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
    
    func getPlayingPlayers() -> Observable<[Player]> {
        return mDatabaseHelper.getPlayingPlayers().toArray()
    }
    
    func getPlayers(sortType: ScoreType) -> Observable<[Player]> {
        switch sortType {
            case .levelScore:
                return mDatabaseHelper.getPlayedPlayersByLevel().toArray()
            case .strengthScore:
                return mDatabaseHelper.getPlayedPlayersByStrength().toArray()
            case .totalScore:
                return mDatabaseHelper.getPlayedPlayersByTotal().toArray()

        }
    }
    
    func deletePlayer(playerId: String) -> Observable<Void> {
        return mDatabaseHelper.deletePlayer(withId: playerId)
    }
    
    func markPlayerAsPlaying(playerId: String, isPlaying: Bool) -> Observable<Void> {
        return mDatabaseHelper.markPlayerPlaying(withId: playerId, isPlaying: isPlaying)
    }
    
    func clearGameSteps() -> Observable<Void> {
        return mDatabaseHelper.clearGameSteps()
    }
    
    func getLineData(type: Int) -> Observable<ChartData> {
        return Observable.create { _ in
            return Disposables.create()
        }
    }
    
    func addGameStep(playerId: String, levelScore: Int, strengthScore: Int) -> Observable<Void> {
        let gameStep = GameStep()
        gameStep.playerId = playerId
        gameStep.playerLevel = levelScore
        gameStep.playerStrength = strengthScore
        return mDatabaseHelper.setGameStep(gameStep: gameStep)
    }
    
    func updatePlayersScores(playerId: String, levelScore: Int, strengthScore: Int) -> Observable<Void> {
        return mDatabaseHelper.updatePlayerScores(withId: playerId, levelScore: levelScore, strengthScore: strengthScore)
    }
    
}
