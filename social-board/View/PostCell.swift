//
//  PostCell.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit
import RxCocoa
import RxSwift

class PostCell: UITableViewCell {
    var post: Post?
    var postViewModel = PostViewModel()
    let disposeBag = DisposeBag()
    
    var isFirstPost: Bool = false
    
    //MARK: - 전체 영역
    var stack = UIStackView()               // 전체 통합
    
    //MARK: - 셀 상단 작성자 정보 영역
    var profilePicture = UIImageView()      // 작성자 사진
    var nameLabel = UILabel()               // 작성자 닉네임
    var jobLabel = UILabel()                // 작성자 직종
    var seperatorDot = UILabel()            // 구분자
    var createdTimeLabel = UILabel()        // 작성 시간
    
    var subStack = UIStackView()            // 직종 + 시간 //HStack
    var rightStack = UIStackView()          // subInfoStack + nameStack //VStack
    var writerInfoStack = UIStackView()     // profileStack + rightStack //HStack

    //MARK: - 셀 중앙 내용 영역
    var contentsStack = UIStackView()       //vstack
    var contentsImage = UIImageView()       // 내용(사진)
    
    var contentsText = UILabel()            // 내용(글)
    var contentsMore = UIButton()           // 내용 더보기 버튼
    
    //MARK: - 셀 하단 코멘트/좋아요 영역
    var likeCommentStack = UIStackView()    // 좋아요/코멘트 영역 스택 hstack
    var likeCountStack = UIStackView()      // 좋아요 스택(아이콘+숫자)
    var commentCountStack = UIStackView()   // 코멘트 스택(아이콘+숫자)
    
    var likeCountIcon = UIImageView()
    var likeCountLabel = UILabel()
    var commentCountIcon = UIImageView()
    var commentCountLabel = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        postViewModel.isFirstPost
//            .subscribe{
//                self.isFirstPost = $0
//                print(#fileID, #function, #line, " - isFirstPost", self.isFirstPost)
//            }
//            .disposed(by: disposeBag)
//
//        if isFirstPost {
//            configureWritingCell()
//            setWritingCellConstraint()
//        } else {
            configureCell()
            setConstraint()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = ""
        self.jobLabel.text = ""
        self.createdTimeLabel.text = ""
        
        self.contentsText.text = ""
        self.likeCountLabel.text = ""
        self.commentCountLabel.text = ""
    }

}

//MARK: - Post 내용 설정
extension PostCell {
    func setPost(_ post: Post) {
        self.post = post
        
//        getProfilePicture(with: "https://random.dog/5350-13889-29214.jpg")
//        self.profilePicture.image = UIImage(named: "pencil-solid-small")
//        self.nameLabel.text = post.writerID?.userName
//        self.jobLabel.text = post.writer?.userJob?.rawValue
//        self.createdTimeLabel.text = post.createdDateTime?.description
        
//        self.contentsImage.image = post.contentImage
//        self.contentsText.text = post.contents
        self.contentsMore.titleLabel?.text = "더보기"
        
//        self.likeCountLabel.text = "\(post.likeCount!)"
//        self.commentCountLabel.text = "\(post.commentCount!)"
    }
    
    // profile 사진 받아오기
    func getProfilePicture(with source: String){
        let disposeBag = DisposeBag()
        
        if let url = URL(string: source) {
            URLSession.shared.rx
                .response(request: URLRequest(url: url))
                .map({ (_, data) in
                    UIImage(data: data)
                })
                .subscribe {
                    self.profilePicture.image = $0
                }
                .disposed(by: disposeBag)
        }
    }
    
//        if let url = URL(string: source) {
//            let request = URLRequest(url: url)
//
//            let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if error != nil {
//                    print(#fileID, #function, #line, " - URLSession Error: ", error)
//                }
//
//                let decoder = JSON
//            }
//
//            session.resume()
//        }
    
}

//MARK: - 요소 정의 호출
extension PostCell {
    func configureCell() {
        // 전체
        setStack()
        
        // 작성자 정보 영역
        setWriterInfoStack()
        setRightStack()
        setSubStack()
        
        setProfilePicture()
        setNameLabel()
        setJobLabel()
        setCreatedTimeLabel()
        setSeperatorDot()
        
        
        // 내용 영역
        setContentsStack()
        
        setContentImage()
        setContentsText()
        setContentsMore()
        
        // 좋아요/코멘트
        setLikeCommentStack()
        setLikeCountStack()
        setCommentCountStack()
        
        setLikeCountIcon()
        setLikeCountLabel()
        setCommentCountIcon()
        setCommentCountLabel()
    }
    
    func setConstraint() {
        // 전체
        contentView.addSubview(stack)
        
        setAllConstraint()
        
        stack.addSubview(writerInfoStack)
        stack.addSubview(contentsStack)
        stack.addSubview(likeCommentStack)
        
        // 작성자 정보
        writerInfoStack.addSubview(profilePicture)
        writerInfoStack.addSubview(rightStack)

        rightStack.addSubview(nameLabel)
        rightStack.addSubview(subStack)

        subStack.addSubview(jobLabel)
        subStack.addSubview(seperatorDot)
        subStack.addSubview(createdTimeLabel)

        setWriterInfoStackConstraint()
        setRightStackConstraint()
        setSubStackConstraint()

        // 내용
        contentsStack.addSubview(contentsImage)
        contentsStack.addSubview(contentsText)
        contentsStack.addSubview(contentsMore)

        setContentsStackConstraint()

        // 좋아요/코멘트
        likeCommentStack.addSubview(likeCountStack)
        likeCommentStack.addSubview(commentCountStack)

        likeCountStack.addSubview(likeCountIcon)
        likeCountStack.addSubview(likeCountLabel)

        commentCountStack.addSubview(commentCountIcon)
        commentCountStack.addSubview(commentCountLabel)

        setLikeCommentStackConstraint()
        
    }
    
    
    //MARK: - 오토 레이아웃: 셀 전체
    func setAllConstraint() {
        stack.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
    
    //MARK: - 오토 레이아웃: WriterInfoStack
    // 작성자 정보 영역
    // 프로필 사진 + RightStack
    func setWriterInfoStackConstraint() {
        
        writerInfoStack.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.top).offset(15)
            make.leading.equalTo(stack.snp.leading).offset(20)
            make.trailing.equalTo(stack.snp.trailing).offset(-20)
            make.bottom.equalTo(contentsStack.snp.top).offset(-15)
            make.height.equalTo(40)
//            make.edges.equalTo(stack).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        profilePicture.snp.makeConstraints { make in
            make.top.equalTo(writerInfoStack.snp.top)
            make.leading.equalTo(writerInfoStack.snp.leading)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    //MARK: - 오토 레이아웃: Right Stack
    // 닉네임 + subStack
    func setRightStackConstraint() {
        
        rightStack.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.top)
            make.leading.equalTo(profilePicture.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(profilePicture.snp.bottom)
            
            make.height.equalTo(profilePicture.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(rightStack.snp.top)
            make.leading.equalTo(rightStack.snp.leading)
            make.trailing.equalTo(rightStack.snp.trailing)
            
            make.width.greaterThanOrEqualTo(50)
            make.height.lessThanOrEqualTo(20)
        }
    }
    
    //MARK: - 오토 레이아웃: subStack
    // 직종 + 작성시간
    func setSubStackConstraint() {
        subStack.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(rightStack.snp.bottom)
            
            make.leading.equalTo(rightStack.snp.leading)
            make.trailing.equalTo(rightStack.snp.trailing)
            make.height.equalTo(20)
        }
        
        jobLabel.snp.makeConstraints { make in
            make.centerY.equalTo(subStack.snp.centerY)
            make.leading.equalTo(subStack.snp.leading)
            
            make.width.greaterThanOrEqualTo(20)
        }
        
        seperatorDot.snp.makeConstraints { make in
            make.centerY.equalTo(subStack.snp.centerY)
            make.leading.equalTo(jobLabel.snp.trailing)
            
            make.width.greaterThanOrEqualTo(5)
        }
        
        createdTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(subStack.snp.centerY)
            make.leading.equalTo(seperatorDot.snp.trailing)
            
            make.width.greaterThanOrEqualTo(50)
        }
    }
    
    
    //MARK: - 오토 레이아웃: 내용
    func setContentsStackConstraint() {
        contentsStack.snp.makeConstraints { make in
//            make.top.equalTo(self.contentView.snp.top).offset(55)
            make.top.equalTo(writerInfoStack.snp.bottom).offset(15)
//            make.bottom.equalTo(likeCommentStack.snp.top).offset(-10)
            make.leading.equalTo(writerInfoStack)
            make.trailing.equalTo(writerInfoStack)
            
//            make.height.greaterThanOrEqualTo(50)
        }
        
        contentsImage.snp.makeConstraints { make in
            make.top.equalTo(contentsStack)
//            make.bottom.equalTo(contentsText.snp.top).offset(-20)
            make.leading.equalTo(contentsStack)
            
            make.width.equalTo(contentsStack)
//            make.height.greaterThanOrEqualTo(50)
        }
        
        contentsText.snp.makeConstraints { make in
            make.top.equalTo(contentsImage.snp.bottom).offset(20)
            make.leading.equalTo(contentsStack.snp.leading)
            make.bottom.equalTo(contentsStack.snp.bottom).offset(-50) // 더보기 버튼을 위한 여백
            make.trailing.equalTo(contentsStack.snp.trailing)
            
//            make.height.greaterThanOrEqualTo(50)
        }
        
        contentsMore.snp.makeConstraints { make in
            make.trailing.equalTo(contentsStack.snp.trailing)
            make.bottom.equalTo(contentsStack.snp.bottom)
            
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
    }
    
    //MARK: - 오토 레이아웃: 좋아요/코멘트
    func setLikeCommentStackConstraint() {
        likeCommentStack.snp.makeConstraints { make in
            make.top.equalTo(contentsStack.snp.bottom)
            make.bottom.equalTo(stack.snp.bottom).offset(-20)
            make.leading.equalTo(contentsStack.snp.leading)
            make.trailing.equalTo(contentsStack.snp.trailing)
            
//            make.height.lessThanOrEqualTo(30)
        }
        
        likeCountStack.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(likeCommentStack.snp.leading)
            
            make.width.lessThanOrEqualTo(40)
        }
        
        commentCountStack.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack)
            make.leading.equalTo(likeCountStack.snp.trailing).offset(20)
            make.trailing.equalTo(likeCommentStack)
            
//            make.width.lessThanOrEqualTo(40)
        }
        
        likeCountIcon.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(likeCountStack.snp.leading)
            
//            make.width.equalTo(20)
            make.height.equalTo(likeCommentStack.snp.height)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(likeCountIcon.snp.trailing).offset(5)
//            make.width.equalTo(30)
            
            make.height.equalTo(likeCommentStack.snp.height)
        }
        
        commentCountIcon.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(commentCountStack.snp.leading)
            
            make.width.equalTo(20)
            make.height.equalTo(likeCommentStack.snp.height)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(commentCountIcon.snp.trailing).offset(5)
//            make.width.equalTo(30)
            
            make.height.equalTo(likeCommentStack.snp.height)
        }
    }
}

//MARK: - Cell 구성 요소들 정의
extension PostCell {
    //MARK: - Cell Stack 요소 정의
    func setStack(){
        stack = {
            let stack = UIStackView()
            
            stack.axis = .vertical
            stack.alignment = .center
//            stack.backgroundColor = .red
            return stack
        }()
    }
    
    //MARK: - Cell 구성 요소 정의- 작성자 정보
    func setProfilePicture() {
        profilePicture = {
            let imageView = UIImageView()
            
            imageView.image = UIImage(systemName: "person.crop.circle")
            
            return imageView
        }()
    }
    
    func setNameLabel() {
        nameLabel = {
            let label = UILabel()
            
            label.font = .systemFont(ofSize: 15, weight: .bold)
            return label
        }()
    }
    
    func setJobLabel() {
        jobLabel = {
            let label = UILabel()
            
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textColor = .gray
            return label
        }()
    }
    
    func setCreatedTimeLabel() {
        createdTimeLabel = {
            let label = UILabel()
            
            label.font = .systemFont(ofSize: 10, weight: .regular)
            label.textColor = .gray
            return label
        }()
    }
    
    func setSeperatorDot() {
        seperatorDot = {
            let label = UILabel()
            label.text = "・"

            label.font = .systemFont(ofSize: 10, weight: .regular)
            return label
        }()
    }
    func setSubStack() {
        subStack = {
            let stack = UIStackView()
            
            stack.axis = .horizontal
            stack.alignment = .center
//            stack.backgroundColor = .orange
            return stack
        }()
    }
    
    func setRightStack() {
        rightStack = {
            let stack = UIStackView()
            
            stack.axis = .vertical
            stack.alignment = .center
//            stack.backgroundColor = .systemIndigo
            return stack
        }()
    }
    
    func setWriterInfoStack() {
        writerInfoStack = {
            let stack = UIStackView()
            
            stack.axis = .vertical
            stack.alignment = .center
            stack.backgroundColor = .white
            
            return stack
        }()
    }
    
    //MARK: - Cell 구성 요소 정의 - 내용
    func setContentsStack() {
        contentsStack = {
            let stack = UIStackView()
            
            stack.axis = .vertical
            stack.alignment = .center
            
            return stack
        }()
    }
    
    func setContentImage() {
        contentsImage = {
            let imageView = UIImageView()
            
            imageView.backgroundColor = .darkGray
            imageView.image = UIImage(systemName: "star")
            imageView.contentMode = .scaleAspectFit
            
            return imageView
        }()
    }
    
    func setContentsText() {
        contentsText = {
            let label = UILabel()
            
            label.backgroundColor = .white
            
            label.numberOfLines = 0
            label.lineBreakMode = .byTruncatingTail
//            label.font = .systemFont(ofSize: 10, weight: .regular)
            return label
        }()
    }
    
    func setContentsMore() {
        contentsMore = {
            let btn = UIButton()
            
            btn.backgroundColor = .magenta
            return btn
        }()
    }
    
    //MARK: - Cell 구성 요소 정의 - 좋아요/코멘트
    func setLikeCommentStack() {
        likeCommentStack = {
            let stack = UIStackView()
            
            stack.axis = .horizontal
            stack.alignment = .center
            stack.backgroundColor = .green
            
            return stack
        }()
    }
    
    func setLikeCountStack() {
        likeCountStack = {
            let stack = UIStackView()
            
            stack.axis = .horizontal
            stack.alignment = .center
            
            return stack
        }()
    }
    
    func setCommentCountStack() {
        commentCountStack = {
            let stack = UIStackView()
            
            stack.axis = .horizontal
            stack.alignment = .center
            
            return stack
        }()
    }
    
    func setLikeCountIcon() {
        likeCountIcon = {
            let imageView = UIImageView()
            
            imageView.backgroundColor = .white
            imageView.image = UIImage(systemName: "heart")
            
            return imageView
        }()
    }
    
    func setLikeCountLabel() {
        likeCountLabel = {
            let label = UILabel()
            
            return label
        }()
    }
    
    func setCommentCountIcon() {
        commentCountIcon = {
            let imageView = UIImageView()
            
            imageView.backgroundColor = .white
            imageView.image = UIImage(systemName: "message")
            
            return imageView
        }()
    }
    
    func setCommentCountLabel() {
        commentCountLabel = {
            let label = UILabel()
            
            return label
        }()
    }
}
