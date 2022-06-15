//
//  TranscriptionCoreDataSource.swift
//  NYHM
//
//  Created by Hafizh Mo on 13/06/22.
//

import Foundation
import CoreData

struct TranscriptionCoreDataSource: TranscriptionRepositoryDataStore {
    
    private let context = CoreDataManager.shared.context
    
    func showAll(sortBy: SortType) -> [Transcriptions] {
        let transcriptionRequest: NSFetchRequest = Transcriptions.fetchRequest()
        let sort = sortBy.getSortDescription()
        transcriptionRequest.sortDescriptors = [sort]
        
        guard let transcriptions = try? context.fetch(transcriptionRequest)
        else {
            return []
        }
        
        return transcriptions
    }
    
    func add(title: String, result: String, duration: String, filename: String) {
        let newTranscription = Transcriptions(context: context)
        newTranscription.title = title
        newTranscription.result = result
        newTranscription.duration = duration
        newTranscription.filename = filename
        newTranscription.createdAt = Date()
        newTranscription.tags = "Untagged"
        
        do {
            try context.save()
        } catch {
            print("Failed to add new transcription!")
        }
    }
    
    func update(item: Transcriptions, newTitle: String, newResult: String, newTags: String) {
        item.title = newTitle
        item.result = newResult
        item.tags = newTags
        
        do {
            try context.save()
        } catch {
            print("Failed to update transcription!")
        }
    }
    
    func delete(item: Transcriptions) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete transcription!")
        }
    }
}
