//
//  CreatePostViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/08/30.
//

import UIKit
import SnapKit
import RealmSwift
import RxSwift

import SwiftUI // UI 테스트

/// 새글 쓰기 모달 화면
class CreatePostViewController: UIViewController {
    //MARK: - 화면 ui 세부 요소 선언
    var closeBtn = UIButton()
    var submitBtn = UIButton() // 업로드 버튼
    var appendImageBtn = UIButton() // 이미지 추가 버튼
    var appendImageLabel = UILabel() // 이미지 추가 place holder 메시지
    var textfield = UITextField() // 내용 작성 버튼 // place holder text 포함
    
    //MARK: - 영역별 스택 뷰 선언
    var topStackView = UIStackView() // 최상단 스택뷰 - 닫기, 업로드 버튼
    var appendImageStackView = UIStackView() // 이미지 추가 영역
    var writingStackView = UIStackView() // 글쓰기 영역
    
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        configureView()
        setConstraint()
    }
    
    //MARK: - 화면에 요소 추가
    func configureView() {
        setTopStackView()
        setAppendImageStackView()
        setWritingStackView()
        
        setCloseBtn()
        setSubmitBtn()
        setAppendImageBtn()
        setAppendImageLabel()
        setTextfield()
        
        view.addSubview(topStackView)
        view.addSubview(appendImageStackView)
        view.addSubview(writingStackView)
        
        topStackView.addSubview(closeBtn)
        topStackView.addSubview(submitBtn)

        appendImageStackView.addSubview(appendImageBtn)
        appendImageStackView.addSubview(appendImageLabel)

        writingStackView.addSubview(textfield)
    }
    
    //MARK: - 오토 레이아웃
    func setConstraint() {
        setEntireConstraint()
        setTopConstraint()
        setMiddleConstraint()
        setBottomConstraint()
    }
    
    //MARK: - 오토 레이아웃 - 전체 화면
    //상단: 상단 스택뷰(닫기,업로드)
    //중간: 이미지 추가 영역
    //하단: 글쓰기 영역
    func setEntireConstraint() {
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(20)
            make.leading.equalTo(self.view).offset(20)
            make.trailing.equalTo(self.view).offset(-20)
            make.bottom.equalTo(appendImageStackView.snp.top).offset(-20)
            
            make.height.equalTo(40)
        }
        
        appendImageStackView.snp.makeConstraints { make in
            make.leading.equalTo(topStackView)
            make.trailing.equalTo(topStackView)
            make.bottom.equalTo(writingStackView.snp.top).offset(-20)
            
            make.height.equalTo(50)
        }
        
        writingStackView.snp.makeConstraints { make in
            make.leading.equalTo(topStackView)
            make.trailing.equalTo(topStackView)
            make.bottom.lessThanOrEqualTo(self.view).offset(-100)
        }
    }
    
    //MARK: - 오토 레이아웃 - 상단 스택뷰(닫기,업로드)
    func setTopConstraint() {
        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(topStackView)
            make.leading.equalTo(topStackView).offset(10)
            
            make.width.equalTo(60)
            make.height.equalTo(topStackView.snp.height)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.centerY.equalTo(topStackView)
            make.trailing.equalTo(topStackView).offset(-10)
            
            make.width.equalTo(60)
            make.height.equalTo(topStackView.snp.height)
        }
    }
    
    //MARK: - 오토 레이아웃 - 이미지 추가 영역
    func setMiddleConstraint() {
        appendImageBtn.snp.makeConstraints { make in
            make.centerY.equalTo(appendImageStackView)
            make.leading.equalTo(appendImageStackView)
            
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        appendImageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(appendImageStackView)
            make.leading.equalTo(appendImageBtn.snp.trailing).offset(5)
        }
    }
    
    //MARK: - 오토 레이아웃 - 글쓰기 영역
    func setBottomConstraint() {
        textfield.snp.makeConstraints { make in
            make.centerY.equalTo(writingStackView)
            make.centerX.equalTo(writingStackView)
            
            make.width.equalTo(writingStackView)
            make.height.equalTo(writingStackView)
        }
    }
    
    func setTopStackView() {
        topStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.alignment = .center
//            stackView.backgroundColor = .yellow
            
            return stackView
        }()
    }
    
    func setAppendImageStackView() {
        appendImageStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.alignment = .center
//            stackView.backgroundColor = .green
            
            return stackView
        }()
    }
    
    func setWritingStackView() {
        writingStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.alignment = .center
//            stackView.backgroundColor = .blue
            
            return stackView
        }()
    }
    
    func setCloseBtn() {
        closeBtn = {
            let btn = UIButton()
            
            btn.setTitle("닫기", for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.contentHorizontalAlignment = .left
            btn.addTarget(self, action: #selector(backToSocialViewController), for: .touchUpInside) // 현재 화면 닫기
            
            return btn
        }()
    }
    func setSubmitBtn() {
        submitBtn = {
            let btn = UIButton()
            
            btn.setTitle("업로드", for: .normal)
            btn.setTitleColor(UIColor.gray, for: .disabled)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.contentHorizontalAlignment = .right
            btn.isEnabled = false
            
            btn.addTarget(self, action: #selector(submitPost), for: .touchUpInside)
            
            return btn
        }()
    }
    func setAppendImageBtn() {
        appendImageBtn = {
            var btn = UIButton()
            
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.filled()
                config.image = UIImage(systemName: "plus.square.dashed")
                config.buttonSize = .large
                config.baseBackgroundColor = .clear
                config.baseForegroundColor = .black
                config.imagePadding = 0
                
                btn = UIButton(configuration: config)
            } else {
                // Fallback on earlier versions
                
                btn.setImage(UIImage(systemName: "plus.square.dashed"), for: .normal)
                btn.imageView?.tintColor = .black
            }
        
            
//            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return btn
        }()
    }
    func setAppendImageLabel() {
        appendImageLabel = {
            let label = UILabel()
            
            label.text = "이미지 추가"
            label.textColor = .gray
            return label
        }()
    }
    func setTextfield() {
        textfield =
        {
            let textfield = UITextField()
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.attributedPlaceholder = NSAttributedString(string: "나누고 싶은 생각을 공유해 보세요!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
            
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
    }
    
}


extension CreatePostViewController {
    //MARK: - 화면 전환(닫기)
    @objc func backToSocialViewController() {
        self.dismiss(animated: true)
    }
    
    //MARK: - 새글 쓰기
    @objc func submitPost() {
        let contents = self.textfield.text ?? ""
//        let dummyUser = postViewModel.dummyUsers.randomElement()
        let dummyUser = PostViewModel.shared.dummyUsers.randomElement()
        let dummyLikeCount = (0...10).randomElement()
        let dummyCommentCount = (0...10).randomElement()
        let post = Post(contents: contents, likeCount: dummyLikeCount, commentCount: dummyCommentCount, writer: dummyUser)
        PostViewModel.shared.createPost(with: post) //onNext
        self.dismiss(animated: true)
    }
    
    //MARK: - 이미지 추가
    @objc func selectContentImage() {
        
        
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

struct PreView: PreviewProvider{
    static var previews: some View {
        CreatePostViewController().toPreview()
    }
}

#if DEBUG
extension CreatePostViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: CreatePostViewController
        
        func makeUIViewController(context: Context) -> CreatePostViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: CreatePostViewController, context: Context) {
        }
    }
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
