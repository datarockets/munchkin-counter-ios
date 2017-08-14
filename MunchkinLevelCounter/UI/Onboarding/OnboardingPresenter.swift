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
    
    private let dataManager: DataManager
    private var onboardingView: OnboardingView?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func attachView(_ view: OnboardingView) {
        onboardingView = view
    }
    
    func setOnboardingSeen() {
        dataManager.getPreferencesHelper().userSeenOnboarding = true
    }
    
    func detachView() {
        onboardingView = nil
    }
    
}
