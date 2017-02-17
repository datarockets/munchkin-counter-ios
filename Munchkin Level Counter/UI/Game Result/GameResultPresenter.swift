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
    
    func detachView() {
        mGameResultView = nil
        mSubscription?.dispose()
    }
    

}
