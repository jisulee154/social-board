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
import Photos

/// 새글 쓰기 모달 화면
class CreatePostViewController: UIViewController {
    //MARK: - 화면 ui 세부 요소 선언
    var closeBtn = UIButton()
    var submitBtn = UIButton() // 업로드 버튼
    var appendImageBtn = UIButton() // 이미지 추가 버튼
    var appendImageLabel = UILabel() // 이미지 추가 안내 메시지 place holder
    var imageView = UIImageView() // 선택한 이미지 표시
    var textView = UITextView() // 내용 작성 버튼 // place holder text 포함
    
    //MARK: - 영역별 스택 뷰 선언
    var topStackView = UIStackView() // 최상단 스택뷰 - 닫기, 업로드 버튼
    var appendImageStackView = UIStackView() // 이미지 추가 버튼 영역
    var writingStackView = UIStackView() // 내용(이미지+글) 작성 영역
    
    let disposeBag = DisposeBag()
    
    //MARK: - 이미지 picker 관련
    var picker = UIImagePickerController()
    var selectedImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.picker.delegate = self
        
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
        setImageView()
        setTextView()
        
        view.addSubview(topStackView)
        view.addSubview(appendImageStackView)
        view.addSubview(writingStackView)
        
        topStackView.addSubview(closeBtn)
        topStackView.addSubview(submitBtn)

        appendImageStackView.addSubview(appendImageBtn)
        appendImageStackView.addSubview(appendImageLabel)

        writingStackView.addSubview(imageView)
        writingStackView.addSubview(textView)
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
    
    //MARK: - 오토 레이아웃 - 이미지 추가 버튼 영역
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
    
    //MARK: - 오토 레이아웃 - 내용(이미지/글) 작성 영역
    func setBottomConstraint() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(writingStackView)
            make.leading.equalTo(writingStackView)
            make.trailing.equalTo(writingStackView)
            make.bottom.equalTo(textView.snp.top).offset(-10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(writingStackView)
            make.trailing.equalTo(writingStackView)
            make.bottom.equalTo(writingStackView)
            
            make.height.greaterThanOrEqualTo(400)
        }
    }
    
    func setTopStackView() {
        topStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.alignment = .center
            
            return stackView
        }()
    }
    
    func setAppendImageStackView() {
        appendImageStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .horizontal
            stackView.alignment = .center
            
            return stackView
        }()
    }
    
    func setWritingStackView() {
        writingStackView = {
            let stackView = UIStackView()
            
            stackView.axis = .vertical
            stackView.alignment = .center
            return stackView
        }()
    }
    
    //MARK: - 화면 요소 정의
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
        
            // 이미지 picker 열기
            btn.addTarget(self, action: #selector(selectContentImage), for: .touchUpInside)
            
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
    
    func setImageView() {
        imageView = {
            let imageView = UIImageView()
            
            imageView.backgroundColor = .green
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            
            return imageView
        }()
    }
    
    func setTextView() {
        textView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.text = "나누고 싶은 생각을 공유해 보세요!"
            textView.textColor = .lightGray
            textView.font = .systemFont(ofSize: 20, weight: .regular)
            textView.delegate = self
//            textView.backgroundColor = .green
            
            // padding
            textView.textContainerInset = UIEdgeInsets(top: 20.0, left: 15.0, bottom: 20.0, right: 0)
            
            textView.rx.text.orEmpty
                .map {
                    $0.count > 0
                }
                .observe(on: MainScheduler.instance)
                .subscribe {
                    self.submitBtn.isEnabled = $0
                }
                .disposed(by: disposeBag)
            
            return textView
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
        let contents = self.textView.text ?? ""
        let dummyUser = PostViewModel.shared.dummyUsers.randomElement()
        let dummyLikeCount = (0...10).randomElement()
        
        let post = Post(contents: contents, contentImage: selectedImageName, likeCount: dummyLikeCount, commentCount: 0, writer: dummyUser)
        
        PostViewModel.shared.createPost(with: post) //onNext
        self.dismiss(animated: true)
    }
    
    //MARK: - 이미지 선택 창 띄우기
    @objc func selectContentImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.sourceType = .savedPhotosAlbum
        } else {
            print(#fileID, #function, #line, " - Error: Not available for PhotosAlbum")
            return
        }
       
        if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
            picker.mediaTypes = mediaTypes
        }
        
        picker.modalPresentationStyle = UIModalPresentationStyle.popover
        
        present(picker, animated: true)
    }
}

extension CreatePostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // 이미지 path 저장 
        if let imgUrl = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? URL {
            let imgName = imgUrl.lastPathComponent
            selectedImageName = imgName
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending("/"+imgName)

            let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            print(#fileID, #function, #line, " - write to: ", localPath)
            
            picker.dismiss(animated: true) { () in
                // 이미지 추가 시, height를 지정합니다.
                self.imageView.snp.makeConstraints {
                    $0.height.equalTo(self.writingStackView.snp.width)
                }

                self.imageView.image = image
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

//MARK: - UITextViewDelegate
extension CreatePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
}

// MARK: - Utilities
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

//struct PreView: PreviewProvider{
//    static var previews: some View {
//        CreatePostViewController().toPreview()
//    }
//}
//
//#if DEBUG
//extension CreatePostViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        let viewController: CreatePostViewController
//
//        func makeUIViewController(context: Context) -> CreatePostViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: CreatePostViewController, context: Context) {
//        }
//    }
//    func toPreview() -> some View {
//        Preview(viewController: self)
//    }
//}
//#endif
