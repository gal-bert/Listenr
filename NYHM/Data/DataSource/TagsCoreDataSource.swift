//
//  TagsCoreDataSource.swift
//  NYHM
//
//  Created by Hafizh Mo on 13/06/22.
//

import Foundation
import CoreData

struct TagsCoreDataSource: TagsRepositoryDataSource {
    
    private let context = CoreDataManager.shared.context
    
    func getAll() -> [Tags] {
        let tagsRequest: NSFetchRequest = Tags.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Tags.position), ascending: true)
        tagsRequest.sortDescriptors = [sort]
        
        guard let tags = try? context.fetch(tagsRequest)
        else {
            return []
        }
        
        return tags
    }
    
    func add(name: String, position: Int) {
        let newTags = Tags(context: context)
        newTags.name = name
        newTags.position = Int64(position)
        
        do {
            try context.save()
        } catch {
            print("Failed to add new tags!")
        }
    }
    
    func update(name: String, position: Int64, item: Tags) {
        item.name = name
        item.position = position
        
        do {
            try context.save()
        } catch {
            print("Failed to update tags!")
        }
    }
    
    func delete(item: Tags) {
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete tags!")
        }
    }
}
