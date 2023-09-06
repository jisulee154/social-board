//
//  DetailViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/09/02.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    var tableView = {
        let tableView = UITableView()
        tableView.register(DetailMain.self, forCellReuseIdentifier: "DetailMain")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBarItem()
        
        setTableViewDelegates()
        setConstraints()
    }
    
    func configureNavigationBarItem () {
        //MARK: - Right BarItem 설정
        let shareBtn = UIButton()
        let shareBtnImage = UIImage(systemName: "square.and.arrow.up")
        shareBtn.setImage(shareBtnImage, for: .normal)
        
        let likeBtn = UIButton()
        let likeBtnImage = UIImage(systemName: "heart")
        likeBtn.setImage(likeBtnImage, for: .normal)
        
        let reportBtn = UIButton()
        let reportBtnImage = UIImage(systemName: "ellipsis")
        reportBtn.setImage(reportBtnImage, for: .normal)
        
        let rightStack = UIStackView(arrangedSubviews: [shareBtn, likeBtn, reportBtn])
        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.spacing = 8
        
        let rightItems = UIBarButtonItem(customView: rightStack)
        
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = rightItems
        
    }
    
    //MARK: - 프로토콜 위임자 지정
    func setTableViewDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - 오토 레이아웃
    func setConstraints() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - TableView DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: - TableView Delegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
