//
//  TagsRepository.swift
//  NYHM
//
//  Created by Hafizh Mo on 13/06/22.
//

import Foundation

protocol TagsRepositoryDataSource {
    func getAll() -> [Tags]
    func add(name: String, position: Int)
    func delete(item: Tags)
}

class TagsRepository: TagsRepositoryDataSource {
    private var coreData: TagsCoreDataSource
    
    private init(coreData: TagsCoreDataSource) {
        self.coreData = coreData
    }
    
    static let shared = TagsRepository(coreData: TagsCoreDataSource())
    
    func getAll() -> [Tags] {
        coreData.getAll()
    }
    
    func add(name: String, position: Int) {
        coreData.add(name: name, position: position)
    }
    
    func update(name: String, position: Int64, item: Tags) {
        coreData.update(name: name, position: position, item: item)
    }
    
    func delete(item: Tags) {
        coreData.delete(item: item)
    }
    
}
