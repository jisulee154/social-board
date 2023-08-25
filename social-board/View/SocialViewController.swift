//
//  SocialViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit

class SocialViewController: UIViewController {
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setConstraint()
    }
    
    //MARK: - ViewModel data
    let postViewModel = PostViewModel()
    
    func configureTableView() {
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
//        // auto height
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

//MARK: - TableView DataSource
extension SocialViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#fileID, #function, #line, " - ", postViewModel.posts.count)
        return postViewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
        else {
            return UITableViewCell()
        }
        let post = postViewModel.posts[indexPath.row]
        cell.setPost(post)
        
//        cell.jobLabel.text = post.writerID
//        cell.createdTimeLabel.text = "\(Date())"
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}

//MARK: - TableView Delegate
extension SocialViewController: UITableViewDelegate {
    
}
