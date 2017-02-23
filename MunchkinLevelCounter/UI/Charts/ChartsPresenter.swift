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
    
    private let mDataManager: DataManager
    private var mChartsView: ChartsView?
    private var mSubscription: Disposable?
    
    init(dataManager: DataManager) {
        mDataManager = dataManager
    }
    
    func attachView(_ view: ChartsView) {
        mChartsView = view
    }
    
    func detachView() {
        mChartsView = nil
        mSubscription?.dispose()
    }
    
}
