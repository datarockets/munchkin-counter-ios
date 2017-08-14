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
    
    private let disposeBag: DisposeBag
    private let dataManager: DataManager
    private var dashboardView: DashboardView?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        disposeBag = DisposeBag()
    }
    
    func attachView(_ view: DashboardView) {
        dashboardView = view
    }
    
    func getPlayingPlayers() {
        dataManager.getPlayingPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                self.dashboardView?.setPlayers(players: players)
            })
            .disposed(by: disposeBag)
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
        dataManager.addGameStep(playerId: playerId, levelScore: levelScore, strengthScore: strengthScore)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func detachView() {
        dashboardView = nil
    }
    
}
