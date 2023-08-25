//
//  PostViewModel.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import RxSwift
import Foundation

class PostViewModel {
    // 더미 데이터
    let posts = [
        Post(title: "제목1", contents: "내용1", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 3, commentCount: 0, writerID: "123"),
        Post(title: "제목2", contents: "내용2", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 3, commentCount: 0, writerID: "123"),
        Post(title: "제목3", contents: "내용3", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 3, commentCount: 0, writerID: "123")
    ]
}
