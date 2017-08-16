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
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var userSeenOnboarding: Bool {
        get {
            return userDefaults.bool(forKey: isOnboardingSeen)
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: isOnboardingSeen)
        }
    }
    
    var wakeLockActive: Bool {
        get {
            return userDefaults.bool(forKey: isWakeLockActive)
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: isWakeLockActive)
        }
    }
    
    var gameStarted: Bool {
        get {
            return userDefaults.bool(forKey: isGameStarted)
        }
        set (newValue) {
            userDefaults.set(newValue, forKey: isGameStarted)
        }
    }
    
}
