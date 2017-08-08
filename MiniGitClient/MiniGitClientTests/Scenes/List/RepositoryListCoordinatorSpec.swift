/*
 
 Copyright 2017 - André Gimenez Faria
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Quick
import Nimble
@testable import MiniGitClient

class RepositoryListCoordinatorSpec: QuickSpec {
    
    override func spec() {
        
        describe("The RepositoryListCoordinator") { 
            
            var splitViewController = UISplitViewController(nibName: nil, bundle: nil)
            
            var coordinator : RepositoryListCoordinator?
            
            beforeEach {
                splitViewController = UISplitViewController(nibName: nil, bundle: nil)
                coordinator = RepositoryListCoordinator(splitViewController: splitViewController)
            }
            
            context("shows", { 
                
                it("the repository list screen as the master controller on start") {
                    coordinator?.start()
                    guard let navigationController = splitViewController.viewControllers[0] as? UINavigationController else { fail(); return }
                    expect(navigationController.viewControllers.first).to(beAKindOf(RepositoryListViewController.self))
                }
                
                it("the repository detail screen as the detail controller after a repository selection") {
                    coordinator?.start()
                    coordinator?.onRepositorySelection(Repository())//presenter(RepositoryListPresenter(), didSelectRepository: Repository())
                    guard let navigationController = splitViewController.viewControllers[1] as? UINavigationController else { fail(); return }
                    expect(navigationController.viewControllers.first).to(beAKindOf(RepositoryDetailViewController.self))
                }
                
            })
            
        }
        
    }
    
}
