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
    
    private let disposeBag: DisposeBag
    private let dataManager: DataManager
    private var playersEditorView: PlayersEditorView?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.disposeBag = DisposeBag()
    }
    
    func attachView(_ view: PlayersEditorView) {
        loggingPrint("attaching View")
        playersEditorView = view
    }
    
    func addNewPlayer() {
        playersEditorView?.showAddNewPlayerAlertDialog()
    }
    
    func toggleReorder() {
        playersEditorView?.toggleReorder()
    }
    
    func checkIsEnoughPlayers() {
        loggingPrint("checkIsEnoughPlayers")
        dataManager.getPlayingPlayers()
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
            .disposed(by: disposeBag)
    }
    
    func addPlayer(playerName: String, position: Int) {
        dataManager
            .addPlayer(playerName: playerName, position: position)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { player in
                self.playersEditorView?.addPlayerToList(player: player)
                self.playersEditorView?.updatePlayerList()
            })
            .disposed(by: disposeBag)
    }
    
    func updatePlayer(player: Player) {
        dataManager
            .updatePlayer(player: player)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.playersEditorView?.updatePlayerList()
            })
            .disposed(by: disposeBag)
    }
    
    func deletePlayer(playerId: String) {
        dataManager
            .deletePlayer(playerId: playerId)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func getPlayers() {
        dataManager
            .getPlayersByPosition()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                self.playersEditorView?.setPlayersList(players: players)
            })
            .disposed(by: disposeBag)
    }
    
    func markPlayerAsPlaying(withObjectId id: String, isPlaying: Bool) {
        dataManager
            .markPlayerAsPlaying(playerId: id, isPlaying: isPlaying)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func clearGameSteps() {
        dataManager
            .clearGameSteps()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func updatesPosition(playerId: String, position: Int) {
        dataManager
            .updatePlayerPosition(playerId: playerId, position: position)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
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
    }
    
}
