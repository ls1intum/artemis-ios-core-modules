//
//  ArtemisStompClient.swift
//  
//
//  Created by Sven Andabaka on 05.05.23.
//

import Foundation
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
        guard let host = UserSession.shared.institution?.baseURL?.host(),
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
            log.debug("Stomp Subscripe: \(topic)")
            setTopic(topic, status: .subscribed)
        } else {
            log.debug("Stomp Subscripe Pending: \(topic)")
            setTopic(topic, status: .pending)
        }
    }

    public func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Stomp: Connect")
        topics.forEach { topic in
            subscribeWithoutStream(to: topic.key)
        }
    }

    public func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("Stomp: Disconnect")
        stompClient = nil
    }

    public func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
        print("Stomp: MessageReceived")
        let continuation = continuations[destination]
        continuation?.yield(message)
    }

    public func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        print("Stomp: Receipt")
    }

    public func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        log.error(fullDescription ?? "Stomp Error")
    }

    public func onSocketEvent(eventName: String, description: String) {
        log.debug("Event Name: \(eventName), Description: \(description)")
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
