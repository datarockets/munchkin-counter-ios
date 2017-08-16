//
//  GameResultView.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

protocol GameResultView: BaseView {
    
    func loadChartViewController(scoreType: ScoreType)
    func shareApp()
    
}
