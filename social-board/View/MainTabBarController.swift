//
//  MainTabBarController.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstNC = UINavigationController(rootViewController: ViewController(title: "채용", bgColor: .blue))
        let secondNC = UINavigationController(rootViewController: ViewController(title: "커리어", bgColor: .green))
        let socialNC = UINavigationController(rootViewController: ViewController(title: "소셜", bgColor: .orange))
        let fourthNC = UINavigationController(rootViewController: ViewController(title: "내정보", bgColor: .darkGray))
        let fifthNC = UINavigationController(rootViewController: ViewController(title: "MY 원티드", bgColor: .gray))
        
        self.viewControllers = [firstNC, secondNC, socialNC, fourthNC, fifthNC]
        
        let firstTabBarItem = UITabBarItem(title: "채용", image: UIImage(systemName: "bag.fill"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "커리어", image: UIImage(systemName: "safari.fill"), tag: 1)
        let socialTabBarItem = UITabBarItem(title: "소셜", image: UIImage(systemName: "text.bubble.fill"), tag: 2)
        let fourthTabBarItem = UITabBarItem(title: "내정보", image: UIImage(systemName: "person.crop.circle.fill"), tag: 3)
        let fifthTabBarItem = UITabBarItem(title: "MY 원티드", image: UIImage(systemName: "face.smiling.inverse"), tag: 4)
        
        firstNC.tabBarItem = firstTabBarItem
        secondNC.tabBarItem = secondTabBarItem
        socialNC.tabBarItem = socialTabBarItem
        fourthNC.tabBarItem = fourthTabBarItem
        fifthNC.tabBarItem = fifthTabBarItem
        
        self.tabBar.backgroundColor = UIColor.systemGray6
        self.tabBar.tintColor = UIColor.black
        
        
    }
}
