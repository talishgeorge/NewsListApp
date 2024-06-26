//
//  HelloPresenter.swift
//  DemoCleanSwift
//
//  Created by Talish George on 25/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HelloPresentationLogic
{
  func presentSomething(response: Hello.Something.Response)
}

class HelloPresenter: HelloPresentationLogic
{
  weak var viewController: HelloDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Hello.Something.Response)
  {
    let viewModel = Hello.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
