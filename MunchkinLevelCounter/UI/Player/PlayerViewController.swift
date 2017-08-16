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

class PlayerViewController: UIViewController {

    var presenter: PlayerPresenter?
    weak var scoreChangedDelegate: OnScoreChangedDelegate?
    fileprivate var playerPosition: Int = 0
    
    @IBOutlet weak fileprivate var btnIncreaseLevel: UIButton!
    @IBOutlet weak fileprivate var btnDecreaseLevel: UIButton!
    @IBOutlet weak fileprivate var btnIncreaseStrength: UIButton!
    @IBOutlet weak fileprivate var btnDecreaseStrength: UIButton!
    @IBOutlet weak fileprivate var tvLevelScore: UILabel!
    @IBOutlet weak fileprivate var tvStrengthScore: UILabel!
    @IBOutlet weak fileprivate var tvPlayerName: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.detachView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Actions
    
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
    
    // MARK: Helpers
    
    func loadPlayerScores(playerId: String, playerPosition: Int) {
        self.playerPosition = playerPosition
        presenter?.loadPlayerScores(playerId: playerId)
    }
    
}

// MARK: PlayerView

extension PlayerViewController: PlayerView {
    
    func showPlayerName(playerName: String) {
        tvPlayerName.text = playerName
    }
    
    func showPlayerScores(levelScore: Int, strengthScore: Int) {
        tvLevelScore.text = "\(levelScore)"
        tvStrengthScore.text = "\(strengthScore)"
        scoreChangedDelegate?.onScoreChanged(playerPosition: playerPosition,
                                             playerLevel: levelScore,
                                             playerStrength: strengthScore)
    }
}
