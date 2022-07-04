//
//  MessageStatus.swift
//  NYHM
//
//  Created by Hafizh Mo on 22/06/22.
//

import Foundation

struct MessageStatus {
    var phrase: Phrase
    var message: Message?
    var isPlaying: IsPlaying?
    var isPausing: IsPausing?
    var saved: Saved?
    var canceled: Canceled?
    var starting: Started?
    var errorMessage: String?
    
    init(phrase: Phrase) {
        self.phrase = phrase
    }
}

enum Phrase: String {
    case sent = "Sent"
    case received = "Received"
    case replied = "Replied"
    case failed = "Failed"
}

struct Message {
    var value: String
    
    init(_ value: [String: Any]) {
        self.value = value[MessageKeyLoad.result] as! String
    }
}

struct IsPlaying {
    var value: Bool
    
    init(_ value: [String: Any]) {
        self.value = value[MessageKeyLoad.isPlaying] as! Bool
    }
}

struct IsPausing {
    var value: Bool
    
    init(_ value: [String: Any]) {
        self.value = value[MessageKeyLoad.isPausing] as! Bool
    }
}

struct Saved {
    var value: Bool
    
    init(_ value: [String: Any]) {
        self.value = value[MessageKeyLoad.saving] as! Bool
    }
}

struct Canceled {
    var value: Bool
    
    init(_ value: [String: Any]) {
        self.value = value[MessageKeyLoad.canceling] as! Bool
    }
}

struct Started {
    var value: Bool
    
    init(_ value: [String: Any]) {
        self.value = value[MessageKeyLoad.starting] as! Bool
    }
}

struct MessageKeyLoad {
    static let result = "result"
    static let isPlaying = "isPlaying"
    static let isPausing = "isPausing"
    static let saving = "saving"
    static let canceling = "canceling"
    static let starting = "starting"
}
