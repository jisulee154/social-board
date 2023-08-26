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
    
    //MARK: - 셀 상단 작성자 정보 스택
    var profilePicture = UIImageView()      // 작성자 사진
    var nameLabel = UILabel()               // 작성자 닉네임
    var jobLabel = UILabel()                // 작성자 직종
    var seperatorDot = UILabel()            // 구분자
    var createdTimeLabel = UILabel()        // 작성 시간
    
    var subStack = UIStackView()            // 직종 + 시간 //HStack
    var rightStack = UIStackView()          // subInfoStack + nameStack //VStack
    var stack = UIStackView()               // profileStack + rightStack //HStack

    //MARK: - 셀 중앙 컨텐츠 스택
    
    //MARK: - 셀 하단 코멘트/좋아요 스택
    
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
    }

}

//MARK: - Post 내용 설정
extension PostCell {
    func setPost(_ post: Post) {
        self.post = post
        
//        getProfilePicture(with: "https://random.dog/5350-13889-29214.jpg")
//        self.profilePicture.image = UIImage(named: "pencil-solid-small")
        self.nameLabel.text = post.writer?.userName
        self.jobLabel.text = post.writer?.userJob?.rawValue
        self.createdTimeLabel.text = post.createdDateTime?.description
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

//MARK: - 오토 레이아웃
extension PostCell {
    func configureCell() {
        setProfilePicture()
        setNameLabel()
        setJobLabel()
        setCreatedTimeLabel()
        setSeperatorDot()
        
        setSubStack()
        setRightStack()
        setStack()
    }
    
    func setConstraint() {
        contentView.addSubview(stack)
        
        stack.addSubview(profilePicture)
        stack.addSubview(rightStack)
        
        rightStack.addSubview(nameLabel)
        rightStack.addSubview(subStack)
        
        subStack.addSubview(jobLabel)
        subStack.addSubview(seperatorDot)
        subStack.addSubview(createdTimeLabel)
        
        setStackConstraint()
        setRightStackConstraint()
        setSubStackConstraint()
    }
    
    //MARK: - 오토 레이아웃: Stack (사진 + Right Stack)
    func setStackConstraint() {
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        profilePicture.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.top).offset(10)
            make.leading.equalTo(stack.snp.leading).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    //MARK: - 오토 레이아웃: Right Stack (닉네임 + subStack)
    func setRightStackConstraint() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        rightStack.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.top)
            make.leading.equalTo(profilePicture.snp.trailing).offset(10)
            make.trailing.greaterThanOrEqualTo(contentView.snp.trailing).offset(-10)
            make.height.greaterThanOrEqualTo(profilePicture.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(rightStack.snp.top)
            make.leading.equalTo(rightStack.snp.leading)
            make.trailing.greaterThanOrEqualTo(rightStack.snp.trailing)
            make.width.greaterThanOrEqualTo(50)
            make.height.lessThanOrEqualTo(20)
        }
    }
    
    //MARK: - 오토 레이아웃: subStack(직종 + 작성시간)
    func setSubStackConstraint() {
        subStack.translatesAutoresizingMaskIntoConstraints          = false
        jobLabel.translatesAutoresizingMaskIntoConstraints          = false
        createdTimeLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        subStack.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalTo(rightStack.snp.bottom)
            
            make.leading.equalTo(rightStack.snp.leading)
            make.trailing.greaterThanOrEqualTo(rightStack.snp.trailing)
            make.height.lessThanOrEqualTo(20)
        }
        
        //MARK: - 오토 레이아웃: 직종, 작성시간
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
}

//MARK: - Cell 구성 요소들
extension PostCell {
    func setProfilePicture() {
        profilePicture = {
            let imageView = UIImageView()
            
            imageView.backgroundColor = .white
            imageView.image = UIImage(systemName: "person.crop.circle")
            
            return imageView
        }()
    }
    
    func setNameLabel() {
        nameLabel = {
            let label = UILabel()
            
            label.backgroundColor = .green
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 15, weight: .bold)
            return label
        }()
    }
    
    func setJobLabel() {
        jobLabel = {
            let label = UILabel()
            
            jobLabel.backgroundColor = .brown
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 10, weight: .regular)
            return label
        }()
    }
    
    func setCreatedTimeLabel() {
        createdTimeLabel = {
            let label = UILabel()
            
            createdTimeLabel.backgroundColor = .cyan
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 10, weight: .regular)
            return label
        }()
    }
    
    func setSeperatorDot() {
        seperatorDot = {
            let label = UILabel()
            label.text = "・"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 10, weight: .regular)
            return label
        }()
    }
    func setSubStack() {
        subStack = {
            let stack = UIStackView()
            
            stack.axis = .horizontal
            stack.alignment = .center
            stack.backgroundColor = .orange
            return stack
        }()
    }
    
    func setRightStack() {
        rightStack = {
            let stack = UIStackView()
            
            stack.axis = .vertical
            stack.alignment = .center
            stack.backgroundColor = .systemIndigo
            return stack
        }()
    }
    
    func setStack() {
        stack = {
            let stack = UIStackView()
            
            stack.axis = .vertical
            stack.alignment = .center
//            stack.backgroundColor = .yellow
            
            return stack
        }()
    }
}
