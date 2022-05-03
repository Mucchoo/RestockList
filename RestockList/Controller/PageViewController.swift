//
//  PageViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class PageViewController: UIPageViewController {
    
    private var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    private func initPageViewController() {
        let VC1 = storyboard!.instantiateViewController(withIdentifier: "Tutorial1")
        let VC2 = storyboard!.instantiateViewController(withIdentifier: "Tutorial2")
        let VC3 = storyboard!.instantiateViewController(withIdentifier: "Tutorial3")
        let VC4 = storyboard!.instantiateViewController(withIdentifier: "Tutorial4")
        controllers = [VC1, VC2, VC3, VC4]
        setViewControllers([controllers[0]], direction: .forward, animated: true)
        dataSource = self
    }
}

extension PageViewController: UIPageViewControllerDataSource {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController),
            index < controllers.count - 1 {
            return controllers[index + 1]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController),
            index > 0 {
            return controllers[index - 1]
        } else {
            return nil
        }
    }

}
