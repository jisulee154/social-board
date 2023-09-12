//
//  DetailMainCell.swift
//  social-board
//
//  Created by 이지수 on 2023/09/06.
//

import UIKit
import SnapKit

import RxSwift

class DetailMainCell: UITableViewCell {
    //MARK: - delegate
    var likeBtnDelegate: CellLikeBtnProtocol?
    
    // 전체 영역
    var stack = UIStackView()                           // 전체 통합
    
    // 글 상단: 작성자 상세정보
    var writerInfoStack = UIStackView()                 // 사용자 정보 통합
    
    var writerMainInfoStack = UIStackView()             // 사진 + 이름 //HStack
    var writerSubInfoStack = UIStackView()              // 직종 + 글 작성시간 //HStack
    var writerRightSideStack = UIStackView()            // main info + sub info
    
    var profilePicture = UIImageView()                  // 작성자 사진
    var nameLabel = UILabel()                           // 작성자 닉네임
    var jobLabel = UILabel()                            // 작성자 직종
    var seperatorDot = UILabel()                        // 구분자
    var createdTimeLabel = UILabel()                    // 작성 시간
    
    // 글 중앙: 내용
    var contentsStack = UIStackView()
    var contentsImageView = UIImageView()
    var contentsText = UILabel()

    // 글 하단: 좋아요/댓글 개수 정보
    var likeCommentStack = UIStackView()
    var likeIcon = UIButton()
    var likeCount = UILabel()
    var commentIcon = UIImageView()
    var commentCount = UILabel()
    
    var post: Post!
//    var likeCountValue: Int = 0
//    var commentCountValue: Int = 0
//    var isLiked: Bool = false
    
    var disposeBag = DisposeBag()
    
    //MARK: - 상수
    let profilePictureHeight: Int = 40 // 프로필 이미지 높이
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        setComponents()
        setConstraints()
    }
}

extension DetailMainCell {
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
                    self.likeIcon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.likeIcon.tintColor = .red
                } else {
                    self.likeIcon.setImage(UIImage(systemName: "heart"), for: .normal)
                    self.likeIcon.tintColor = .black
                }
                
                //좋아요 수 업데이트
                self.likeCount.text = "\(self.post?.likeCount ?? 0)"
            }
            .disposed(by: disposeBag)
        
//        //MARK: - likeCount 구독
//        PostViewModel.shared.likeCount
//            .subscribe {
//                self.likeCountValue = $0
//            }
//            .disposed(by: disposeBag)
//
//        //MARK: - commentCount 구독
//        PostViewModel.shared.commentCount
//            .subscribe {
//                self.commentCountValue = $0
//            }
//            .disposed(by: disposeBag)
    }
    
    //MARK: - Post 내용 설정
    func setPost(_ post: Post) {
        self.post = post
        
        //Rx bind
//        PostViewModel.shared.fetchAPost(post)
//        PostViewModel.shared.fetchLikeCount(of: post)
//        PostViewModel.shared.fetchCommentCount(of: post)
        
        self.createdTimeLabel.text = post.createdDateTime?.description ?? ""
        self.nameLabel.text = post.writer?.userName ?? "익명"
        self.jobLabel.text = post.writer?.job?.category?.rawValue ?? JobCategory.dev.rawValue
        
        if let pic = UIImage(named: post.writer?.userProfilePicture ?? "userProfile1") {
            self.profilePicture.image = pic
        } else {
            self.profilePicture.image = UIImage(systemName: "person")
        }
        
        self.contentsText.text = post.contents

        // DB에 이미지 파일명 정보가 있는 경우 이미지를 표시합니다.
        if let contentImageName = post.contentImage {
            // 오토 레이아웃 적용
            contentsImageView.isHidden = false
            contentsImageView.snp.makeConstraints {
                $0.height.lessThanOrEqualTo(contentsStack.snp.width)
            }

            let imgName = contentImageName
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending("/" + imgName)

            if let url = NSURL(string: localPath ?? "")?.path {
                guard FileManager.default.fileExists(atPath: url) else {
                    print(#fileID, #function, #line, " - Error: [FileManager] file does not exist. \(url)")
                    return
                }
                self.contentsImageView.image = UIImage(contentsOfFile: url)
            } else {
                print(#fileID, #function, #line, " - Error: [NSURL] can't get file path. \(contentImageName)")
            }
        }
        
        if post.isLiked ?? false {
            self.likeIcon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.likeIcon.tintColor = .red
        } else {
            self.likeIcon.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeIcon.tintColor = .black
        }
        
        self.likeCount.text = "\(post.likeCount ?? 0)"
        self.commentCount.text = "\(post.comments.count)"
    }
    
    //MARK: - 좋아요 버튼 동작
    @objc func likeBtnPressed() {
        self.likeBtnDelegate?.likeBtnPressed(of: self.post)
//        if self.post?.isLiked ?? false {
//            PostViewModel.shared.updateAPost(self.post, isLiked: false)
//        } else {
//            PostViewModel.shared.updateAPost(self.post, isLiked: true)
//        }
    }
    
    func setComponents() {
        //MARK: - 요소 정의: 상단 작성자 정보
        stack = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.alignment = .center
            return stackView
        }()
        
        writerInfoStack = {
            let stackView = UIStackView()
            
            
            stackView.axis = .horizontal
            stackView.backgroundColor = .yellow
            return stackView
        }()
        
        writerRightSideStack = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.backgroundColor = .magenta
            return stackView
        }()
        
        writerMainInfoStack = {
            let stackView = UIStackView()
            
            
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        
        profilePicture = {
            let imageView = UIImageView()
            
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = CGFloat(self.profilePictureHeight / 2)
            imageView.clipsToBounds = true
            return imageView
        }()
        
        nameLabel = {
            let label = UILabel()
            
            label.font = .systemFont(ofSize: 15, weight: .bold)
            return label
        }()
        
        writerSubInfoStack = {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        jobLabel = {
            let label = UILabel()
            
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textColor = .gray
            return label
        }()
        
        seperatorDot = {
            let label = UILabel()
            
            label.text = " ・ "
            
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textColor = .gray
            return label
        }()
        
        createdTimeLabel = {
            let label = UILabel()
            
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textColor = .gray
            return label
        }()
        
        //MARK: - 요소 정의: 중앙 글 내용
        contentsStack = {
            let stackView = UIStackView()

            stackView.axis = .vertical
            return stackView
        }()

        contentsImageView = {
            let imageView = UIImageView()

            imageView.isHidden = true
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

        contentsText = {
            let label = UILabel()
            
            label.numberOfLines = 0
            return label
        }()
        
        //MARK: - 요소 정의: 글 하단 좋아요/댓글 개수
        likeCommentStack = {
            let stackView = UIStackView()

            stackView.axis = .horizontal
            return stackView
        }()
        
        likeIcon = {
            let btn = UIButton()
            
            btn.setImage(UIImage(systemName: "heart"), for: .normal)
            btn.tintColor = .black
            
            //좋아요 동작
            btn.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
            
            return btn
        }()

        likeCount = {
            let label = UILabel()

            return label
        }()

        commentIcon = {
            let imageView = UIImageView()

            imageView.tintColor = .black
            imageView.image = UIImage(systemName: "message")
            return imageView
        }()

        commentCount = {
            let label = UILabel()


            return label
        }()
        
        // 요소 addSubView
        // 전체 영역
        self.contentView.addSubview(stack)
        
        // 상단 스택: 작성자 정보 요소
        stack.addSubview(writerInfoStack)
        
        writerInfoStack.addSubview(profilePicture)
        writerInfoStack.addSubview(writerRightSideStack)
        
        writerRightSideStack.addSubview(writerMainInfoStack)
        writerRightSideStack.addSubview(writerSubInfoStack)
        
        writerMainInfoStack.addSubview(nameLabel)
        
        writerSubInfoStack.addSubview(jobLabel)
        writerSubInfoStack.addSubview(seperatorDot)
        writerSubInfoStack.addSubview(createdTimeLabel)
        
        // 중앙 스택: 글 내용 요소
        stack.addSubview(contentsStack)

        contentsStack.addSubview(contentsImageView)
        contentsStack.addSubview(contentsText)
        
        // 하단 스택: 좋아요/댓글 개수 정보 요소
        stack.addSubview(likeCommentStack)

        likeCommentStack.addSubview(likeIcon)
        likeCommentStack.addSubview(likeCount)
        likeCommentStack.addSubview(commentIcon)
        likeCommentStack.addSubview(commentCount)
    }
    
    func setConstraints() {
        //MARK: - 오토 레이아웃: 전체
        stack.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
            
            //height?
        }
        
        //MARK: - 오토 레이아웃 - 상단: 작성자 정보
        writerInfoStack.snp.makeConstraints { make in
            make.top.equalTo(stack).offset(30)
            make.leading.equalTo(stack).offset(20)
            make.trailing.equalTo(stack).offset(-20)
            
            make.height.equalTo(40)
        }
        
        profilePicture.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(writerInfoStack)
            make.trailing.equalTo(writerRightSideStack.snp.leading).offset(-10)
            
            make.height.equalTo(profilePictureHeight)
            make.width.equalTo(profilePictureHeight)
        }
        
        writerRightSideStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(writerInfoStack)
        }
        
        // Writer Main Info
        writerMainInfoStack.snp.makeConstraints { make in
            make.top.trailing.equalTo(writerInfoStack)
            make.bottom.equalTo(writerSubInfoStack).offset(-10)
            
//            make.height.equalTo(20)
            make.width.equalTo(writerRightSideStack)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalTo(writerMainInfoStack)
        }
        
        // Writer Sub Info
        writerSubInfoStack.snp.makeConstraints { make in
            make.trailing.equalTo(writerInfoStack)
            make.bottom.equalTo(writerInfoStack).offset(-5)
            
            make.width.equalTo(writerRightSideStack)
        }
        
        jobLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(writerSubInfoStack)
            make.trailing.equalTo(seperatorDot.snp.leading)
            
            make.width.greaterThanOrEqualTo(10)
        }
        
        seperatorDot.snp.makeConstraints { make in
            make.centerY.equalTo(writerSubInfoStack)
            make.trailing.equalTo(createdTimeLabel.snp.leading)
            
            make.width.greaterThanOrEqualTo(5)
        }
        
        createdTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(writerSubInfoStack)
            
            make.width.greaterThanOrEqualTo(50)
        }
        
        //MARK: - 오토 레이아웃 - 중앙: 글 내용
        contentsStack.snp.makeConstraints { make in
            make.top.equalTo(writerInfoStack.snp.bottom).offset(12)
            make.leading.trailing.equalTo(writerInfoStack)
            make.bottom.equalTo(likeCommentStack).offset(-50)
            
//            make.height.greaterThanOrEqualTo(50)
            make.width.equalTo(writerInfoStack)
            
        }
        
        contentsImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentsStack)
            make.bottom.equalTo(contentsText.snp.top).offset(-10)
            
//            make.height.equalTo(300)
        }

        contentsText.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentsStack)
            make.bottom.equalTo(contentsStack).offset(-20)
//            make.height.greaterThanOrEqualTo(50)
        }
            
        //MARK: - 오토 레이아웃 - 하단: 좋아요/댓글 개수 정보
        likeCommentStack.snp.makeConstraints { make in
            make.leading.equalTo(stack).offset(20)
            make.trailing.equalTo(stack).offset(-20)
            make.bottom.equalTo(stack).offset(-20)
            
            make.height.equalTo(20)
        }
        
        likeIcon.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(likeCommentStack)
            make.trailing.equalTo(likeCount.snp.leading).offset(-5)

            make.height.equalTo(likeCommentStack)
            make.width.equalTo(20)
        }

        likeCount.snp.makeConstraints { make in
            make.top.bottom.equalTo(likeCommentStack)
            make.trailing.equalTo(commentIcon.snp.leading).offset(-20)

            make.height.equalTo(likeCommentStack)
            make.width.equalTo(20)
        }

        commentIcon.snp.makeConstraints { make in
            make.top.bottom.equalTo(likeCommentStack)
            make.trailing.equalTo(commentCount.snp.leading).offset(-5)

            make.height.equalTo(likeCommentStack)
            make.width.equalTo(20)
        }

        commentCount.snp.makeConstraints { make in
            make.top.bottom.equalTo(likeCommentStack)

            make.height.equalTo(likeCommentStack)
            make.width.equalTo(20)
        }
    }
    
}
