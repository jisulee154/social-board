//
//  CreateCommentView.swift
//  social-board
//
//  Created by 이지수 on 2023/09/07.
//

import UIKit
import SnapKit

import RxSwift

class CreateCommentView: UIView {
    var background: UIView!
    var stack: UIStackView!
    var profileImage: UIImageView!
    var textField: UITextField = UITextField()
    var submitBtn: UIButton = UIButton()
    
    var post: Post!
    var user = PostViewModel.shared.dummyUsers.randomElement()
    
    var disposeBag = DisposeBag()
    
    var keyboardHeight = CGFloat(0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        setComponents()
        setConstraints()
    }
    
    //MARK: - 게시글 정보
    func setPost(_ post: Post) {
        self.post = post
    }
    
    //MARK: - 구성요소 정의
    func setComponents() {
        background = {
            let view = UIView()
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            view.backgroundColor = .systemGray4
            
            return view
        }()
        
        stack = {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            return stackView
        }()
        
        profileImage = {
            let imageView = UIImageView()
            
            imageView.contentMode = .scaleAspectFill
            if let pic = UIImage(named: user?.userProfilePicture ?? "userProfile1") {
                imageView.image = pic
            } else {
                imageView.image = UIImage(systemName: "person")
            }
            
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            
            return imageView
        }()
        
        textField = {
            let textfield = UITextField()
            textfield.placeholder = "내 생각 남기기"
            
            // padding
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
            textfield.leftView = paddingView
            textfield.leftViewMode = UITextField.ViewMode.always
            
            textfield.rx.text.orEmpty
                .map {
                    $0.count > 0
                }
                .observe(on: MainScheduler.instance)
                .subscribe {
                    self.submitBtn.isEnabled = $0
                }
                .disposed(by: disposeBag)
            
            return textfield
        }()
        
        submitBtn = {
            let btn = UIButton()
            
            btn.addTarget(self, action: #selector(createComment), for: .touchUpInside)
            btn.isEnabled = false
            btn.setTitle("게시", for: .normal)
            btn.setTitleColor(.blue, for: .normal)
            btn.setTitleColor(.gray, for: .disabled)
            
            return btn
        }()
        
        
        self.addSubview(background)
        background.addSubview(stack)
        
        stack.addSubview(profileImage)
        stack.addSubview(textField)
        stack.addSubview(submitBtn)
    }
    
    //MARK: - 오토 레이아웃
    func setConstraints() {
        background.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-30)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            
        }
        
        stack.snp.makeConstraints { make in
            make.centerY.equalTo(background)
            make.height.equalTo(100)
            
            make.leading.equalTo(background).offset(20)
            make.trailing.equalTo(background).offset(-20)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.height.equalTo(stack)
            
            make.leading.equalTo(profileImage.snp.trailing)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.height.equalTo(stack)
            make.width.equalTo(40)
            
            make.trailing.equalTo(stack)
        }
    }
}

extension CreateCommentView {
    @objc func createComment() {
        let comment = Comment(createdDateTime: Date(), contents: textField.text, writtenBy: user, belongsTo: post)
        PostViewModel.shared.createComment(comment)
    }
}
