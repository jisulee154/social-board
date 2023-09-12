//
//  DetailViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/09/02.
//

import UIKit
import SnapKit

import RxSwift
import IQKeyboardManagerSwift

class DetailViewController: UIViewController {
    //MARK: - 상세보기를 선택한 글&댓글 정보
    var post: Post!
    var posts: [Post]!
    
    var comments: [Comment] = []
    var disposeBag = DisposeBag()
    
    //MARK: - delegate
    var likeBtnDelegate: CellLikeBtnProtocol?
    
    var scrollView = UIScrollView()
    
    var shareBtn = UIButton()
    var likeBtn = UIButton()
    var reportBtn = UIButton()
    var tableView = {
        let tableView = UITableView()
        tableView.register(DetailMainCell.self, forCellReuseIdentifier: "DetailMainCell")
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tableView.backgroundColor = .magenta
        
        return tableView
    }()

    /// NavBar Item
    var shareBtnImage = UIImage(systemName: "square.and.arrow.up")
    var likeBtnImage = UIImage(systemName: "heart")
    var reportBtnImage = UIImage(systemName: "ellipsis")
    
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
    
    //MARK: - Rx bind
    func bind() {
        #warning("fetch a post??")
        //MARK: - post 구독
        PostViewModel.shared.post
        .subscribe(on: MainScheduler.instance)
        .subscribe {
            self.post = $0
            
            // post.isLiked 값에 따라 좋아요 아이콘을 표시합니다.
            if self.post?.isLiked ?? false {
                //본문 하단의 좋아요 아이콘 설정
                self.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
                //상단 네비게이션바 아이템의 좋아요 아이콘 설정
                self.likeBtnImage = UIImage(systemName: "heart.fill")
            } else {
                //본문 하단의 좋아요 아이콘 설정
                self.likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                
                //상단 네비게이션바 아이템의 좋아요 아이콘 설정
                self.likeBtnImage = UIImage(systemName: "heart")
            }
        }
        .disposed(by: disposeBag)
        
        //MARK: - Comments 구독
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
        
        shareBtn.setImage(shareBtnImage, for: .normal)
        
        likeBtn.setImage(likeBtnImage, for: .normal)
        // 좋아요 버튼 동작
        likeBtn.addTarget(self, action: #selector(likeBtnOnNavBarPressed), for: .touchUpInside)
        
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
        //새 댓글 쓰기 - 어떤 글에 대한 댓글인지 알기위해 post값을 전달합니다.
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
        
        //상단 네비게이션바 아이템의 좋아요 아이콘 설정
        #warning("메인 스레드에서 동작해야하는지?")
        if self.post.isLiked ?? false {
            self.likeBtnImage = UIImage(systemName: "heart.fill")
        } else {
            self.likeBtnImage = UIImage(systemName: "heart")
        }
    }
}

//MARK: - TableView DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.comments.count
        }
//        else {
//            return 1
//        }
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
            
            // 좋아요 동작 delegate
            cell.likeBtnDelegate = self
            
            return cell

        }
        else {
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

extension DetailViewController {
    //MARK: - 네비게이션 바의 좋아요 버튼 동작
    @objc func likeBtnOnNavBarPressed() {
//        if self.post?.isLiked ?? false {
//            PostViewModel.shared.updateAPost(self.post, isLiked: false)
//        } else {
//            PostViewModel.shared.updateAPost(self.post, isLiked: true)
//        }
        self.likeBtnDelegate?.likeBtnPressed(of: self.post)
    }
}

//MARK: - 셀에서의 좋아요 버튼 동작을 위한 Delegate
extension DetailViewController: CellLikeBtnProtocol {
    func likeBtnPressed(of post: Post) {
        if post.isLiked ?? false {
            PostViewModel.shared.updateAPost(post, isLiked: false)
        } else {
            PostViewModel.shared.updateAPost(post, isLiked: true)
        }
        
        PostViewModel.shared.fetchAPost(post)
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
