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
    private var continuations: [String: AsyncStream<Any?>.Continuation] = [:] {
        didSet {
            print("Sven")
        }
    }

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

        if stompClient?.connectionStatus == .fullyConnected {
            stompClient?.subscribe(to: topic)
            log.debug("Stomp Subscripe: \(topic)")
            topics[topic] = .subscribed
        } else {
            log.debug("Stomp Subscripe Pending: \(topic)")
            topics[topic] = .pending
        }
        return AsyncStream { continuation in
            continuation.onTermination = { [weak self] termination in
                log.error(termination)
                self?.continuations.removeValue(forKey: topic)
            }

            continuations[topic] = continuation
        }
    }

    public func unsubscribe(from topic: String) {
        stompClient?.unsubscribe(from: topic)
    }
}

extension ArtemisStompClient: SwiftStompDelegate {
    private func subscribeWithoutStream(to topic: String) {
        if stompClient?.connectionStatus == .fullyConnected {
            stompClient?.subscribe(to: topic)
            log.debug("Stomp Subscripe: \(topic)")
            topics[topic] = .subscribed
        } else {
            log.debug("Stomp Subscripe Pending: \(topic)")
            topics[topic] = .pending
        }
    }

    public func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Stomp: Connect")
        topics.forEach { topic in
            guard topic.value != .subscribed else { return }
            subscribeWithoutStream(to: topic.key)
        }
    }

    public func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("Stomp: Disconnect")
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
