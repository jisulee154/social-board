//
//  SocialViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit
import SnapKit

class SocialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setConstraint()
    }
    
    var tableView = UITableView()
    
    //MARK: - ViewModel data
    let postViewModel = PostViewModel()
    
    func configureTableView() {
        tableView = {
            let table = UITableView()
            
//            table.estimatedRowHeight = 500
//            table.rowHeight = UITableView.automaticDimension
            
            table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
            
            return table
        }()
        
        setNavigationBarItem()
        setTableViewDelegates()
    }
    
    //MARK: - Navigation Item
    func setNavigationBarItem() {
        let newPostBtn = UIButton()
        let newPostBtnImage = UIImage(systemName: "pencil")
        newPostBtn.setImage(newPostBtnImage, for: .normal)
        newPostBtn.tintColor = .black
        
        let noticeBtn = UIButton()
        let noticeBtnImage = UIImage(systemName: "bell")
        noticeBtn.setImage(noticeBtnImage, for: .normal)
        noticeBtn.tintColor = .black
        
        let rightStack = UIStackView(arrangedSubviews: [newPostBtn, noticeBtn])
        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.spacing = 5
        
        let rightItems = UIBarButtonItem(customView: rightStack)
        
        self.navigationItem.title = "소셜"
        self.view.backgroundColor = .systemGray4
        self.navigationItem.rightBarButtonItem = rightItems
    }
    
    func setTableViewDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - 오토 레이아웃
    func setConstraint() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
//        // auto height
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = UITableView.automaticDimension
////
        tableView.autoresizingMask = [.flexibleHeight]
    }
}

//MARK: - TableView DataSource
extension SocialViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postViewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
        else {
            return UITableViewCell()
        }
        let post = postViewModel.posts[indexPath.row]
        cell.setPost(post)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1500
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return 1500
    }
}

//MARK: - TableView Delegate
extension SocialViewController: UITableViewDelegate {
    
}
