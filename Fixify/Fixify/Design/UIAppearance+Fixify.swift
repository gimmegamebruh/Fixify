import UIKit

enum FixifyAppearance {

    static func apply() {
        // Navigation Bar
        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = DS.Color.bg
        nav.titleTextAttributes = [.foregroundColor: DS.Color.text]
        nav.largeTitleTextAttributes = [.foregroundColor: DS.Color.text]

        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance = nav
        UINavigationBar.appearance().tintColor = DS.Color.primary

        // Tab Bar
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = DS.Color.bg
        UITabBar.appearance().standardAppearance = tab
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tab
        }
        UITabBar.appearance().tintColor = DS.Color.primary
    }
}

