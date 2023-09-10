//
//  DetailViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/09/02.
//

import UIKit
import SnapKit
import SwiftUI

import RxSwift
import IQKeyboardManagerSwift

class DetailViewController: UIViewController {
    //MARK: - 상세보기를 선택한 글&댓글 정보
    var post: Post!
    var comments: [Comment] = []
    var disposeBag = DisposeBag()
    
    var scrollView = UIScrollView()
    
    var tableView = {
        let tableView = UITableView()
        tableView.register(DetailMainCell.self, forCellReuseIdentifier: "DetailMainCell")
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tableView.backgroundColor = .magenta
        
        return tableView
    }()
    
    /// footer: 댓글 쓰기란
    var footer = {
        let footer = CreateCommentView(frame: CGRectZero)
        
        footer.layoutIfNeeded()
        return footer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBarItem()
        
        setTableViewDelegates()
        setConstraints()
        setWhichPost()
        
        bind()
    }
    
    //MARK: - viewWillDisappear()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Rx bind - Comments 구독
    func bind() {
        if let post = self.post {
            PostViewModel.shared.comments
                .subscribe(on: MainScheduler.instance)
                .subscribe {
                    self.comments = $0
                    self.tableView.reloadData()
                }
                .disposed(by: disposeBag)
            
            PostViewModel.shared.fetchComments(of: post)
        }
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
    
    //MARK: - 글 정보 주입
    func setWhichPost() {
        footer.setPost(self.post)
    }
    
    //MARK: - 오토 레이아웃
    func setConstraints() {
        self.view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        scrollView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView).priority(800)
            make.height.greaterThanOrEqualTo(600).priority(1000)
            make.width.equalTo(scrollView).priority(800)
        }
        
        scrollView.addSubview(footer)
        scrollView.backgroundColor = .yellow
        footer.backgroundColor = .green
        footer.snp.makeConstraints { make in
            
            make.bottom.equalTo(scrollView).priority(1000)
            make.height.equalTo(150).priority(800)
            
            make.top.equalTo(tableView.snp.bottom).priority(1000)
            make.leading.trailing.equalTo(scrollView).priority(800)

            make.width.equalTo(scrollView)
        }
    }
}

extension DetailViewController {
    //MARK: - 어떤 글에 대한 상세보기인지 설정
    func setPost(_ post: Post) {
        self.post = post
    }
}

//MARK: - TableView DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //상세보기할 글이 지정되어 있지 않으면 기본 cell을 반환합니다.
        guard let post = self.post else {
            print(#fileID, #function, #line, " - post is nil.")
           
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            // 상단 - 글 내용을 보여줍니다.
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMainCell", for: indexPath) as? DetailMainCell else {
                return UITableViewCell()
            }
            cell.setPost(post)
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
                return UITableViewCell()
            }
            let comment = self.comments[indexPath.row]
            cell.setComment(comment)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
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
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//#if DEBUG
//extension DetailViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        let viewController: DetailViewController
//
//        func makeUIViewController(context: Context) -> DetailViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
//        }
//    }
//    func toPreview() -> some View {
//        Preview(viewController: self)
//    }
//}
//#endif
//
//
//struct PreView: PreviewProvider{
//    static var previews: some View {
//        DetailViewController().toPreview()
//    }
//}
