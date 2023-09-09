//
//  CommentCell.swift
//  social-board
//
//  Created by 이지수 on 2023/09/07.
//
import UIKit

class CommentCell: UITableViewCell {
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
    var contentsText = UILabel()
    
    var post: Post?
    
    //MARK: - 상수
    let profilePictureHeight: Int = 40 // 프로필 이미지 높이
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.contentView.backgroundColor = .orange
        
        setComponents()
        setConstraints()
    }

    
    //MARK: - 구성요소 정의
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

        contentsText = {
            let label = UILabel()
            
            label.numberOfLines = 0
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

        contentsStack.addSubview(contentsText)
    }
    
    //MARK: - 오토 레이아웃
    func setConstraints() {
        //MARK: - 오토 레이아웃: 전체
        stack.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
        
        //MARK: - 오토 레이아웃 - 상단: 작성자 정보
        writerInfoStack.snp.makeConstraints { make in
            make.top.leading.equalTo(stack).offset(20)
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
            
            make.height.equalTo(profilePicture)
            make.width.lessThanOrEqualTo(writerInfoStack)
        }
        
        // Writer Main Info
        writerMainInfoStack.snp.makeConstraints { make in
            make.top.trailing.equalTo(writerInfoStack)
            make.bottom.equalTo(writerSubInfoStack).offset(-10)
            
            make.height.equalTo(20)
            make.width.equalTo(writerRightSideStack)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.edges.equalTo(writerMainInfoStack)
            
            make.height.equalTo(writerMainInfoStack)
            make.width.equalTo(writerInfoStack)
        }
        
        // Writer Sub Info
        writerSubInfoStack.snp.makeConstraints { make in
            make.trailing.equalTo(writerInfoStack)
            make.bottom.equalTo(writerInfoStack).offset(-5)
            
            make.width.equalTo(writerRightSideStack)
//            make.height.equalTo(15)
        }
        
        jobLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(writerSubInfoStack)
            make.trailing.equalTo(seperatorDot.snp.leading)
            
            make.width.greaterThanOrEqualTo(10)
//            make.height.equalTo(15)
        }
        
        seperatorDot.snp.makeConstraints { make in
            make.centerY.equalTo(writerSubInfoStack)
            make.trailing.equalTo(createdTimeLabel.snp.leading)
            
            make.width.greaterThanOrEqualTo(5)
//            make.height.equalTo(15)
        }
        
        createdTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(writerSubInfoStack)
            
            make.width.greaterThanOrEqualTo(50)
//            make.height.equalTo(15)
        }
        
        //MARK: - 오토 레이아웃 - 중앙: 글 내용
        contentsStack.snp.makeConstraints { make in
            make.top.equalTo(writerInfoStack.snp.bottom).offset(20)
            make.leading.trailing.equalTo(writerInfoStack)
            make.bottom.equalTo(stack).offset(-20)
            
            make.height.greaterThanOrEqualTo(50)
            make.width.equalTo(writerInfoStack)
            
        }

        contentsText.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentsStack)
            make.bottom.equalTo(contentsStack)
            make.height.greaterThanOrEqualTo(50)
        }
    }
}

extension CommentCell {
    //MARK: - 댓글들을 보여줄 글 정보를 전달 받음
    func setComments(of post: Post) {
        self.post = post
    }
}
