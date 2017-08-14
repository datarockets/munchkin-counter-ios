//
//  DashboardPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift

class DashboardPresenter: Presenter {
    typealias BaseView = DashboardView
    
    private let dataManager: DataManager
    private var dashboardView: DashboardView?
    private var disposable: Disposable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func attachView(_ view: DashboardView) {
        dashboardView = view
    }
    
    func getPlayingPlayers() {
        disposable = dataManager.getPlayingPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                self.dashboardView?.setPlayers(players: players)
            })
    }
    
    func rollTheDice() {
        dashboardView?.rollTheDice()
    }
    
    func finishGameWithConfirmation() {
        dashboardView?.showFinishGameConfirmationDialog()
    }
    
    func setGameFinished() {
        dataManager.getPreferencesHelper().gameStarted = false
    }
    
    func insertStep(playerId: String, levelScore: Int, strengthScore: Int) {
        disposable = dataManager.addGameStep(playerId: playerId, levelScore: levelScore, strengthScore: strengthScore)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func detachView() {
        dashboardView = nil
        disposable?.dispose()
    }
    
}
