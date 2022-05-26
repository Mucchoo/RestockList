//
//  PageViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class PageViewController: UIPageViewController {
    
    private var controllers: [UIViewController] = []
    private let nextButton = UIButton()
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let VC1 = storyboard!.instantiateViewController(withIdentifier: "Tutorial1")
        let VC2 = storyboard!.instantiateViewController(withIdentifier: "Tutorial2")
        let VC3 = storyboard!.instantiateViewController(withIdentifier: "Tutorial3")
        let VC4 = storyboard!.instantiateViewController(withIdentifier: "Tutorial4")
        controllers = [VC1, VC2, VC3, VC4]
        setViewControllers([controllers[0]], direction: .forward, animated: true)
        navigationController?.isNavigationBarHidden = true
        dataSource = self
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        nextButton.setTitle("次へ", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nextButton.backgroundColor = .white
        nextButton.layer.cornerRadius = 20
        Shadow.setTo(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.isUserInteractionEnabled = false
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .gray
        appearance.currentPageIndicatorTintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        nextButton.setTitleColor(UIColor(named: "AccentColor\(theme)"), for: .normal)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        if index == 3 {
            return nil
        }
        index += 1
        print("めくった")
        return controllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        index -= 1
        print("もどした")
        if index < 0 {
            return nil
        }
        return controllers[index]
    }
    
    func tutorialPageViewController(tutorialPageViewController: PageViewController,
        didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
