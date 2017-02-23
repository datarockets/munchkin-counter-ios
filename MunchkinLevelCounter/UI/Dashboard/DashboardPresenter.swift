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
    
    private let mDataManager: DataManager
    private var mDashboardView: DashboardView?
    private var mSubscription: Disposable?
    
    init(dataManager: DataManager) {
        mDataManager = dataManager
    }
    
    func attachView(_ view: DashboardView) {
        mDashboardView = view
    }
    
    func getPlayingPlayers() {
        mSubscription = mDataManager.getPlayingPlayers()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                self.mDashboardView?.setPlayers(players: players)
            })
    }
    
    func setGameFinished() {
        mDataManager.getPreferencesHelper().setGameStatus(isGameStarted: false)
    }
    
    func detachView() {
        mDashboardView = nil
        mSubscription?.dispose()
    }
    
}
