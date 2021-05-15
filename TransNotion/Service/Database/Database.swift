import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

protocol Database {
    func fetch<T: Decodable>(path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error>
    func create<T: Encodable>(path: DatabaseCollectionPathBuilder<T>, value: T) -> AnyPublisher<T, Error>
    func createWithID<T: Encodable>(path: DatabaseCollectionPathBuilder<T>, value: T, identifier: String) -> AnyPublisher<T, Error>
    func update<T: Encodable>(path: DatabaseDocumentPathBuilder<T>, value: T) -> AnyPublisher<T, Error>
}

private let database = Firestore.firestore()
struct FirestoreDatabase: Database {
    static let shared = FirestoreDatabase()
    private init() { }
    
    // MARK: - Fetch
    func fetch<T: Decodable>(path: DatabaseDocumentPathBuilder<T>) -> AnyPublisher<T, Error> {
        database.document(path.path).get()
    }
    
    struct DecodeError {
        let index: Int
        let error: Error
        let data: [String: Any]
    }

    // MARK: - Modifier
    func create<T: Encodable>(path: DatabaseCollectionPathBuilder<T>, value: T) -> AnyPublisher<T, Error> {
        database.collection(path.path).document().set(from: value)
    }

    func createWithID<T: Encodable>(path: DatabaseCollectionPathBuilder<T>, value: T, identifier: String) -> AnyPublisher<T, Error> {
        database.collection(path.path).document(identifier).set(from: value)
    }

    func update<T: Encodable>(path: DatabaseDocumentPathBuilder<T>, value: T) -> AnyPublisher<T, Error> {
        database.document(path.path).set(from: value)
    }
}

// MARK: - Private
private extension FirestoreDatabase {
    func buildCollectionQuery<T: Decodable>(for path: DatabaseCollectionPathBuilder<T>) -> FirebaseFirestore.Query {
        var query = path.isGroup ? database.collectionGroup(path.path) : database.collection(path.path)
        if let args = path.args {
            args.relations.forEach { relation in
                switch relation {
                case let .equal(value):
                    query = query.whereField(args.key.rawValue, isEqualTo: value)
                case let .less(value):
                    query = query.whereField(args.key.rawValue, isLessThan: value)
                case let .lessOrEqual(value):
                    query = query.whereField(args.key.rawValue, isLessThanOrEqualTo: value)
                case let .greater(value):
                    query = query.whereField(args.key.rawValue, isGreaterThan: value)
                case let .greaterOrEqual(value):
                    query = query.whereField(args.key.rawValue, isGreaterThanOrEqualTo: value)
                case let .notEqual(value):
                    query = query.whereField(args.key.rawValue, isNotEqualTo: value)
                case let .contains(values):
                    query = query.whereField(args.key.rawValue, in: values)
                }
            }
        }
        return query
    }
}
