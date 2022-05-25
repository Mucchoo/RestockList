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
        dataSource = self
        navigationItem.setHidesBackButton(true, animated: true)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        nextButton.setTitle("次へ", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nextButton.layer.cornerRadius = 20
        Shadow.setTo(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0 //indexにする
        pageControl.frame = CGRect(x: 20, y: view.frame.height - 230, width: view.frame.width - 40, height: 20)
        view.addSubview(pageControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        nextButton.backgroundColor = UIColor(named: "AccentColor\(theme)")
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .gray
        appearance.currentPageIndicatorTintColor = UIColor(named: "AccentColor\(theme)")
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
