//
//  CreatePostViewController.swift
//  social-board
//
//  Created by 이지수 on 2023/08/30.
//

import UIKit
import SnapKit
import RealmSwift

/// 새글 쓰기 모달 화면
class CreatePostViewController: UIViewController {
    var closeBtn = UIButton()
    var appendImageBtn = UIButton() // 이미지 추가 버튼
    var appendImabeLabel = UILabel() // 이미지 추가 place holder 메시지
    var submitBtn = UIButton() // 업로드 버튼
    var textfield = UITextField() // 내용 작성 버튼 // place holder text 포함
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func configureView() {
        view.addSubview(<#T##view: UIView##UIView#>)
    }
}
