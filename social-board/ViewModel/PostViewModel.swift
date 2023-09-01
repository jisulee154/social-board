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
//    var updateTableView = PublishSubject<Bool>()
    
    let disposeBag = DisposeBag()
    
    var dummyjobs: [Job] = []
    var dummyUsers: [User] = []
    
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
            User(userID: ObjectId.generate(), userName: "권애라", userProfilePicture: "userProfile3", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "마리", userProfilePicture: "userProfile4", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "지혜", userProfilePicture: "userProfile5", job: dummyjobs.randomElement()),
            User(userID: ObjectId.generate(), userName: "은지", userProfilePicture: "userProfile6", job: dummyjobs.randomElement())
        ]
    }
    
    func createPost(with post: Post) {
        //MARK: - Realm SchemaVersion 관리
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(post)
        }
        fetchPosts()
    }
    
    func fetchPosts() {
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        
        let fetchResult = realm.objects(Post.self)
        var postResult: [Post] = []
        
        for element in fetchResult {
            postResult.append(element)
        }
        
        self.posts
            .onNext(postResult)
        
//        self.updateTableView
//            .onNext(true)
    }

//    let posts = [
//        Post(
//            title: "제목1", contents: "내용1 짧은 내용입니다 짧은 내용입니다 짧은 내용입니다", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 3, commentCount: 0,
//             user: User(userID: UUID(), userName: "모모", userProfilePicture: "https://random.dog/5350-13889-29214.jpg", userJob: .dev),
//             comment: Comment(postID: UUID())
//            ),
//        Post(
//            title: "제목2", contents: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur vel congue dui. Mauris posuere, elit ac feugiat mollis, metus libero porttitor est, vitae pellentesque ligula neque nec enim. Aenean vel sem sit amet dui ullamcorper ultricies. Donec suscipit odio eu lobortis faucibus. Phasellus sed nisl quis ex efficitur ultricies at eget lorem. Sed commodo vel ligula varius congue. Pellentesque quis mollis tortor, in consequat dui. Nam at lacus magna. Maecenas id eros at arcu finibus tincidunt. Maecenas eget leo sed libero tincidunt fermentum eu non nisi. Praesent luctus, mauris sit amet porta hendrerit, enim sem efficitur metus, a lobortis odio purus id enim. Vestibulum vel lectus risus. Mauris eros mi, mattis sit amet consequat eget, mattis non justo. Vestibulum dui urna, euismod ac lorem in, rutrum maximus lectus. Sed elementum viverra tempor.\n2           Ut vitae nunc erat. Nunc a efficitur dolor. Aenean eu dolor non massa vulputate euismod. Ut porttitor sem vel dui mollis imperdiet. Pellentesque fringilla viverra orci quis convallis. Nulla vel nulla ultricies, pulvinar turpis in, dignissim ex. Nullam vitae mi id lectus pellentesque sollicitudin. Nulla facilisi. Nullam quis nibh faucibus, porttitor nunc in, sagittis tortor. Sed eros diam, egestas sed dignissim non, dapibus quis tellus. Donec ante massa, commodo in nulla ac, volutpat porttitor felis. Praesent posuere lectus ullamcorper mauris faucibus vehicula. Donec semper tincidunt odio, et lacinia risus vestibulum et. \n 3                 Suspendisse neque erat, sollicitudin in ante ac, condimentum feugiat massa. In sit amet mattis est, ac fringilla turpis. Pellentesque a dolor sit amet felis dictum pulvinar in gravida ex. Sed nunc tellus, sagittis nec orci eget, vehicula ultrices nunc. Sed lorem augue, sagittis nec dolor vitae, lacinia tempor orci. Proin auctor ligula sit amet elit imperdiet, quis aliquet dolor imperdiet. Donec id facilisis eros, eget consequat erat. Etiam in mollis mi. Vivamus suscipit ac justo eu dapibus. Mauris eu nunc nec mauris pulvinar volutpat nec eget sem. Quisque faucibus tortor et tellus volutpat, vitae ornare turpis hendrerit. Donec placerat urna ut aliquet egestas. Pellentesque rutrum quam mauris, quis vulputate libero gravida nec. Cras fringilla eros id orci lacinia venenatis.", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 0, commentCount: 5,
//             user: User(userID: UUID(), userName: "김김김", userProfilePicture: "https://random.dog/5350-13889-29214.jpg", userJob: .planner),
//             comment: Comment(postID: UUID())),
//        Post(
//            title: "제목3", contents: "ㅇㅇ", contentImage: "https://velog.velcdn.com/images/jisulee154/post/2d868b6c-c75b-4b9c-9c34-c1ccf89a38dd/image.png", createdDateTime: Date(), likeCount: 2, commentCount: 1,
//             user: User(userID: UUID(), userName: "리리리", userProfilePicture: "https://random.dog/5350-13889-29214.jpg", userJob: .design),
//             comment: Comment(postID: UUID()))
//    ]
}
