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
    
    let disposeBag = DisposeBag()
    
    var dummyjobs: [Job] = []
    var dummyUsers: [User] = []
//    var dummyComments: [Comment] = []
    
    private init() {
        //MARK: - 더미 데이터
        dummyjobs = [
            Job(jobID: ObjectId.generate(), category: JobCategory.dev, workYear: 1),
            Job(jobID: ObjectId.generate(), category: JobCategory.design, workYear: 3),
            Job(jobID: ObjectId.generate(), category: JobCategory.business, workYear: 11),
            Job(jobID: ObjectId.generate(), category: JobCategory.hr, workYear: 4),
            Job(jobID: ObjectId.generate(), category: JobCategory.marcketing, workYear: 2)
        ]
        
        dummyUsers = [
            User(userID: ObjectId.generate(), userName: "신사임당", userProfilePicture: "userProfile1", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "유관순", userProfilePicture: "userProfile2", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "아이바오", userProfilePicture: "userProfile3", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "곰", userProfilePicture: "userProfile4", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "여우", userProfilePicture: "userProfile5", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "푸바오", userProfilePicture: "userProfile6", job: dummyjobs.randomElement())
        ]
        
//        dummyComments = [
//            Comment(createdDateTime: Date(), contents: "댓글1 내용 내용 내용"),
//            Comment(createdDateTime: Date(), contents: "댓글2 내용 내용 내용"),
//            Comment(createdDateTime: Date(), contents: "댓글3 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용"),
//            Comment(createdDateTime: Date(), contents: "댓글4 내용 내용 내용~!"),
//            Comment(createdDateTime: Date(), contents: "댓글5 내용 내용 내용")
//        ]
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
        let config = Realm.Configuration(schemaVersion: 7)
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
    func updatePost(_ post: Post, contents: String? = nil, contentImage: String? = nil, likeCount: Int? = nil, commentCount: Int? = nil, writer: User? = nil, comments: List<Comment>? = nil, expanded: Bool? = nil) {
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
//            print(#fileID, #function, #line, " - update as: ", post.expanded ?? "nil")
        }
        fetchPosts()
    }
    
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
    #warning("무슨 포스트랑 관련이 있는지 어떻게 알지??? 일단 제껴")
    func createComment(of post: Post) {
        let realm = try! Realm()
        
        let dummyCommentContents: [String] = [
            "댓글1 내용 내용 내용",
            "댓글2 내용 내용 내용",
            "댓글3 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용 무언가 길고 진지한 내용",
            "댓글4 내용 내용 내용",
            "댓글5 내용 내용 내용 "
        ]
        
        let comment: Comment = Comment(commentID: ObjectId.generate(),
                                       createdDateTime: Date(),
                                       contents: dummyCommentContents.randomElement(),
                                       writtenBy: post.writer,
                                       belongsTo: post)
        
        try! realm.write {
            realm.add(comment)
        }
        
        fetchComments(of: post)
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



//Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel congue dui. Mauris posuere, elit ac feugiat mollis, metus libero porttitor est, vitae pellentesque ligula neque nec enim. Aenean vel sem sit amet dui ullamcorper ultricies. Donec suscipit odio eu lobortis faucibus. Phasellus sed nisl quis ex efficitur ultricies at eget lorem. Sed commodo vel ligula varius congue. Pellentesque quis mollis tortor, in consequat dui. Nam at lacus magna. Maecenas id eros at arcu finibus tincidunt. Maecenas eget leo sed libero tincidunt fermentum eu non nisi. Praesent luctus, mauris sit amet porta hendrerit, enim sem efficitur metus, a lobortis odio purus id enim. Vestibulum vel lectus risus. Mauris eros mi, mattis sit amet consequat eget, mattis non justo. Vestibulum dui urna, euismod ac lorem in, rutrum maximus lectus. Sed elementum viverra tempor.\n2           Ut vitae nunc erat. Nunc a efficitur dolor. Aenean eu dolor non massa vulputate euismod. Ut porttitor sem vel dui mollis imperdiet. Pellentesque fringilla viverra orci quis convallis. Nulla vel nulla ultricies, pulvinar turpis in, dignissim ex. Nullam vitae mi id lectus pellentesque sollicitudin. Nulla facilisi. Nullam quis nibh faucibus, porttitor nunc in, sagittis tortor. Sed eros diam, egestas sed dignissim non, dapibus quis tellus. Donec ante massa, commodo in nulla ac, volutpat porttitor felis. Praesent posuere lectus ullamcorper mauris faucibus vehicula. Donec semper tincidunt odio, et lacinia risus vestibulum et. \n 3                 Suspendisse neque erat, sollicitudin in ante ac, condimentum feugiat massa. In sit amet mattis est, ac fringilla turpis. Pellentesque a dolor sit amet felis dictum pulvinar in gravida ex. Sed nunc tellus, sagittis nec orci eget, vehicula ultrices nunc. Sed lorem augue, sagittis nec dolor vitae, lacinia tempor orci. Proin auctor ligula sit amet elit imperdiet, quis aliquet dolor imperdiet. Donec id facilisis eros, eget consequat erat. Etiam in mollis mi. Vivamus suscipit ac justo eu dapibus. Mauris eu nunc nec mauris pulvinar volutpat nec eget sem. Quisque faucibus tortor et tellus volutpat, vitae ornare turpis hendrerit. Donec placerat urna ut aliquet egestas. Pellentesque rutrum quam mauris, quis vulputate libero gravida nec. Cras fringilla eros id orci lacinia venenatis.
