//
//  MunchkinLevelCounterTests.swift
//  MunchkinLevelCounterTests
//
//  Created by Dzmitry Chyrta on 24.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Swinject
import Quick
import Nimble
@testable import MunchkinLevelCounter

class MunchkinLevelCounterTests: QuickSpec {
    
    override func spec() {
        var container: Container!
        beforeEach {
            container = Container()
            container.register(DataManager.self) { _ in
                return DataManager(databaseHelper: DatabaseHelper(), preferencesHelper: PreferencesHelper(userDefaults: UserDefaults()))
            }
        }
        
        it("gives me happiness") {
            
        }
        
    }
    
}
