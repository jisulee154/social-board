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
        
        configureNavigationBarItem()
        
        configureTableView()
        setConstraint()
        
        bind()
    }
    
    //MARK: - View 사라질 때 수행하는 작업
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //MARK: - 더보기 전부 해제
        PostViewModel.shared.reset()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#fileID, #function, #line, " - view will appear")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    var tableView = {
        let table = UITableView()
        table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        table.register(PostTopCell.self, forCellReuseIdentifier: "PostTopCell")
        
        return table
    }()
    
    //MARK: - ViewModel data
    let disposeBag = DisposeBag()
    
    var posts: [Post] = []
//    var likeCountOfAPost: Int = 0
//    var commentCountOfAPost: Int = 0
    
    func configureTableView() {
        setTableViewDelegates()
    }
    
    //MARK: - Navigation Item
    func configureNavigationBarItem() {
        let newPostBtn = UIButton()
        let newPostBtnImage = UIImage(systemName: "pencil")
        newPostBtn.setImage(newPostBtnImage, for: .normal)
        newPostBtn.addTarget(self, action: #selector(moveToCreatePostViewController), for: .touchUpInside)
//        newPostBtn.tintColor = .black
        
        let noticeBtn = UIButton()
        let noticeBtnImage = UIImage(systemName: "bell")
        noticeBtn.setImage(noticeBtnImage, for: .normal)
//        noticeBtn.tintColor = .black
        
        let rightStack = UIStackView(arrangedSubviews: [newPostBtn, noticeBtn])
        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.spacing = 5
        
        let rightItems = UIBarButtonItem(customView: rightStack)
        
        self.navigationItem.title = "소셜"
        self.view.backgroundColor = .systemGray4
        self.navigationItem.rightBarButtonItem = rightItems
        
        //MARK: - Back BarButton Item 설정
        let backBtnItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBtnItem
        self.navigationController?.navigationBar.tintColor = .black
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
    
    //MARK: - rx 구독
    func bind() {
        PostViewModel.shared.posts
            .subscribe(on: MainScheduler.instance)
            .subscribe {
                print(#fileID, #function, #line, "posts - subscribe()!!")
                self.posts = $0
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        PostViewModel.shared.fetchPosts()
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
            cell.presentToCreatePostDelegate = self
            cell.selectionStyle = .none
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
            else {
                return UITableViewCell()
            }
            
            let post = posts[indexPath.row]
            
            cell.presentDelegate = self // 화면전환 프로토콜 위임
            cell.likeBtnDelegate = self // 좋아요 버튼 동작 위임
            cell.presentToUserInfoDelegate = self // 유저정보 화면전환 위임
            
            cell.setPost(post)
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1500
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: self    social_board.SocialViewController    0x0000000154d13790- Section 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

//MARK: - TableView Delegate
extension SocialViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

//MARK: - 테이블 뷰 셀에서의 화면전환을 위한 Delegate
extension SocialViewController: CellPresentProtocol {
    func presentToDetail(of post: Post) {
        let detailViewController = DetailViewController()
        detailViewController.setPost(post)
//        print(#fileID, #function, #line, " - detailView에 전달된 post: ", post)
        
        // 상세 글보기 좋아요 버튼 동작 위임
        detailViewController.likeBtnDelegate = self
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - 셀에서의 좋아요 버튼 동작을 위한 Delegate
extension SocialViewController: CellLikeBtnProtocol {
    func likeBtnPressed(of post: Post) {
        if post.isLiked ?? false {
            PostViewModel.shared.updateAPost(post, isLiked: false)
        } else {
            PostViewModel.shared.updateAPost(post, isLiked: true)
        }
        
        PostViewModel.shared.fetchAPost(post)
    }
}

//MARK: - 새글쓰기를 위한 Delegate
extension SocialViewController: CellPresentToCreatePostProtocol {
    //MARK: - 화면 전환 (-> 새글 쓰기 화면)
    @objc func moveToCreatePostViewController() {
        let targetViewController = CreatePostViewController()
        self.present(targetViewController, animated: true)
    }
}

//MARK: - 유저정보 화면전환을 위한 Delegate
extension SocialViewController: CellPresentToUserInfoProtocol {
    func presentToUserInfo(of post: Post) {
        let targetViewController = UserInfo()
        
        self.navigationController?.pushViewController(targetViewController, animated: true)
    }
}
