//
//  PlayersEditorPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift

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
    
    func addPlayer(playerName: String) {
        mSubscription = mDataManager
            .addPlayer(playerName: playerName)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler())
            .subscribe(onNext: { player in
                self.mPlayersEditorView?.addPlayerToList(player: player)
            })
    }
    
    func getPlayers() {
        mSubscription = mDataManager
            .getPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler())
            .subscribe(onNext: { players in
                self.mPlayersEditorView?.setPlayersList(players: players)
            })
    }
    
    func markPlayerAsPlaying(withId id: String, isPlaying: Bool) {
        
    }
    
    func checkIsGameStarted() {
        if mDataManager.getPreferencesHelper().isGameStarted() {
            mPlayersEditorView?.showStartContinueDialog()
        }
    }
    
    func checkIsEnoughPlayers() {
        mSubscription = mDataManager.getPlayingPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler())
            .subscribe(onNext: { players in
                if players.count > 2 {
                    print("Enough")
                    self.mPlayersEditorView?.launchDashboard()
                } else {
                    print("Not enough")
                    self.mPlayersEditorView?.showWarning()
                }
            })
    }
    
    func detachView() {
        mPlayersEditorView = nil
        mSubscription?.dispose()
    }
    
    
}
