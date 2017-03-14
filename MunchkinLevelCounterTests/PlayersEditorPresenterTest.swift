//
//  PlayersEditorPresenter.swift
//  MunchkinLevelCounter
//
//  Created by Dzmitry Chyrta on 09.03.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Swinject
import XCTest
@testable import MunchkinLevelCounter

class PlayersEditorPresenterTest: XCTestCase {
    
    var playersEditorPresenter: PlayersEditorPresenter?
    var playersEditorView: PlayersEditorView?
    
    override func setUp() {
        super.setUp()
        let assembler = try! Assembler(assemblies: [
            DataAssembly(),
            PresentersAssembly()
        ])
        
        playersEditorView = PlayersEditorView()
        playersEditorPresenter = assembler.resolver.resolve(PlayersEditorPresenter.self)!
        playersEditorPresenter?.attachView(playersEditorView!)
    }
    
    func testAddingPlayer() {
        playersEditorPresenter?.addPlayer(playerName: "Dzmitry")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    
}
