//
//  Presenter.swift
//  Munchkin Level Counter
//
//  Created by Dzmitry Chyrta on 09.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation

protocol Presenter {
    associatedtype BaseView
    func attachView(view: BaseView)
    func detachView()
}
