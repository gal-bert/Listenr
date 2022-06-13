//
//  TranscriptionRepository.swift
//  NYHM
//
//  Created by Hafizh Mo on 13/06/22.
//

import Foundation

protocol TranscriptionRepositoryDataStore {
    func showAll() -> [Transcriptions]
    func add(title: String, result: String, duration: String, filename: String)
    func update(item: Transcriptions, newTitle: String, newResult: String, newTags: String)
}

class TranscriptionRepository: TranscriptionRepositoryDataStore {
    
    var coreData: TranscriptionCoreDataSource
    
    private init(coreData: TranscriptionCoreDataSource) {
        self.coreData = coreData
    }
    
    static let shared = TranscriptionRepository(coreData: TranscriptionCoreDataSource())
    
    func showAll() -> [Transcriptions] {
        return coreData.showAll()
    }
    
    func add(title: String, result: String, duration: String, filename: String) {
        coreData.add(title: title, result: result, duration: duration, filename: filename)
    }
    
    func update(item: Transcriptions, newTitle: String, newResult: String, newTags: String) {
        coreData.update(item: item, newTitle: newTitle, newResult: newResult, newTags: newTags)
    }
}