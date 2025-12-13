//
//  ViewController.swift
//  Fixify
//
//  Created by BP-36-201-01 on 23/11/2025.
//

import UIKit

final class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }

    private func configureTabs() {
        let dashboard = UINavigationController(rootViewController: TechnicianDashboardViewController())
        dashboard.tabBarItem = UITabBarItem(title: "Home",
                                            image: UIImage(systemName: "house.fill"),
                                            tag: 0)

        let scheduleVC = MaintenanceScheduleViewController(style: .insetGrouped)
        scheduleVC.tabBarItem = UITabBarItem(title: "Calendar",
                                             image: UIImage(systemName: "calendar"),
                                             tag: 1)
        let scheduleNav = UINavigationController(rootViewController: scheduleVC)

        let moreNav = UINavigationController(rootViewController: MoreViewController(style: .insetGrouped))
        moreNav.tabBarItem = UITabBarItem(title: "More",
                                          image: UIImage(systemName: "ellipsis"),
                                          tag: 2)

        viewControllers = [dashboard, scheduleNav, moreNav]
    }
}
