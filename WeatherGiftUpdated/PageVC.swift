//
//  PageVC.swift
//  WeatherGift
//
//  Created by Matthew Batsinelas on 10/17/17.
//  Copyright © 2017 Matthew Batsinelas. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    

    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var pageControl: UIPageControl!
    let barButtonWidth: CGFloat = 44
    let barButtonHeight: CGFloat = 44
    var listButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        var newLocation = WeatherLocation()
        newLocation.name = ""
        locationsArray.append(newLocation)
    
        setViewControllers([createDetailedVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurePageControl()
        configureButtons()
    }
    
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        view.addSubview(pageControl)
    }
    
    func configureButtons() {
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setImage(UIImage(named: "listbutton"), for: .normal)
        listButton.setImage(UIImage(named: "listbutton-highlighted"), for: .highlighted)
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        view.addSubview(listButton)
        
    }
    
    
    // MARK: - Segues
    
    @objc func segueToListVC(sender: UIButton!) {
        performSegue(withIdentifier: "ToListVC", sender: sender)
    
    }
    
    func segueToAboutVC(sender: UIButton!) {
        performSegue(withIdentifier: "ToAboutVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentViewController = self.viewControllers?[0] as? DetailedVC else
        {return}
        locationsArray = currentViewController.locationsArray
        if segue.identifier == "ToListVC" {
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailedVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
    }
    func createDetailedVC(forPage page: Int) -> DetailedVC {
        
        currentPage = min(max(0, page), locationsArray.count-1)
        let detailedVC = storyboard!.instantiateViewController(withIdentifier: "DetailedVC") as! DetailedVC
        
        detailedVC.locationsArray = locationsArray
        detailedVC.currentPage = currentPage
        
        return detailedVC
    }
}


extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailedVC {
            if currentViewController.currentPage < locationsArray.count-1 {
                return createDetailedVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailedVC {
            if currentViewController.currentPage > 0 {
                return createDetailedVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailedVC {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
    
    func pageControlPressed() {
        if let currentViewController = self.viewControllers?[0] as? DetailedVC {
            currentPage = currentViewController.currentPage
        }
        if pageControl.currentPage < currentPage {
            setViewControllers([createDetailedVC(forPage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
        } else if pageControl.currentPage > currentPage {
            setViewControllers([createDetailedVC(forPage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
        }
    }
    
}


