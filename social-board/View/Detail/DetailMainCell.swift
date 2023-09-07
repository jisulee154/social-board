//
//  DetailMainCell.swift
//  social-board
//
//  Created by 이지수 on 2023/09/06.
//

import UIKit
import SnapKit

class DetailMainCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.contentView.backgroundColor = .blue
        
        setComponents()
        setConstraints()
    }
    
    //MARK: - 오토 레이아웃
    func setConstraints() {
        
    }
    
    //MARK: - 구성요소 정의
    func setComponents() {
        
    }
}

extension DetailMainCell {
    //MARK: - 내용을 보여줄 글 정보를 전달 받음
    func setContents(of post: Post) {
        
    }
}
