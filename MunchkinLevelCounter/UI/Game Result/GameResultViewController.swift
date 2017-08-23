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

class GameResultViewController: BaseViewController {
    
    var presenter: GameResultPresenter?
    
    @IBOutlet weak fileprivate var scoreTypeChanger: UISegmentedControl!
    @IBOutlet weak fileprivate var btnLeftShare: UIBarButtonItem!
    @IBOutlet weak fileprivate var chartViewController: ChartsViewController!

    // MARK: Lifecycle
    
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
    
    // MARK: Actions
    
    @IBAction func didChangeScoreType(_ sender: UISegmentedControl) {
        presenter?.chooseScoreType(scoreType: scoreTypeChanger.selectedSegmentIndex)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        presenter?.shareApp()
    }
    
}

extension GameResultViewController: GameResultView {

    func loadChartViewController(scoreType: ScoreType) {
        self.chartViewController?.loadChartData(chartType: scoreType)
    }
    
    func shareApp() {
        if let link = URL(string: "https://itunes.apple.com/app/levels-for-munchkin/id1273260162") {
            let activityViewController = UIActivityViewController(activityItems: ["text.share_message".localized, link], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [UIActivityType.addToReadingList,
                                                            UIActivityType.assignToContact,
                                                            UIActivityType.openInIBooks,
                                                            UIActivityType.postToFlickr,
                                                            UIActivityType.postToVimeo,
                                                            UIActivityType.print,
                                                            UIActivityType.saveToCameraRoll]
            
            self.present(activityViewController, animated: true)
        }
    }
}
