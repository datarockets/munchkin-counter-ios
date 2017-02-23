//
//  OnboardingViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import EAIntroView

class OnboardingViewController: UIViewController, OnboardingView, EAIntroDelegate {

    var presenter: OnboardingPresenter?
    
    var rootView: UIView?
    var intro: EAIntroView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
        rootView = self.view
        displayOnboarding()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    func displayOnboarding() {
        let pageOne = EAIntroPage()
        pageOne.title = NSLocalizedString("onboarder.page1.title", comment: "")
        pageOne.desc = NSLocalizedString("onboarder.page2.description", comment: "")
        
        let pageTwo = EAIntroPage()
        pageTwo.title = NSLocalizedString("onboarder.page2.title", comment: "")
        pageTwo.desc = NSLocalizedString("onboarder.page2.description", comment: "")
    
        let pageThree = EAIntroPage()
        pageThree.title = NSLocalizedString("onboarder.page3.title", comment: "")
        pageThree.desc  = NSLocalizedString("onboarder.page3.description", comment: "")
        
        let introView: EAIntroView = EAIntroView(frame: rootView!.bounds, andPages: [pageOne, pageTwo, pageThree])
        introView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0.49, blue: 0.96, alpha: 1)
        introView.delegate = self
        introView.show(in: rootView)
        
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.launchStoryboard(storyboard: Storyboard.Main)
    }
    
    
}
