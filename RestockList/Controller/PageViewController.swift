//
//  PageViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource{
    //めくられるページの配列
    private var controllers: [UIViewController] = []
    //ページ下部に固定表示されるUI
    private let usageLabel = UILabel()
    private let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //表示するページを登録
        dataSource = self
        let VC1 = storyboard!.instantiateViewController(withIdentifier: "Tutorial1")
        let VC2 = storyboard!.instantiateViewController(withIdentifier: "Tutorial2")
        let VC3 = storyboard!.instantiateViewController(withIdentifier: "Tutorial3")
        let VC4 = storyboard!.instantiateViewController(withIdentifier: "Tutorial4")
        controllers = [VC1, VC2, VC3, VC4]
        setViewControllers([controllers[0]], direction: .forward, animated: true)
        //使い方Labelを表示
        view.addSubview(usageLabel)
        usageLabel.layer.cornerRadius = 20
        usageLabel.text = "使い方"
        usageLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        usageLabel.textAlignment = .center
        usageLabel.backgroundColor = .white
        usageLabel.layer.cornerRadius = 20
        usageLabel.clipsToBounds = true
        usageLabel.translatesAutoresizingMaskIntoConstraints = false
        usageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usageLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        usageLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        usageLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //PageControlを表示
        view.addSubview(pageControl)
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.isUserInteractionEnabled = false
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .gray
        appearance.currentPageIndicatorTintColor = .white
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        let theme = Data.user.object(forKey: "theme") ?? 1
        usageLabel.textColor = UIColor(named: "AccentColor\(theme)")
    }
    //ページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    //次へ進む
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        if index == 3 {
            return nil
        }
        index += 1
        return controllers[index]
    }
    //前へ戻る
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        index -= 1
        if index < 0 {
            return nil
        }
        return controllers[index]
    }
}
