//
//  DatabaseHelper.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord
import RxSwift

class DatabaseHelper {

    func addPlayer(player: Player) -> Observable<Player> {
        return Observable.create { observer in
            MagicalRecord.save({ (context) in
                observer.onNext(Player(playerId: "1", playerName: "2", playerLevel: 1, playerStrength: 1))
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func deletePlayer(withId id: String, completion: @escaping (_ success: Bool) -> Void) {
        MagicalRecord.save({ (context) in
            let predicate = NSPredicate(format: "id = '\(id)'")
            PlayerEntity.mr_deleteAll(matching: predicate, in: context)
        }, completion: { success, error in
            completion(success)
        })
    }
    
    func updatePlayerScores(withId id: String, levelScore: Int, strengthScore: Int, completion: @escaping (_ success: Bool) -> Void) {
        MagicalRecord.save({ (context) in
            let predicate = NSPredicate(format: "id = '\(id)'")
            PlayerEntity.mr_deleteAll(matching: predicate, in: context)
        }, completion: { success, error in
            completion(success)
        })
    }
    
}
