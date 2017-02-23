//
//  OnboardingPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

class OnboardingPresenter: Presenter {
    typealias BaseView = OnboardingView
    
    private let mDataManager: DataManager
    private var mOnboardingView: OnboardingView?
    
    init(dataManager: DataManager) {
        mDataManager = dataManager
    }
    
    func attachView(_ view: OnboardingView) {
        mOnboardingView = view
    }
    
    func detachView() {
        mOnboardingView = nil
    }
    
}
