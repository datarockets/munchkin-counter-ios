//
//  PlayersEditorPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

class PlayersEditorPresenter: Presenter {
    typealias BaseView = PlayersEditorView
    
    private let dataManager: DataManager
    private var playersEditorView: PlayersEditorView?
    private var disposable: Disposable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func attachView(_ view: PlayersEditorView) {
        loggingPrint("attaching View")
        playersEditorView = view
    }
    
    func checkIsEnoughPlayers() {
        loggingPrint("checkIsEnoughPlayers")
        disposable = dataManager.getPlayingPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                if players.count >= 2 {
                    loggingPrint("enoughPlayers")
                    self.playersEditorView?.launchDashboard()
                } else {
                    loggingPrint("not enough players")
                    self.playersEditorView?.showNotEnoughPlayersWarning()
                }
            })
    }
    
    func addPlayer(playerName: String, position: Int) {
        disposable = dataManager
            .addPlayer(playerName: playerName, position: position)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { player in
                self.playersEditorView?.addPlayerToList(player: player)
            })
    }
    
    func deletePlayer(playerId: String) {
        disposable = dataManager
            .deletePlayer(playerId: playerId)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func getPlayers() {
        disposable = dataManager
            .getPlayersByPosition()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                self.playersEditorView?.setPlayersList(players: players)
            })
    }
    
    func markPlayerAsPlaying(withObjectId id: String, isPlaying: Bool) {
        disposable = dataManager
            .markPlayerAsPlaying(playerId: id, isPlaying: isPlaying)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func clearGameSteps() {
        disposable = dataManager
            .clearGameSteps()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func updatesPosition(playerId: String, position: Int) {
        disposable = dataManager
            .updatePlayerPosition(playerId: playerId, position: position)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func setGameStarted() {
        dataManager.getPreferencesHelper().gameStarted = true
    }
    
    func setGameFinished() {
        dataManager.getPreferencesHelper().gameStarted = false
    }
    
    func checkIsGameStarted() {
        if dataManager.getPreferencesHelper().gameStarted {
            playersEditorView?.showStartContinueDialog()
        }
    }
    
    func detachView() {
        loggingPrint("Detaching of view")
        playersEditorView = nil
        disposable?.dispose()
    }
    
}
