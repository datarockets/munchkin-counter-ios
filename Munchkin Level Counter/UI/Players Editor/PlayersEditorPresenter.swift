//
//  PlayersEditorPresenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import RxSwift

class PlayersEditorPresenter: Presenter {
    
    private var mDataManager: DataManager?
    private var mPlayersEditorView: PlayersEditorView?
    private var mSubscription: Disposable?
    
    func attachView(view: PlayersEditorView) {
        mPlayersEditorView = view
    }
    
    func getPlayers() {
        mSubscription = mDataManager?
            .getPlayers()
            .subscribe(onNext: { players in
                print(players)
            })
    }
    
    func detachView() {
        mPlayersEditorView = nil
    }
    
    
}
