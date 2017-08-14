//
//  ChartsPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 21.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift

class ChartsPresenter: Presenter {
    typealias BaseView = ChartsView
    
    private let dataManager: DataManager
    private var chartsView: ChartsView?
    private var disposable: Disposable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func attachView(_ view: ChartsView) {
        chartsView = view
    }
    
    func loadChartData(type: ScoreType) {
        loggingPrint("Loading chart data")
        disposable = dataManager.getLineData(type: type.rawValue)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { lineChartData in
                    self.chartsView?.showPlayersCharts(chartData: lineChartData)
                }
            )
    }
    
    func loadPlayers(sortType: ScoreType) {
        disposable = dataManager.getPlayers(sortType: sortType)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                    self.chartsView?.showPlayersList(players: players)
                }
            )
    }
    
    func detachView() {
        chartsView = nil
        disposable?.dispose()
    }
    
}
