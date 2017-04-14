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
    
    private let mDataManager: DataManager
    private var mPlayersEditorView: PlayersEditorView?
    private var mSubscription: Disposable?
    
    init(dataManager: DataManager) {
        mDataManager = dataManager
    }
    
    func attachView(_ view: PlayersEditorView) {
        print("attaching View")
        mPlayersEditorView = view
    }
    
    func checkIsEnoughPlayers() {
        print("checkIsEnoughPlayers")
        mSubscription = mDataManager.getPlayingPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                if players.count >= 2 {
                    print("enoughPlayers")
                    self.mPlayersEditorView?.launchDashboard()
                } else {
                    print("not enough players")
                    self.mPlayersEditorView?.showWarning()
                }
            })
    }
    
    func addPlayer(playerName: String, position: Int) {
        mSubscription = mDataManager
            .addPlayer(playerName: playerName, position: position)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { player in
                self.mPlayersEditorView?.addPlayerToList(player: player)
            })
    }
    
    func deletePlayer(playerId: String) {
        mSubscription = mDataManager
            .deletePlayer(playerId: playerId)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func getPlayers() {
        mSubscription = mDataManager
            .getPlayersByPosition()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                self.mPlayersEditorView?.setPlayersList(players: players)
            })
    }
    
    func markPlayerAsPlaying(withObjectId id: String, isPlaying: Bool) {
        mSubscription = mDataManager
            .markPlayerAsPlaying(playerId: id, isPlaying: isPlaying)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func clearGameSteps() {
        mSubscription = mDataManager
            .clearGameSteps()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func updatesPosition(playerId: String, position: Int) {
        mSubscription = mDataManager
            .updatePlayerPosition(playerId: playerId, position: position)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func setGameStarted() {
        mDataManager.getPreferencesHelper().gameStarted = true
    }
    
    func setGameFinished() {
        mDataManager.getPreferencesHelper().gameStarted = false
    }
    
    func checkIsGameStarted() {
        if mDataManager.getPreferencesHelper().gameStarted {
            mPlayersEditorView?.showStartContinueDialog()
        }
    }
    
    func detachView() {
        print("Detaching of view")
        mPlayersEditorView = nil
        mSubscription?.dispose()
    }
    
}
