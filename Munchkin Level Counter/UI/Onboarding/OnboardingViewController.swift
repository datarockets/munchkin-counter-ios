//
//  OnboardingViewController.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 10.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController, OnboardingView {

    var presenter: OnboardingPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        presenter?.attachView(self)
        view.backgroundColor = UIColor.darkGray
        
        setViewControllers([viewControllerAt(0)], direction: .forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.detachView()
    }
    
    func viewControllerAt(_ index: Int) -> OnboardingStepViewController {
        let childViewController = OnboardingStepViewController()
        childViewController.index = index
        return childViewController
    }

}

extension OnboardingViewController : UIPageViewControllerDataSource {
 
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as! OnboardingStepViewController).index!
        if index == 0 {
            return nil
        }
        index = index - 1
        return viewControllerAt(index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = (viewController as! OnboardingStepViewController).index!
        index = index + 1
        if (index == 3) {
            return nil
        }
        return viewControllerAt(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}


extension OnboardingViewController : UIPageViewControllerDelegate {
    
}
