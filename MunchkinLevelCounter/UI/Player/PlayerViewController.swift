//
//  PlayerViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

protocol OnScoreChangedDelegate: class {
    func onScoreChanged(playerPosition: Int, playerLevel: Int, playerStrength: Int)
}

class PlayerViewController: UIViewController, PlayerView {

    var presenter: PlayerPresenter?
    
    private var mPlayerPosition: Int = 0
    
    weak var scoreChangedDelegate: OnScoreChangedDelegate?
    
    @IBOutlet weak private var btnIncreaseLevel: UIButton!
    @IBOutlet weak private var btnDecreaseLevel: UIButton!
    @IBOutlet weak private var btnIncreaseStrength: UIButton!
    @IBOutlet weak private var btnDecreaseStrength: UIButton!
    @IBOutlet weak private var tvLevelScore: UILabel!
    @IBOutlet weak private var tvStrengthScore: UILabel!
    @IBOutlet weak private var tvPlayerName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.detachView()
    }

    func loadPlayerScores(playerId: String, playerPosition: Int) {
        mPlayerPosition = playerPosition
        presenter?.loadPlayerScores(playerId: playerId)
    }
    
    func showPlayerName(playerName: String) {
        tvPlayerName.text = playerName
    }
    
    func showPlayerScores(levelScore: Int, strengthScore: Int) {
        tvLevelScore.text = "\(levelScore)"
        tvStrengthScore.text = "\(strengthScore)"
        scoreChangedDelegate?.onScoreChanged(playerPosition: mPlayerPosition,
                                             playerLevel: levelScore,
                                             playerStrength: strengthScore)
    }

    @IBAction func onIncreaseLevelButtonClick(_ sender: Any) {
        presenter?.increaseLevelScore()
    }
    
    @IBAction func onDecreaseLevelButtonClick(_ sender: Any) {
        presenter?.decreaseLevelScore()
    }
    
    @IBAction func onIncreaseStrengthButtonClick(_ sender: Any) {
        presenter?.increaseStrengthScore()
    }
    
    @IBAction func onDecreaseStrengthButtonClick(_ sender: Any) {
        presenter?.decreaseStrengthScore()
    }
}
