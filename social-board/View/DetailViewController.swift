//
//  DetailViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/09/02.
//

import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .orange
        
        configureNavigationBarItem()
    }
    
    func configureNavigationBarItem () {
        //MARK: - Right BarItem 설정
        let shareBtn = UIButton()
        let shareBtnImage = UIImage(systemName: "square.and.arrow.up")
        shareBtn.setImage(shareBtnImage, for: .normal)
//        shareBtn.addTarget(self, action: #selector(), for: .touchUpInside)
//        shareBtn.tintColor = .black
        
        let likeBtn = UIButton()
        let likeBtnImage = UIImage(systemName: "heart")
        likeBtn.setImage(likeBtnImage, for: .normal)
//        likeBtn.tintColor = .black
        
        let reportBtn = UIButton()
        let reportBtnImage = UIImage(systemName: "ellipsis")
        reportBtn.setImage(reportBtnImage, for: .normal)
//        reportBtn.tintColor = .black
        
        let rightStack = UIStackView(arrangedSubviews: [shareBtn, likeBtn, reportBtn])
        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.spacing = 8
        
        let rightItems = UIBarButtonItem(customView: rightStack)
        
        self.view.backgroundColor = .systemGray4
        self.navigationItem.rightBarButtonItem = rightItems
        
    }
}
