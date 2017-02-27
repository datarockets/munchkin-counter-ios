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
        pageOne.title = "onboarder.page1.title".localized
        pageOne.desc = "onboarder.page2.description".localized
        pageOne.titleIconView = UIImageView(image: UIImage(named: "MunchkinLogo"))
        pageOne.bgColor = UIColor(red:0.97, green:0.77, blue:0.41, alpha:1.0)
        
        let pageTwo = EAIntroPage()
        pageTwo.title = "onboarder.page2.title".localized
        pageTwo.desc = "onboarder.page2.description".localized
        pageTwo.titleIconView = UIImageView(image: UIImage(named: "Dice"))
        pageTwo.bgColor = UIColor(red:0.97, green:0.84, blue:0.45, alpha:1.0)
    
        let pageThree = EAIntroPage()
        pageThree.title = "onboarder.page3.title".localized
        pageThree.desc  = "onboarder.page3.description".localized
        pageThree.titleIconView = UIImageView(image: UIImage(named: "Infinite"))
        pageThree.bgColor = UIColor(red:0.23, green:0.09, blue:0.02, alpha:1.0)
        
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
