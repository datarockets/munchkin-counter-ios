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
    
    private let isOnboardingSeen = "is_onboarding_seen"
    private let isWakeLockActive = "is_wakelock_active"
    private let isGameStarted = "is_game_started"
    
    private let mUserDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        mUserDefaults = userDefaults
    }
    
    var userSeenOnboarding: Bool {
        get {
            return mUserDefaults.bool(forKey: isOnboardingSeen)
        }
        set (newValue) {
            mUserDefaults.set(newValue, forKey: isOnboardingSeen)
        }
    }
    
    var wakeLockActive: Bool {
        get {
            return mUserDefaults.bool(forKey: isWakeLockActive)
        }
        set (newValue) {
            mUserDefaults.set(newValue, forKey: isWakeLockActive)
        }
    }
    
    var gameStarted: Bool {
        get {
            return mUserDefaults.bool(forKey: isGameStarted)
        }
        set (newValue) {
            mUserDefaults.set(newValue, forKey: isGameStarted)
        }
    }
    
}
