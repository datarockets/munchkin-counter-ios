//
//  GameResultPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift

class GameResultPresenter: Presenter {
    typealias BaseView = GameResultView
    
    private let mDataManager: DataManager
    private var mGameResultView: GameResultView?
    private var mSubscription: Disposable?
    
    init(dataManager: DataManager) {
        mDataManager = dataManager
    }

    func attachView(_ view: GameResultView) {
        mGameResultView = view
    }
    
    func chooseScoreType(scoreType: Int) {
        switch scoreType {
        case 0:
            self.mGameResultView?.loadChartViewController(scoreType: .levelScore)
        case 1:
            self.mGameResultView?.loadChartViewController(scoreType: .strengthScore)
        case 2:
            self.mGameResultView?.loadChartViewController(scoreType: .totalScore)
        default: break
        }
    }
    
    func clearGameResults() {
        mSubscription = mDataManager.clearGameSteps()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe()
    }
    
    func detachView() {
        mGameResultView = nil
        mSubscription?.dispose()
    }

}
