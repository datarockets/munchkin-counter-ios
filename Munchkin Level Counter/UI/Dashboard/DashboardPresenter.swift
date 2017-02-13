//
//  DashboardPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

class DashboardPresenter: Presenter {
    typealias BaseView = DashboardView
    
    private let mDataManager: DataManager
    private var mDashboardView: DashboardView?
    
    init(dataManager: DataManager) {
        mDataManager = dataManager
    }
    
    func attachView(_ view: DashboardView) {
        mDashboardView = view
    }
    
    func detachView() {
        mDashboardView = nil
    }
    
}
