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
        Post(
            title: "제목1", contents: "내용1 짧은 내용입니다 짧은 내용입니다 짧은 내용입니다", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 3, commentCount: 0,
             user: User(userID: UUID(), userName: "모모", userProfilePicture: "https://random.dog/5350-13889-29214.jpg", userJob: .dev),
             comment: Comment(postID: UUID())
            ),
        Post(
            title: "제목2", contents: "내용2 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요. 아주 아주 긴글이에요.", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 0, commentCount: 5,
             user: User(userID: UUID(), userName: "김김김", userProfilePicture: "https://random.dog/5350-13889-29214.jpg", userJob: .planner),
             comment: Comment(postID: UUID())),
        Post(
            title: "제목3", contents: "내용3 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지 농담이지", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 2, commentCount: 1,
             user: User(userID: UUID(), userName: "리리리", userProfilePicture: "https://random.dog/5350-13889-29214.jpg", userJob: .design),
             comment: Comment(postID: UUID()))
    ]
}
