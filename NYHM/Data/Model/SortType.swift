//
//  SortType.swift
//  NYHM
//
//  Created by Hafizh Mo on 13/06/22.
//

import Foundation

enum SortType: String, CaseIterable {
    case alphabetAsc = "A-Z"
    case alphabetDesc = "Z-A"
    case timeAsc = "Oldest"
    case timeDesc = "Newest"
}

extension SortType {
    func getSortDescription() -> NSSortDescriptor {
        switch self {
        case .alphabetAsc:
            return NSSortDescriptor(key: #keyPath(Transcriptions.title), ascending: true)
        case .alphabetDesc:
            return NSSortDescriptor(key: #keyPath(Transcriptions.title), ascending: false)
        case .timeAsc:
            return NSSortDescriptor(key: #keyPath(Transcriptions.createdAt), ascending: true)
        case .timeDesc:
            return NSSortDescriptor(key: #keyPath(Transcriptions.createdAt), ascending: false)
        }
    }
}
