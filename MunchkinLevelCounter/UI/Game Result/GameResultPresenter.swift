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
    
    private let dataManager: DataManager
    private var gameResultView: GameResultView?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func attachView(_ view: GameResultView) {
        gameResultView = view
    }
    
    func chooseScoreType(scoreType: Int) {
        switch scoreType {
        case 0:
            self.gameResultView?.loadChartViewController(scoreType: .levelScore)
        case 1:
            self.gameResultView?.loadChartViewController(scoreType: .strengthScore)
        case 2:
            self.gameResultView?.loadChartViewController(scoreType: .totalScore)
        default: break
        }
    }
    
    func shareApp() {
        gameResultView?.shareApp()
    }
    
    func detachView() {
        gameResultView = nil
    }

}
