//
//  PlayerPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift

class PlayerPresenter: Presenter {
    typealias BaseView = PlayerView

    private let mDataManager: DataManager
    private var mPlayerView: PlayerView?
    private var mSubscription: Disposable?
    
    private var mPlayerId: String?
    private var mPlayerLevelScore: Int = 0
    private var mPlayerStrengthScore: Int = 0
    
    init(dataManager: DataManager) {
        mDataManager = dataManager
    }
    
    func attachView(_ view: PlayerView) {
        mPlayerView = view
    }
    
    func loadPlayerScores(playerId: String) {
        mSubscription = mDataManager.getPlayer(playerId: playerId)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { player in
                self.mPlayerId = player.playerId
                self.mPlayerLevelScore = player.playerLevel
                self.mPlayerStrengthScore = player.playerStrength
                self.mPlayerView?.showPlayerName(playerName: player.playerName!)
                self.mPlayerView?.showPlayerScores(levelScore: self.mPlayerLevelScore,
                                                   strengthScore: self.mPlayerStrengthScore)
            })
    }
    
    func increaseLevelScore() {
        mPlayerLevelScore += 1
        updatePlayerScores()
    }
    
    func decreaseLevelScore() {
        mPlayerLevelScore -= 1
        updatePlayerScores()
    }
    
    func increaseStrengthScore() {
        mPlayerStrengthScore += 1
        updatePlayerScores()
    }
    
    func decreaseStrengthScore() {
        mPlayerStrengthScore -= 1
        updatePlayerScores()
    }
    
    func updatePlayerScores() {
        mSubscription = mDataManager.updatePlayersScores(playerId: mPlayerId!, levelScore: mPlayerLevelScore, strengthScore: mPlayerStrengthScore)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onCompleted: {
                self.mPlayerView?.showPlayerScores(levelScore: self.mPlayerLevelScore,
                                                   strengthScore: self.mPlayerStrengthScore)
            })
    }
    
    func detachView() {
        mPlayerView = nil
        mSubscription?.dispose()
    }
    
}
