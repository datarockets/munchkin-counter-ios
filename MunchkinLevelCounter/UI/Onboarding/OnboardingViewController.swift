//
//  OnboardingViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import EAIntroView

class OnboardingViewController: UIViewController {

    var presenter: OnboardingPresenter?
    fileprivate var rootView: UIView?
    fileprivate var intro: EAIntroView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
        rootView = self.view
        displayOnboarding()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
        
    // MARK: Helpers
    
    fileprivate func displayOnboarding() {
        let pageOne = EAIntroPage()
        pageOne.title = "onboarder.page1.title".localized
        pageOne.desc = "onboarder.page1.description".localized
        pageOne.titleIconView = UIImageView(image: UIImage(named: "MunchkinOnboarder"))
        pageOne.bgColor = Colors.cardGeneral
        
        let pageTwo = EAIntroPage()
        pageTwo.title = "onboarder.page2.title".localized
        pageTwo.desc = "onboarder.page2.description".localized
        pageTwo.titleIconView = UIImageView(image: UIImage(named: "OnboardDice"))
        pageTwo.bgColor = Colors.cardLight
    
        let pageThree = EAIntroPage()
        pageThree.title = "onboarder.page3.title".localized
        pageThree.desc  = "onboarder.page3.description".localized
        pageThree.titleIconView = UIImageView(image: UIImage(named: "OnboardInfinite"))
        pageThree.bgColor = Colors.cardCorner
        
        let introView: EAIntroView = EAIntroView(frame: rootView!.bounds, andPages: [pageOne, pageTwo, pageThree])
        introView.backgroundColor = UIColor(red: 0, green: 0.49, blue: 0.96, alpha: 1)
        introView.delegate = self
        introView.skipButton.setTitle("button.skip".localized, for: .normal)
        introView.show(in: rootView)
    }
    
}

// MARK: OnboardingView

extension OnboardingViewController: OnboardingView {
    
}

// MARK: EAIntroDelegate

extension OnboardingViewController: EAIntroDelegate {
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        presenter?.setOnboardingSeen()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.launchStoryboard(storyboard: Storyboard.Main)
    }
    
}
