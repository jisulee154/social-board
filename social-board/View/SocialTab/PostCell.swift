//
//  PostCell.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit
import RxCocoa
import RxSwift
import Photos
import RealmSwift

//MARK: - 셀에서의 화면전환을 위한 프로토콜
protocol CellPresentProtocol {
    func presentToDetail(of post: Post)
}

class PostCell: UITableViewCell {
    var post: Post?
    let disposeBag = DisposeBag()
    
    var delegate: CellPresentProtocol?
    
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
    
    var likeCountIcon = UIButton()
    var likeCountLabel = UILabel()
    var commentCountIcon = UIImageView()
    var commentCountLabel = UILabel()
    
    //MARK: - 더보기 기능 관련
    var isExpanded: Bool = false
    
    //MARK: - 상수
    let maxCharNum: Int = 150 // 글목록에서 보여주는 최대길이 (더보기 미적용)
    let profilePictureHeight: Int = 40 // 프로필 이미지 높이
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = ""
        self.jobLabel.text = ""
        self.createdTimeLabel.text = ""
        
        self.contentsImage.isHidden = true
        self.contentsImage.image = nil
        self.contentsText.text = ""
        self.likeCountLabel.text = ""
        self.commentCountLabel.text = ""
    }
}

extension PostCell {
    //MARK: - Post 내용 설정
    func setPost(_ post: Post) {
        self.post = post
        
        self.createdTimeLabel.text = post.createdDateTime?.description ?? ""
        self.nameLabel.text = post.writer?.userName ?? "익명"
        self.jobLabel.text = post.writer?.job?.category?.rawValue ?? JobCategory.dev.rawValue
        
        if let pic = UIImage(named: post.writer?.userProfilePicture ?? "userProfile1") {
            self.profilePicture.image = pic
        } else {
            self.profilePicture.image = UIImage(systemName: "person")
        }
        
        self.contentsText.text = post.contents
        self.isExpanded = post.expanded ?? false
        
        // 보여주는 라인 수 결정
        setContentsTextMaxNumLines()
        
        // 더보기 버튼 표시 결정
        setContentsMoreShowing()
        
        // DB에 이미지 파일명 정보가 있는 경우 이미지를 표시합니다.
        if let contentImageName = post.contentImage {
            // 오토 레이아웃 적용
            contentsImage.isHidden = false
            contentsImage.snp.makeConstraints {
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
                self.contentsImage.image = UIImage(contentsOfFile: url)
            } else {
                print(#fileID, #function, #line, " - Error: [NSURL] can't get file path. \(contentImageName)")
            }
        }
        
        //좋아요 선택 상태
        if let isLiked = post.isLiked {
            if isLiked {
                likeCountIcon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeCountIcon.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
//        self.likeCountLabel.text = "\(post.likeCount ?? 0)"
//        self.commentCountLabel.text = "\(post.commentCount ?? 0)"
    }
    
//    //MARK: - Rx Bind
//    func bind(_ post: Post) {
//        self.post = post
//    }
    
    /// 셀에서 '더보기' 버튼을 표시할지 결정합니다.
    func setContentsMoreShowing() {
        let charNum = self.contentsText.text?.count ?? 0
        if charNum > maxCharNum && !self.isExpanded {
            // 긴글이며, 더보기 기능이 활성화 안되었을 때는 '더보기' 버튼을 표시합니다.
            self.contentsMore.isHidden = false
        } else {
            self.contentsMore.isHidden = true
        }
    }
    
    /// 글 목록에서 보여줄 줄 수를 결정합니다.
    /// '더보기' 선택
    /// --> 0 (제한 없음)
    /// '더보기' 미선택
    /// --> 5 (최대 다섯줄)
    func setContentsTextMaxNumLines() {
        self.contentsText.numberOfLines = isExpanded ? 0 : 5
    }
    
    //MARK: - 더보기 적용
    /// 더보기: 접힌 글 내용을 전부 표시합니다.
    @objc func expandContents() {
        guard let post = self.post else {
            print(#fileID, #function, #line, " - 더보기 Error: \(String(describing: post))")
            return
        }
        PostViewModel.shared.updatePost(post, expanded: true)
    }
    
    //MARK: - 화면 전환 (-> 글 상세보기)
    @objc func goToDetail() {
        self.delegate?.presentToDetail(of: self.post!)
    }
    
    //MARK: - 좋아요 버튼 동작
    @objc func likeBtnPressed() {
        print(#fileID, #function, #line, " - like btn is pressed.")
        
    }
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
            make.width.equalTo(profilePictureHeight)
            make.height.equalTo(profilePictureHeight)
        }
    }
    
    //MARK: - 오토 레이아웃: Right Stack
    // 닉네임 + subStack
    func setRightStackConstraint() {
        
        rightStack.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.top)
            make.leading.equalTo(profilePicture.snp.trailing).offset(10)
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
//            if let contentsImage = contentsImage.image {
//                make.height.equalTo(contentsStack.snp.width)
//            } else {
//                make.height.equalTo(0)
//            }
            make.top.equalTo(contentsStack)
            make.bottom.equalTo(contentsText.snp.top).offset(-20) //??
            make.leading.equalTo(contentsStack)
            
            make.width.equalTo(contentsStack)
        }
        
        contentsText.snp.makeConstraints { make in
//            if let contentsImage = contentsImage.image {
//                make.top.equalTo(contentsStack).offset(20)
//            } else {
//                make.top.equalTo(contentsImage.snp.bottom).offset(20)
//            }
            make.top.equalTo(contentsImage.snp.bottom).offset(20)
            make.leading.equalTo(contentsStack.snp.leading)
            make.bottom.equalTo(contentsStack.snp.bottom).offset(-50) // 더보기 버튼을 위한 여백
            make.trailing.equalTo(contentsStack.snp.trailing)
            
            //            make.height.greaterThanOrEqualTo(50)
        }
        
        contentsMore.snp.makeConstraints { make in
            make.trailing.equalTo(contentsStack)
            make.bottom.equalTo(contentsStack).offset(-5)
            
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
            
            make.width.equalTo(40)
            make.height.equalTo(likeCommentStack)
        }
        
        commentCountStack.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack)
            make.leading.equalTo(likeCountStack.snp.trailing).offset(20)
//            make.trailing.lessThanOrEqualTo(likeCommentStack)
            
            make.width.equalTo(40)
            make.height.equalTo(likeCommentStack)
        }
        
        likeCountIcon.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(likeCountStack.snp.leading)
            
//            make.width.equalTo(15)
            
            make.height.equalTo(likeCommentStack.snp.height)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(likeCountIcon.snp.trailing).offset(5)
            
//            make.width.equalTo(20)
            
            make.height.equalTo(likeCommentStack)
        }
        
        commentCountIcon.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(commentCountStack.snp.leading)
            
//            make.width.equalTo(20)
            make.height.equalTo(likeCommentStack)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeCommentStack.snp.top)
            make.leading.equalTo(commentCountIcon.snp.trailing).offset(5)
//                        make.width.equalTo(15)
            
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
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = CGFloat(self.profilePictureHeight / 2)
            imageView.clipsToBounds = true
            
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
            
            imageView.isHidden = true
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
            btn.setTitle("더보기", for: .normal)
            btn.setTitleColor(.link, for: .normal)
            
            btn.addTarget(self, action: #selector(expandContents), for: .touchUpInside)
            return btn
        }()
    }
    
    //MARK: - Cell 구성 요소 정의 - 좋아요/코멘트
    func setLikeCommentStack() {
        likeCommentStack = {
            let stack = UIStackView()
            
            stack.axis = .horizontal
            stack.alignment = .center
//            stack.backgroundColor = .yellow
            
            return stack
        }()
    }
    
    func setLikeCountStack() {
        likeCountStack = {
            let stack = UIStackView()
            
            stack.axis = .horizontal
            stack.alignment = .center
//            stack.backgroundColor = .blue
            
            return stack
        }()
    }
    
    func setCommentCountStack() {
        commentCountStack = {
            let stack = UIStackView()
            
//            stack.backgroundColor = .green
            stack.axis = .horizontal
            stack.alignment = .center
            
            /// 탭 제스처 정의
            /// 적용: 코멘트 정보 영역 클릭시 글 상세보기로 전환
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToDetail))

            stack.addGestureRecognizer(tapGesture)
            stack.isUserInteractionEnabled = true
            
            return stack
        }()
    }
    
    func setLikeCountIcon() {
        likeCountIcon = {
            let btn = UIButton()
            
            btn.setImage(UIImage(systemName: "heart"), for: .normal)
            btn.tintColor = .black
            btn.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
            return btn
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
            
//                        imageView.backgroundColor = .magenta
            imageView.tintColor = .black
            imageView.image = UIImage(systemName: "message")
            return imageView
        }()
    }
    
    func setCommentCountLabel() {
        commentCountLabel = {
            let label = UILabel()
//            label.backgroundColor = .magenta
        
            return label
        }()
    }
}
