//
//  ChartsView.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 21.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import Charts

protocol ChartsView: BaseView {
    
    func showPlayersList(players: [Player])
    func showPlayersCharts(chartData: ChartData)
    
}
