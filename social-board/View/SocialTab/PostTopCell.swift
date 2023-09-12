//
//  PostTopCell.swift
//  social-board
//
//  Created by 이지수 on 2023/08/29.
//

import UIKit
import SnapKit

//MARK: - 셀에서의 화면전환을 위한 프로토콜 (새글쓰기)
protocol CellPresentToCreatePostProtocol {
    func moveToCreatePostViewController()
}

class PostTopCell: UITableViewCell {
    
    //MARK: - 글 작성 셀(최상단)
    var myProfilePicture = UIImageView()    // 사용자 프로필 이미지
    var writingLabel = UILabel()            // 글 작성 셀 기본 문구
    
    var presentToCreatePostDelegate: CellPresentToCreatePostProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHeader()
        setHeaderConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 글쓰기 셀(최상단)
    func configureHeader() {
        setMyProfilePicture()
        setWritingLabel()
    }
    
    //MARK: - 글쓰기 셀 오토 레이아웃
    func setHeaderConstraint() {
        contentView.addSubview(myProfilePicture)
        contentView.addSubview(writingLabel)
        
        myProfilePicture.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(20)
            make.leading.equalTo(self.contentView).offset(20)
            make.trailing.equalTo(writingLabel.snp.leading).offset(-20)
            make.bottom.equalTo(self.contentView).offset(-20)
            
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        writingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(myProfilePicture.snp.centerY)
            make.trailing.equalTo(self.contentView).offset(-20)
        }
    }
    
    //MARK: - 글쓰기 구성 요소 정의
    func setMyProfilePicture() {
        myProfilePicture = {
            let imageView = UIImageView()
            
            imageView.image = UIImage(systemName: "person.crop.circle")
            imageView.tintColor = .systemGray2
//            let imageName = PostViewModel.shared.dummyUsers.randomElement()?.userProfilePicture
//            imageView.image = UIImage(named: imageName ?? "userProfile1")
            return imageView
        }()
    }
    
    func setWritingLabel() {
        writingLabel = {
            let label = UILabel()
            
            label.text = "나누고 싶은 생각을 공유해 보세요!"
            label.textColor = .gray
            
            /// 탭 제스처 정의
            /// 적용: 글쓰기 권장 문구 터치 시, 새글쓰기로 이동
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToCreatePost))

            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
            return label
        }()
    }
    
    @objc func moveToCreatePost() {
        presentToCreatePostDelegate?.moveToCreatePostViewController()
    }
}
