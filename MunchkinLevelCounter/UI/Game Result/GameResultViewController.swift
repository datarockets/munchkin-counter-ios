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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
        chartViewController = childViewControllers.first as? ChartsViewController
        presenter?.chooseScoreType(scoreType: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.detachView()
    }

    @IBAction func onEditorButtonClick(_ sender: Any) {
        presenter?.clearGameResults()
        let playersEditorViewController = storyboard?.instantiateInitialViewController()
        present(playersEditorViewController!, animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onScoreTypeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = scoreTypeChanger.selectedSegmentIndex
        presenter?.chooseScoreType(scoreType: selectedIndex)
    }
    
    func loadChartViewController(scoreType: ScoreType) {
        chartViewController?.loadChartData(chartType: scoreType)
    }
    
}
