//
//  PageViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    
    private var controllers: [UIViewController] = []
    private var pageControl: UIPageControl!
    private let usageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //表示するページを登録
        dataSource = self
        let firstPage = storyboard!.instantiateViewController(withIdentifier: R.string.localizable.tutorial1())
        let secondPage = storyboard!.instantiateViewController(withIdentifier: R.string.localizable.tutorial2())
        let thirdPage = storyboard!.instantiateViewController(withIdentifier: R.string.localizable.tutorial3())
        let fourthPage = storyboard!.instantiateViewController(withIdentifier: R.string.localizable.tutorial4())
        controllers = [firstPage, secondPage, thirdPage, fourthPage]
        setViewControllers([controllers[0]], direction: .forward, animated: true)
        //使い方Labelを表示
        view.addSubview(usageLabel)
        usageLabel.layer.cornerRadius = 20
        usageLabel.text = R.string.localizable.usage()
        usageLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        usageLabel.textAlignment = .center
        usageLabel.backgroundColor = R.color.clearColor()
        usageLabel.layer.cornerRadius = 20
        usageLabel.clipsToBounds = true
        usageLabel.translatesAutoresizingMaskIntoConstraints = false
        usageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usageLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        usageLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 80).isActive = true
        usageLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //PageControlを表示
        pageControl = UIPageControl()
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
        appearance.currentPageIndicatorTintColor = R.color.clearColor()
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        usageLabel.textColor = ThemeModel.color
    }
}
//ページビュー関連
extension TutorialPageViewController: UIPageViewControllerDataSource {
    //ページ数
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    //次へ進む
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = controllers.firstIndex(of: viewController)!
        pageControl.currentPage = index
        guard index < 3 else { return nil }
        index += 1
        return controllers[index]
    }
    //前へ戻る
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = controllers.firstIndex(of: viewController)!
        pageControl.currentPage = index
        guard index > 0 else { return nil }
        index -= 1
        return controllers[index]
    }
}
