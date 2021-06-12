import Combine
import DroidKaigiMPP
import Model

public protocol FeedRepositoryProtocol: KMMRepositoryProtocol {
    associatedtype RepositoryType = IosFeedRepository

    func feedContents() -> AnyPublisher<Model.FeedContents, KotlinError>
    func addFavorite(feedItem: Model.FeedItemType) -> AnyPublisher<Void, Never>
    func removeFavorite(feedItem: Model.FeedItemType) -> AnyPublisher<Void, Never>
}

public struct FeedRepository: FeedRepositoryProtocol {
    let scopeProvider: ScopeProvider
    let repository: RepositoryType

    public init() {
        self.scopeProvider = DIContainer.shared.get(type: ScopeProvider.self)
        self.repository = DIContainer.shared.get(type: RepositoryType.self)
    }

    public func feedContents() -> AnyPublisher<Model.FeedContents, KotlinError> {
        Future<DroidKaigiMPP.FeedContents, KotlinError> { promise in
            repository.feedContents()
                .subscribe(scope: scopeProvider.scope) {
                    promise(.success($0))
                } onComplete: {
                } onFailure: {
                    promise(.failure(KotlinError.fetchFailed($0.description())))
                }
        }
        .map(Model.FeedContents.init(from:))
        .eraseToAnyPublisher()
    }

    public func addFavorite(feedItem: Model.FeedItemType) -> AnyPublisher<Void, Never> {
        // TODO: Implement after Date converter merged.
        Just(())
            .eraseToAnyPublisher()
    }

    public func removeFavorite(feedItem: Model.FeedItemType) -> AnyPublisher<Void, Never> {
        // TODO: Implement after Date converter merged.
        Just(())
            .eraseToAnyPublisher()
    }
}
