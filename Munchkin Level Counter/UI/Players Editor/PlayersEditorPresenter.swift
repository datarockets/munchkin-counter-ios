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
        mPlayersEditorView = view
    }
    
    func checkIsEnoughPlayers() {
        mSubscription = mDataManager.getPlayingPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                if players.count >= 2 {
                    self.mPlayersEditorView?.launchDashboard()
                } else {
                    self.mPlayersEditorView?.showWarning()
                }
            })
    }
    
    func addPlayer(playerName: String) {
        mSubscription = mDataManager
            .addPlayer(playerName: playerName)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { player in
                self.mPlayersEditorView?.addPlayerToList(player: player)
            })
    }
    
    func getPlayers() {
        mSubscription = mDataManager
            .getPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                self.mPlayersEditorView?.setPlayersList(players: players)
            })
    }
    
    func markPlayerAsPlaying(withObjectId id: String, isPlaying: Bool) {
        mSubscription = mDataManager
            .markPlayerAsPlaying(playerId: id, isPlaying: isPlaying)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func clearGameSteps() {
        mSubscription = mDataManager
            .clearGameSteps()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func setGameStarted() {
        mDataManager.getPreferencesHelper().setGameStatus(isGameStarted: true)
    }
    
    func setGameFinished() {
        mDataManager.getPreferencesHelper().setGameStatus(isGameStarted: false)
    }
    
    func checkIsGameStarted() {
        if mDataManager.getPreferencesHelper().isGameStarted() {
            mPlayersEditorView?.showStartContinueDialog()
        }
    }
    
    func detachView() {
        mPlayersEditorView = nil
        mSubscription?.dispose()
    }
    
    
}
