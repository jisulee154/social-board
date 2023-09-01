//
//  SocialViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit
import RxSwift
import SnapKit

class SocialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setConstraint()
        
        bind()
    }
    
    var tableView = {
        let table = UITableView()
        table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        table.register(PostTopCell.self, forCellReuseIdentifier: "PostTopCell")
//        table.register(PostHeader.self, forHeaderFooterViewReuseIdentifier: "PostHeader")
        
        return table
    }()
    
    //MARK: - ViewModel data
    let postViewModel = PostViewModel()
    let disposeBag = DisposeBag()
    
    var posts: [Post] = [] {
        didSet {
//            print(#fileID, #function, #line, " - DIDSET", posts)
        }
    }
    
    func configureTableView() {
        setNavigationBarItem()
        setTableViewDelegates()
    }
    
    //MARK: - Navigation Item
    func setNavigationBarItem() {
        let newPostBtn = UIButton()
        let newPostBtnImage = UIImage(systemName: "pencil")
        newPostBtn.setImage(newPostBtnImage, for: .normal)
        newPostBtn.addTarget(self, action: #selector(moveToCreatePostViewController), for: .touchUpInside)
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
    }
    
    //MARK: - 화면 전환 (-> 새글 쓰기)
    @objc func moveToCreatePostViewController() {
        let targetViewController = CreatePostViewController()
        self.present(targetViewController, animated: true)
    }
    
    //MARK: - rx 구독
    func bind() {
        postViewModel.posts
            .subscribe(on: MainScheduler.instance)
            .subscribe {
                self.posts = $0
                self.tableView.reloadData()
                print(#fileID, #function, #line, " - bind()!!")
            }
            .disposed(by: disposeBag)
        
//        postViewModel.updateTableView
//            .subscribe(on: MainScheduler.instance)
//            .subscribe {
//                if $0 {
//                    print(#fileID, #function, #line, " - updateTableView subscribed")
//                    self.tableView.reloadData()
//                }
//            }
//            .disposed(by: disposeBag)
        postViewModel.fetchPosts()
    }
    
}

//MARK: - TableView DataSource
extension SocialViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 최상단 글쓰기 셀을 보여줍니다.
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTopCell", for: indexPath) as? PostTopCell
            else {
                return UITableViewCell()
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
            else {
                return UITableViewCell()
            }
            
            let post = posts[indexPath.row]
            
            cell.setPost(post)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1500
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - Section 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}

//MARK: - TableView Delegate
extension SocialViewController: UITableViewDelegate {
    
}
