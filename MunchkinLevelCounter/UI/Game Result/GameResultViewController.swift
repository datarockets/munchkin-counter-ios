//
//  GameResultViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

enum ScoreType: Int {
    case levelScore = 0
    case strengthScore = 1
    case totalScore = 2
}

class GameResultViewController: BaseViewController, GameResultView {
    
    var presenter: GameResultPresenter?
    
    @IBOutlet weak private var scoreTypeChanger: UISegmentedControl!
    @IBOutlet weak private var chartViewController: ChartsViewController!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
        chartViewController = childViewControllers.first as? ChartsViewController
        presenter?.chooseScoreType(scoreType: 0)
        self.navigationController?.viewControllers.remove(at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    // MARK: User Interaction
    
    @IBAction func onScoreTypeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = scoreTypeChanger.selectedSegmentIndex
        presenter?.chooseScoreType(scoreType: selectedIndex)
    }
    
    // MARK: Other
    
    func loadChartViewController(scoreType: ScoreType) {
        chartViewController?.loadChartData(chartType: scoreType)
    }
}
