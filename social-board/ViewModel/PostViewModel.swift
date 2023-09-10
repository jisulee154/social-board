//
//  PostViewModel.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import RxSwift
import RealmSwift
import Foundation

class PostViewModel {
    static let shared = PostViewModel()
    var posts = PublishSubject<[Post]>()
    var comments = PublishSubject<[Comment]>()
    var commentCount = PublishSubject<Int>()
    var likeCount = PublishSubject<Int>()
    var isLiked = PublishSubject<Bool>()
    
    let disposeBag = DisposeBag()
    
    var dummyjobs: [Job] = []
    var dummyUsers: [User] = []
//    var dummyComments: [Comment] = []
    
    private init() {
        //MARK: - 더미 데이터
        dummyjobs = [
            Job(jobID: ObjectId.generate(), category: JobCategory.dev, workYear: 1),
            Job(jobID: ObjectId.generate(), category: JobCategory.dev, workYear: 8),
            Job(jobID: ObjectId.generate(), category: JobCategory.design, workYear: 3),
            Job(jobID: ObjectId.generate(), category: JobCategory.business, workYear: 11),
            Job(jobID: ObjectId.generate(), category: JobCategory.hr, workYear: 7),
            Job(jobID: ObjectId.generate(), category: JobCategory.marcketing, workYear: 2)
        ]
        
        dummyUsers = [
            User(userID: ObjectId.generate(), userName: "초상화", userProfilePicture: "userProfile1", job: dummyjobs[0]),
            User(userID: ObjectId.generate(), userName: "불도그", userProfilePicture: "userProfile2", job: dummyjobs[1]),
            User(userID: ObjectId.generate(), userName: "뚱땅뚱땅", userProfilePicture: "userProfile3", job: dummyjobs[2]),
            User(userID: ObjectId.generate(), userName: "미소세상", userProfilePicture: "userProfile4", job: dummyjobs[3]),
            User(userID: ObjectId.generate(), userName: "초록", userProfilePicture: "userProfile5", job: dummyjobs[4]),
            User(userID: ObjectId.generate(), userName: "응시", userProfilePicture: "userProfile6", job: dummyjobs[5])
        ]
    }
    
    //MARK: - 새글 생성
    func createPost(with post: Post) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(post)
        }
        fetchPosts()
    }
    
    //MARK: - 글 불러오기
    func fetchPosts() {
        //MARK: - Realm SchemaVersion 관리
        let config = Realm.Configuration(schemaVersion: 8)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        let fetchResult = realm.objects(Post.self).sorted(by: \.createdDateTime, ascending: false)
        var postResult: [Post] = []
        
        for element in fetchResult {
            postResult.append(element)
        }
        
        self.posts
            .onNext(postResult)
    }
    
    //MARK: - 글 업데이트
    func updatePost(_ post: Post, contents: String? = nil, contentImage: String? = nil, likeCount: Int? = nil, commentCount: Int? = nil, writer: User? = nil, comments: List<Comment>? = nil, expanded: Bool? = nil, isLiked: Bool? = nil) {
        let realm = try! Realm()
        
        guard let post = realm.object(ofType: Post.self, forPrimaryKey: post.postID) else {
            print(#fileID, #function, #line, " - Error: Post \(post.postID) not found")
            return
        }
        
        try! realm.write {
            if let newContentImage = contentImage {
                post.contentImage = newContentImage
            }
            if let newLikeCount = likeCount {
                post.likeCount = newLikeCount
            }
            if let newCommentCount = commentCount {
                post.commentCount = newCommentCount
            }
            if let newWriter = writer {
                post.writer = newWriter
            }
            if let newComments = comments {
                post.comments = newComments
            }
            if let newExpanded = expanded {
                post.expanded = newExpanded
            }
            if let newIsLiked = isLiked {
                post.isLiked = newIsLiked
            }
//            print(#fileID, #function, #line, " - update as: ", post.expanded ?? "nil")
        }
        fetchPosts()
    }
    
    //MARK: - 코멘트 수 가져오기
    func fetchCommentCount(of post: Post) {
        let realm = try! Realm()
        
        let allComments = realm.objects(Comment.self)
        let commentsOfPost = allComments.where {
            $0.belongsTo == post
        }
        let commentCount = commentsOfPost.count
        
        self.commentCount
            .onNext(commentCount)
    }
    
    //MARK: - 좋아요 수 가져오기
    func fetchLikeCount(of post: Post) {
        let realm = try! Realm()
        
        let allPosts = realm.objects(Post.self)
        let targetPost = allPosts.where {
            $0.postID == post.postID
        }
        let likeCount = targetPost.first?.likeCount
        
        self.likeCount
            .onNext(likeCount ?? 0)
    }
    
    //MARK: - 좋아요 상태 가져오기
    func fetchIsLiked(of post: Post) {
        let realm = try! Realm()
        
        let allPosts = realm.objects(Post.self)
        let targetPost = allPosts.where {
            $0.postID == post.postID
        }
        let isLiked = targetPost.first?.isLiked
        
        self.isLiked
            .onNext(isLiked ?? false)
    }
    
    ///모든 글 접기
    func reset() {
        //MARK: - 모든 글'더보기' 해제 -> 펼쳤던 글을 접습니다.
        let realm = try! Realm()
        
        let expandedPosts = realm.objects(Post.self).filter("expanded == true")
        
        try! realm.write {
            expandedPosts.setValue("false", forKey: "expanded")
        }
        fetchPosts()
    }
        
    //MARK: - 새 댓글 생성
    func createComment(_ comment: Comment) {
        let realm = try! Realm()
        
        let comment: Comment = comment
        
        try! realm.write {
            realm.add(comment)
        }
        
        fetchComments(of: comment.belongsTo!)
    }
    
    //MARK: - 댓글 불러오기
    func fetchComments(of post:Post) {
        let realm = try! Realm()
        
        let allComments = realm.objects(Comment.self)
        let commentsOfPost = allComments.where {
            $0.belongsTo == post
        }.sorted(by: \.createdDateTime, ascending: false)
        
        var commentResult: [Comment] = []
        
        for element in commentsOfPost {
            commentResult.append(element)
        }
        
        self.comments
            .onNext(commentResult)
    }
}
