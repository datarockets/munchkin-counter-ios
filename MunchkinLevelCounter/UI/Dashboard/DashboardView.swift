//
//  DashboardView.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

protocol DashboardView: BaseView {

    func rollTheDice()
    func nextPlayer()
    func setPlayers(players: [Player])
    func showFinishGameConfirmationDialog()
    func finishGame()

}
