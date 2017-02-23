//
//  PreferencesHelper.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import CoreData

class PreferencesHelper {
    
    private let IS_ONBOARING_SEEN = "is_onboarding_seen"
    private let IS_WAKELOCK_ACTIVE = "is_wakelock_active"
    private let IS_GAME_STARTED = "is_game_started"
    
    private let mUserDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        mUserDefaults = userDefaults
    }
    
    func checkIsUserSeenOnboarding() -> Bool {
        return mUserDefaults.bool(forKey: IS_ONBOARING_SEEN)
    }
    
    func setOnboardingSeen() {
        mUserDefaults.set(true, forKey: IS_ONBOARING_SEEN)
    }
    
    func isWakeLockActive() -> Bool {
        return mUserDefaults.bool(forKey: IS_WAKELOCK_ACTIVE)
    }
    
    func setWakeLock(isActive: Bool) {
        mUserDefaults.set(isActive, forKey: IS_WAKELOCK_ACTIVE)
    }
    
    func isGameStarted() -> Bool {
        return mUserDefaults.bool(forKey: IS_GAME_STARTED)
    }
    
    func setGameStatus(isGameStarted: Bool) {
        mUserDefaults.set(isGameStarted, forKey: IS_GAME_STARTED)
    }
    
}
