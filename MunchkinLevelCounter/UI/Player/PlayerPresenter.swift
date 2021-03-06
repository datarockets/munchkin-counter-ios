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

    private let disposeBag: DisposeBag
    private let dataManager: DataManager
    private var playerView: PlayerView?
    
    private var playerId: String?
    private var playerLevelScore: Int = 0
    private var playerStrengthScore: Int = 0
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        disposeBag = DisposeBag()
    }
    
    func attachView(_ view: PlayerView) {
        playerView = view
    }
    
    func loadPlayerScores(playerId: String) {
        dataManager.getPlayer(playerId: playerId)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { player in
                self.playerId = player.playerId
                self.playerLevelScore = player.playerLevel
                self.playerStrengthScore = player.playerStrength
                self.playerView?.showPlayerName(playerName: player.playerName!)
                self.playerView?.showPlayerScores(levelScore: self.playerLevelScore,
                                                  strengthScore: self.playerStrengthScore)
            })
            .disposed(by: disposeBag)
    }
    
    func increaseLevelScore() {
        playerLevelScore += 1
        updatePlayerScores()
    }
    
    func decreaseLevelScore() {
        playerLevelScore -= 1
        updatePlayerScores()
    }
    
    func increaseStrengthScore() {
        playerStrengthScore += 1
        updatePlayerScores()
    }
    
    func decreaseStrengthScore() {
        playerStrengthScore -= 1
        updatePlayerScores()
    }
    
    func updatePlayerScores() {
        dataManager.updatePlayersScores(playerId: playerId!, levelScore: playerLevelScore, strengthScore: playerStrengthScore)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onCompleted: {
                self.playerView?.showPlayerScores(levelScore: self.playerLevelScore,
                                                  strengthScore: self.playerStrengthScore)
            })
            .disposed(by: disposeBag)
    }
    
    func detachView() {
        playerView = nil
    }
    
}
