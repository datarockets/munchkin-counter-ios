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
    @IBOutlet weak private var btnLeftShare: UIBarButtonItem!

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
    
    @IBAction func onScoreTypeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = scoreTypeChanger.selectedSegmentIndex
        presenter?.chooseScoreType(scoreType: selectedIndex)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let itemsToShare = [ "Check out Level Counter for Munchkin!" ]    // TODO: Add link to AppStore later
        
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivityType.addToReadingList,
                                                        UIActivityType.airDrop,
                                                        UIActivityType.assignToContact,
                                                        UIActivityType.openInIBooks,
                                                        UIActivityType.postToFlickr,
                                                        UIActivityType.postToVimeo,
                                                        UIActivityType.print,
                                                        UIActivityType.saveToCameraRoll]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
     
    func loadChartViewController(scoreType: ScoreType) {
        chartViewController?.loadChartData(chartType: scoreType)
    }
}
