//
//  PlayerViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 16.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

protocol OnScoreChangedDelegate {
    func onScoreChanged(playerPosition: Int, playerLevel: Int, playerStrength: Int)
}

class PlayerViewController: UIViewController, PlayerView {

    var presenter: PlayerPresenter?
    
    private var mPlayerPosition: Int = 0
    var scoreChangedDelegate: OnScoreChangedDelegate?
    
    @IBOutlet weak var btnIncreaseLevel: UIButton!
    @IBOutlet weak var btnDecreaseLevel: UIButton!
    @IBOutlet weak var btnIncreaseStrength: UIButton!
    @IBOutlet weak var btnDecreaseStrength: UIButton!
    @IBOutlet weak var tvLevelScore: UILabel!
    @IBOutlet weak var tvStrengthScore: UILabel!
    @IBOutlet weak var tvPlayerName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
