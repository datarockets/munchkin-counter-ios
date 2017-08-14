//
//  PlayerView.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

protocol PlayerView: BaseView {
    
    func showPlayerName(playerName: String)
    func showPlayerScores(levelScore: Int, strengthScore: Int)
    
}
