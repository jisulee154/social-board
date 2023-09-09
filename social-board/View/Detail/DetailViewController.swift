//
//  DetailViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/09/02.
//

import UIKit
import SnapKit
import SwiftUI

class DetailViewController: UIViewController {
    //MARK: - 상세보기를 선택한 글 정보
    var post: Post?
    var comments: [Comment]?
    
    var tableView = {
        let tableView = UITableView()
        tableView.register(DetailMainCell.self, forCellReuseIdentifier: "DetailMainCell")
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.register(CreateCommentCell.self, forCellReuseIdentifier: "CreateCommentCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
            make.edges.equalTo(self.view)
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
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        
        //상세보기할 글이 지정되어 있지 않으면 기본 cell을 반환합니다.
        guard let post = self.post else {
            print(#fileID, #function, #line, " - post is nil.")
           
            return cell
        }
        
//        // 상단 - 글 내용을 보여줍니다.
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMainCell", for: indexPath) as? DetailMainCell {
//            cell.setPost(post)
//            
//            // Comment Test
//            PostViewModel.shared.createComment(of: post)
//        }
        
        if indexPath.section == 0 {
            // 상단 - 글 내용을 보여줍니다.
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMainCell", for: indexPath) as? DetailMainCell {
                cell.setPost(post)
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
                cell.setComments(of: post)
            }

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1500
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 500
        } else {
            return 300
        }
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

#if DEBUG
extension DetailViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: DetailViewController
        
        func makeUIViewController(context: Context) -> DetailViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        }
    }
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif


struct PreView: PreviewProvider{
    static var previews: some View {
        DetailViewController().toPreview()
    }
}
