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
    
    var profilePicture = UIImageView()      // 작성자 사진
    var nameLabel = UILabel()               // 작성자 닉네임
    var jobLabel = UILabel()                // 작성자 직종
    var createdTimeLabel = UILabel()        // 작성 시간
    
    var subStack = UIStackView()            // 직종 + 시간 //HStack
    var rightStack = UIStackView()          // subInfoStack + 닉네임 //VStack
    var stack = UIStackView()               // 사진 + rightStack //HStack

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        setSubStackConstraint()
        setRightStackConstraint()
        setStackConstraint()
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
        self.profilePicture.image = UIImage(named: "pencil-solid-small")
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
    //MARK: - 오토 레이아웃: subStack(직종 + 작성시간)
    func setSubStackConstraint() {
        subStack.translatesAutoresizingMaskIntoConstraints          = false
        jobLabel.translatesAutoresizingMaskIntoConstraints          = false
        createdTimeLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        
        NSLayoutConstraint.activate([
            subStack.topAnchor.constraint(equalTo: rightStack.topAnchor, constant: 30),
            subStack.trailingAnchor.constraint(equalTo: rightStack.trailingAnchor, constant: -10),
            subStack.leadingAnchor.constraint(equalTo: rightStack.leadingAnchor, constant: 10),
            subStack.widthAnchor.constraint(equalToConstant: 300),
            subStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //MARK: - 오토 레이아웃: 직종, 작성시간
        NSLayoutConstraint.activate([
            jobLabel.topAnchor.constraint(equalTo: subStack.topAnchor, constant: 0),
            jobLabel.bottomAnchor.constraint(equalTo: subStack.bottomAnchor, constant: 0),
            jobLabel.leadingAnchor.constraint(equalTo: subStack.leadingAnchor, constant: 0),
            jobLabel.widthAnchor.constraint(equalToConstant: 50),
            jobLabel.heightAnchor.constraint(equalToConstant: 20),
            
            createdTimeLabel.leadingAnchor.constraint(equalTo: jobLabel.trailingAnchor, constant: 5),
            createdTimeLabel.trailingAnchor.constraint(equalTo: subStack.trailingAnchor, constant: -20),
            createdTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            createdTimeLabel.centerYAnchor.constraint(equalTo: jobLabel.centerYAnchor)
            ])
        
//        NSLayoutConstraint.activate([
//            jobLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            jobLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            jobLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            jobLabel.widthAnchor.constraint(equalToConstant: 50),
//            jobLabel.heightAnchor.constraint(equalToConstant: 20),
//
//            createdTimeLabel.leadingAnchor.constraint(equalTo: jobLabel.trailingAnchor, constant: 10),
//            createdTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
//            createdTimeLabel.heightAnchor.constraint(equalToConstant: 20),
//            createdTimeLabel.centerYAnchor.constraint(equalTo: jobLabel.centerYAnchor)
//            ])
    }
    
    //MARK: - 오토 레이아웃: Right Stack (닉네임 + subStack)
    func setRightStackConstraint() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: rightStack.topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: rightStack.leadingAnchor, constant: 10),
            
            subStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -5),
            subStack.bottomAnchor.constraint(equalTo: rightStack.bottomAnchor, constant: -10),
            
            rightStack.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 5),
            rightStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - 오토 레이아웃: Stack (사진 + Right Stack)
    func setStackConstraint() {
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            profilePicture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profilePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profilePicture.widthAnchor.constraint(equalToConstant: 50),
            profilePicture.heightAnchor.constraint(equalToConstant: 50),
            
            rightStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),
            
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configureCell() {
        setProfilePicture()
        setNameLabel()
        setJobLabel()
        setCreatedTimeLabel()
        
        setSubStack()
        setRightStack()
        setStack()
        
        contentView.addSubview(stack)
        
        stack.addSubview(profilePicture)
        stack.addSubview(rightStack)
        
        rightStack.addSubview(nameLabel)
        rightStack.addSubview(subStack)
        
        subStack.addSubview(jobLabel)
        subStack.addSubview(createdTimeLabel)
        
    }
}

//MARK: - Cell 구성 요소들
extension PostCell {
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
            
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    }
    
    func setJobLabel() {
        jobLabel = {
            let label = UILabel()
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 12, weight: .thin)
            return label
        }()
    }
    
    func setCreatedTimeLabel() {
        createdTimeLabel = {
            let label = UILabel()
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 12, weight: .thin)
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
            stack.alignment
            stack.backgroundColor = .yellow
            
            return stack
        }()
    }
}
