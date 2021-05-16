import Foundation
import FirebaseFirestore

struct DatabaseDocumentPathBuilder<Entity: Codable> {
    let path: String
}

struct DatabaseCollectionPathBuilder<Entity: DatabaseEntity> {
    let path: String
    var args: (key: Entity.WhereKey, relations: [CollectionRelation])? = nil
    var isGroup: Bool = false

    static func users() -> DatabaseCollectionPathBuilder<User> { .init(path: "/users") }
}

enum CollectionRelation {
    case equal(Any)
    case less(Any)
    case lessOrEqual(Any)
    case greater(Any)
    case greaterOrEqual(Any)
    case notEqual(Any)
    case contains([Any])
}
