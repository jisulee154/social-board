//
//  UserInfo.swift
//  social-board
//
//  Created by 이지수 on 2023/09/12.
//

import UIKit
import RxSwift

class UserInfo : UIViewController {
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
    
    var disposeBag = DisposeBag()
    
    //MARK: - 상수
    let profilePictureHeight: Int = 40 // 프로필 이미지 높이
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .orange
    }
}
