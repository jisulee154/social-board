//
//  PostTopCell.swift
//  social-board
//
//  Created by 이지수 on 2023/08/29.
//

import UIKit
import SnapKit

class PostTopCell: UITableViewCell {
    
    //MARK: - 글 작성 셀(최상단)
    var myProfilePicture = UIImageView()    // 사용자 프로필 이미지
    var writingLabel = UILabel()            // 글 작성 셀 기본 문구
    
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
            make.height.greaterThanOrEqualTo(40)
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
            return imageView
        }()
    }
    
    func setWritingLabel() {
        writingLabel = {
            let label = UILabel()
            
            label.text = "나누고 싶은 생각을 공유해 보세요!"
            label.textColor = .gray            
            return label
        }()
    }
}
