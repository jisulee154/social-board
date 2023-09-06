//
//  DetailMain.swift
//  social-board
//
//  Created by 이지수 on 2023/09/06.
//

import UIKit
import SnapKit

class DetailMain: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        self.contentView.backgroundColor = .blue
    }
    
    //MARK: - 오토 레이아웃
    func setConstraints() {
        
    }
}
