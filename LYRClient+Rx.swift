//
//  LYRClient+Rx.swift
//
//  Created by Kyle Wilkinson on 1/25/16.
//

import Foundation
import RxSwift

extension LYRClient {

  func rx_connect() -> Observable<Bool> {
    return Observable.create { observer in
      self.connectWithCompletion { (success, error) -> Void in
        if let error = error {
          observer.on(.Error(error))
          return
        }

        observer.on(.Next(success))
        observer.on(.Completed)
      }

      return NopDisposable.instance
    }
  }

  func rx_requestAuthenticationNonce() -> Observable<String> {
    return Observable.create { observer in
      self.requestAuthenticationNonceWithCompletion { (possibleNonce, error) -> Void in
        guard let nonce = possibleNonce else {
          observer.on(.Error(NSError(domain: "Layer", code: 0, userInfo: nil)))
          return
        }

        if let error = error {
          observer.on(.Error(error))
          return
        }

        observer.on(.Next(nonce))
        observer.on(.Completed)
      }

      return NopDisposable.instance
    }
  }

  // Returns the authenticated user id
  func rx_authenticate(identityToken: String) -> Observable<String> {
    return Observable.create { observer in
      self.authenticateWithIdentityToken(identityToken) { (possibleAuthenticatedUserId, error) -> Void in
        guard let authenticatedUserId = possibleAuthenticatedUserId else {
          observer.on(.Error(NSError(domain: "Layer", code: 1, userInfo: nil)))
          return
        }

        if let error = error {
          observer.on(.Error(error))
          return
        }

        observer.on(.Next(authenticatedUserId))
        observer.on(.Completed)
      }

      return NopDisposable.instance
    }
  }

  func rx_deauthenticate() -> Observable<Bool> {
    return Observable.create { observer in
      self.deauthenticateWithCompletion { (success, error) -> Void in
        if let error = error {
          observer.on(.Error(error))
          return
        }

        observer.on(.Next(success))
        observer.on(.Completed)
      }

      return NopDisposable.instance
    }
  }

}
