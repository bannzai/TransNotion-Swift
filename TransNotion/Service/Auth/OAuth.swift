//
//  OAuth.swift
//  TransNotion
//
//  Created by Yudai.Hirose on 2021/05/16.
//

import Foundation
import Combine
import AuthenticationServices

private let authorizeURL: URL = URL(string: "https://api.notion.com/v1/oauth/authorize?client_id=\(Secret.notionOAuthClientID)&redirect_uri=\(Secret.notionOAuthRedirectURI)&response_type=code")!
private let tokenURL: URL = URL(string: "https://api.notion.com/v1/oauth/token")!
private let basicAuthHeader: String = {
    let base = "\(Secret.notionOAuthClientID):\(Secret.notionOAuthClientSecret)"
    return base.data(using: .utf8)!.base64EncodedString()
}()

final class NotionOAuth: NSObject {
    let window: ASPresentationAnchor
    init(window: UIWindow) {
        self.window = window
    }
    func start() -> AnyPublisher<Credential, Swift.Error> {
        requestAuthentification()
            .flatMap(requestCredential(code:))
            .eraseToAnyPublisher()
    }
}

extension NotionOAuth {
    typealias TemporaryAuthentificationCode = String
    enum RequestAuthentificationError: Swift.Error {
        case sessionError(Swift.Error)
        case codeNotFound
    }

    func requestAuthentification() -> AnyPublisher<TemporaryAuthentificationCode, Swift.Error> {
        Future<URL, RequestAuthentificationError> { completion in
            let session = ASWebAuthenticationSession(url: authorizeURL, callbackURLScheme: Secret.notionOAuthCallbackCustomURLScheme) { (url, error) in
                if let error = error {
                    completion(.failure(.sessionError(error)))
                } else if let url = url {
                    completion(.success(url))
                }
            }
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
        .tryMap { url in
            guard let code = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first(where: { $0.name == "code" })?.value else {
                throw RequestAuthentificationError.codeNotFound
            }
            return code
        }
        .eraseToAnyPublisher()
    }
    
    struct RequestCredentialBody: Encodable {
        let grantType: String = "authorization_code"
        let code: TemporaryAuthentificationCode
        let redirectUri: String = Secret.notionOAuthRedirectURI
    }
    enum RequestCredentialError: LocalizedError {
        case notStableResponse
        case emptyData
    }
    func requestCredential(code: TemporaryAuthentificationCode) -> AnyPublisher<Credential, Swift.Error> {
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Authorization": "Basic \(basicAuthHeader)",
            "Content-Type": "application/json",
        ]
        request.httpBody = try! JSONEncoder
            .convertToSnakeCase
            .encode(
                RequestCredentialBody(code: code)
            )
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw RequestCredentialError.notStableResponse
                }
                if data.isEmpty {
                    throw RequestCredentialError.emptyData
                }
                return data
            }
            .decode(type: Credential.self, decoder: JSONDecoder.convertFromSnakeCase)
            .eraseToAnyPublisher()
    }
}

extension NotionOAuth: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        window
    }
}
