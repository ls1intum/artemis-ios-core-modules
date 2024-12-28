//
//  ArtemisStompClient.swift
//  
//
//  Created by Sven Andabaka on 05.05.23.
//

import Foundation
import Gzip
import SwiftStomp
import UserStore
import Common

public class ArtemisStompClient {

    private enum SubscribeStatus {
        case subscribed, pending
    }

    private var stompClient: SwiftStomp?
    private var topics: [String: SubscribeStatus] = [:]
    private var continuations: [String: AsyncStream<Any?>.Continuation] = [:]

    private let queue = DispatchQueue(label: "thread-safe-socket")

    public static let shared = ArtemisStompClient()

    private init() {
        stompClient = nil
    }

    public func setup() {
        guard let host = UserSessionFactory.shared.institution?.baseURL?.host(),
              let stompUrl = URL(string: "wss://\(host):443/websocket/websocket") else { return }

        let headers = [
            "heartbeat": "{ outgoing: 10000, incoming: 10000 }",
            "debug": "false",
            "protocols": "['v12.stomp']"
        ]

        stompClient = SwiftStomp(host: stompUrl, headers: headers)
        stompClient?.delegate = self
        stompClient?.enableAutoPing()
        stompClient?.autoReconnect = true
        stompClient?.connect()
    }

    public func subscribe(to topic: String) -> AsyncStream<Any?> {
        if stompClient == nil {
            setup()
        }

        subscribeWithoutStream(to: topic)

        return AsyncStream { continuation in
            continuation.onTermination = { [weak self] _ in
                self?.unsubscribe(from: topic)
            }

            setContinuation(topic, continuation: continuation)
        }
    }

    public func unsubscribe(from topic: String) {
        log.debug("Stomp Unsubscribe: \(topic)")
        stompClient?.unsubscribe(from: topic)
        queue.async { [weak self] in
            self?.continuations.removeValue(forKey: topic)
            self?.topics.removeValue(forKey: topic)
            if self?.topics.isEmpty ?? false {
                self?.stompClient?.disconnect()
            }
        }
    }

    public func didSubscribeTopic(_ topic: String) -> Bool {
        topics.keys.contains(topic)
    }

    private func setTopic(_ topic: String, status: SubscribeStatus) {
        queue.async { [weak self] in
            self?.topics[topic] = status
        }
    }

    private func setContinuation(_ topic: String, continuation: AsyncStream<Any?>.Continuation) {
        queue.async { [weak self] in
            self?.continuations[topic] = continuation
        }
    }
}

extension ArtemisStompClient: SwiftStompDelegate {
    private func subscribeWithoutStream(to topic: String) {
        if stompClient?.connectionStatus == .fullyConnected {
            stompClient?.subscribe(to: topic)
            log.debug("Stomp Subscribe: \(topic)")
            setTopic(topic, status: .subscribed)
        } else {
            log.debug("Stomp Subscribe Pending: \(topic)")
            setTopic(topic, status: .pending)
        }
    }

    public func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        log.debug("Stomp: Connect")
        queue.async { [weak self] in
            let topicKeys = self?.topics.keys
            topicKeys?.forEach { topic in
                self?.subscribeWithoutStream(to: topic)
            }
        }
    }

    public func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        log.debug("Stomp: Disconnect")
        stompClient = nil
        queue.async { [weak self] in
            if self?.topics.isEmpty == false {
                self?.setup()
            }
        }
    }

    public func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
        log.debug("Stomp: MessageReceived")
        let continuation = continuations[destination]

        if headers["compressed"] == "true" {
            if let unzipped = try? (message as? Data)?.gunzipped() {
                continuation?.yield(unzipped)
            } else {
                log.warning("Stomp: Failed to gunzip compressed message")
            }
        } else {
            continuation?.yield(message)
        }
    }

    public func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        log.debug("Stomp: Receipt")
    }

    public func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        log.error(fullDescription ?? "Stomp Error")
    }

    public func onSocketEvent(eventName: String, description: String) {
        log.debug("Event Name: \(eventName), Description: \(description)")
        if eventName == "cancelled",
           !topics.isEmpty,
           !(stompClient?.isConnected ?? false) {
            stompClient?.connect()
        }
    }
}

public extension JSONDecoder {
    static func getTypeFromSocketMessage<T: Decodable>(type: T.Type, message: Any?) -> T? {
        guard let messageString = message as? String,
              let messsageData = messageString.data(using: .utf8) else {
            log.error("Could not decode message as \(T.self)")
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        do {
            return try decoder.decode(T.self, from: messsageData)
        } catch {
            log.error(error)
            return nil
        }
    }
}
