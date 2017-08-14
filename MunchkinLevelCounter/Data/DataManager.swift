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
    
    private let databaseHelper: DatabaseHelper
    private let preferencesHelper: PreferencesHelper
    
    init(databaseHelper: DatabaseHelper, preferencesHelper: PreferencesHelper) {
        self.databaseHelper = databaseHelper
        self.preferencesHelper = preferencesHelper
    }
    
    func getPreferencesHelper() -> PreferencesHelper {
        return preferencesHelper
    }
    
    func addPlayer(playerName: String, position: Int) -> Observable<Player> {
        let player = Player(playerId: NSUUID().uuidString)
        player.playerName = playerName
        player.playerLevel = 1
        player.playerStrength = 1
        player.playerPosition = position
        return databaseHelper.setPlayer(player: player)
    
    }
    
    func updatePlayer(player: Player) -> Observable<Player> {
        return databaseHelper.setPlayer(player: player)
    }
    
    func getPlayer(playerId: String) -> Observable<Player> {
        return databaseHelper.getPlayer(playerId: playerId)
    }
    
    func getPlayersByPosition() -> Observable<[Player]> {
        return databaseHelper.getPlayersByPosition().toArray()
    }
    
    func getPlayingPlayers() -> Observable<[Player]> {
        return databaseHelper.getPlayingPlayers().toArray()
    }
    
    func getPlayers(sortType: ScoreType) -> Observable<[Player]> {
        switch sortType {
            case .levelScore:
                return databaseHelper.getPlayedPlayersByLevel().toArray()
            case .strengthScore:
                return databaseHelper.getPlayedPlayersByStrength().toArray()
            case .totalScore:
                return databaseHelper.getPlayedPlayersByTotal().toArray()
        }
    }
    
    func deletePlayer(playerId: String) -> Observable<Void> {
        return databaseHelper.deletePlayer(withId: playerId)
    }
    
    func markPlayerAsPlaying(playerId: String, isPlaying: Bool) -> Observable<Void> {
        return databaseHelper.markPlayerPlaying(withId: playerId, isPlaying: isPlaying)
    }
    
    func updatePlayerPosition(playerId: String, position: Int) -> Observable<Void> {
        return databaseHelper.updatePlayerPosition(with: playerId, position: position)
    }
    
    func clearGameSteps() -> Observable<Void> {
        return databaseHelper.clearGameSteps()
    }
    
    func getLineData(type: Int) -> Observable<ChartData> {
        return Observable.create { subscriber in
            let playersList = self.databaseHelper.getPlayingPlayers()
            let gameSteps = self.databaseHelper.getGameSteps()
            var playerGameSteps = [Player: [GameStep]]()
            
            _ = playersList.subscribe(onNext: { player in
                var playerSteps = [GameStep]()
                _ = gameSteps.subscribe(onNext: { step in
                    if step.playerId == player.playerId {
                        playerSteps.append(step)
                    }
                })
                playerGameSteps.updateValue(playerSteps, forKey: player)
            })
            
            var playerLines = [ChartDataSet]()
            var playerColors = [UIColor]()
            
            playerGameSteps.keys.forEach { player in
                print("\(String(describing: player.playerName))")
                let color = UIColor.colorHash(hexString: player.playerName)
                playerColors.append(color)
            }
            
            for (index, playerStepsList) in playerGameSteps.values.enumerated() {
                var entries = [ChartDataEntry]()
                for (index, step) in playerStepsList.enumerated() {
                    switch type {
                    case 0:
                        let playerLevel = step.playerLevel!
                        let levelEntry = ChartDataEntry(x: Double(index), y: Double(playerLevel))
                        entries.append(levelEntry)
                    case 1:
                        let playerStrength = step.playerStrength!
                        let strengthEntry = ChartDataEntry(x: Double(index), y: Double(playerStrength))
                        entries.append(strengthEntry)
                    case 2:
                        let playerTotal = step.playerLevel! + step.playerStrength!
                        let totalEntry = ChartDataEntry(x: Double(index), y: Double(playerTotal))
                        entries.append(totalEntry)
                    default:
                        break
                    }
                }
                
                let lineDataSet = LineChartDataSet.init(values: entries, label: nil)
                lineDataSet.drawCirclesEnabled = false
                lineDataSet.setColor(playerColors[index])
                lineDataSet.formLineWidth = 3.0
                lineDataSet.cubicIntensity = 0.1
                lineDataSet.mode = .cubicBezier
                lineDataSet.drawValuesEnabled = false
                lineDataSet.highlightEnabled = false
                playerLines.append(lineDataSet)
                    
            }
            
            let lineData = LineChartData(dataSets: playerLines)
            subscriber.onNext(lineData)
            subscriber.onCompleted()
            return Disposables.create()
        }
    }
    
    func addGameStep(playerId: String, levelScore: Int, strengthScore: Int) -> Observable<Void> {
        let gameStep = GameStep()
        gameStep.playerId = playerId
        gameStep.playerLevel = levelScore
        gameStep.playerStrength = strengthScore
        return databaseHelper.setGameStep(gameStep: gameStep)
    }
    
    func updatePlayersScores(playerId: String, levelScore: Int, strengthScore: Int) -> Observable<Void> {
        return databaseHelper.updatePlayerScores(withId: playerId, levelScore: levelScore, strengthScore: strengthScore)
    }
    
}
