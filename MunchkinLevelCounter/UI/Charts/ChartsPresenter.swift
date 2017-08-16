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
    
    private let disposeBag: DisposeBag
    private let dataManager: DataManager
    private var chartsView: ChartsView?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        disposeBag = DisposeBag()
    }
    
    func attachView(_ view: ChartsView) {
        chartsView = view
    }
    
    func loadChartData(type: ScoreType) {
        loggingPrint("Loading chart data")
        dataManager.getLineData(type: type.rawValue)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { lineChartData in
                    self.chartsView?.showPlayersCharts(chartData: lineChartData)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadPlayers(sortType: ScoreType) {
        dataManager.getPlayers(sortType: sortType)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { players in
                    self.chartsView?.showPlayersList(players: players)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func detachView() {
        chartsView = nil
    }
    
}
