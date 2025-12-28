//
//  SwiftDataManager.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import SwiftData

protocol PersistenceManaging {
    associatedtype Entity: PersistentModel

    func save(_ item: Entity) throws
    func save(_ items: [Entity]) throws
    func fetch(predicate: Predicate<Entity>?, sortBy: [SortDescriptor<Entity>]) throws -> [Entity]
    func fetchAll(sortBy: [SortDescriptor<Entity>]) throws -> [Entity]
    func delete(_ item: Entity) throws
    func deleteAll() throws
}

@MainActor
final class SwiftDataManager<Entity: PersistentModel>: PersistenceManaging {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Save Operations

    func save(_ item: Entity) throws {
        modelContext.insert(item)
        try modelContext.save()
    }

    func save(_ items: [Entity]) throws {
        items.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    // MARK: - Fetch Operations

    func fetch(predicate: Predicate<Entity>? = nil, sortBy: [SortDescriptor<Entity>] = []) throws -> [Entity] {
        var descriptor = FetchDescriptor<Entity>(sortBy: sortBy)
        descriptor.predicate = predicate
        return try modelContext.fetch(descriptor)
    }

    func fetchAll(sortBy: [SortDescriptor<Entity>] = []) throws -> [Entity] {
        let descriptor = FetchDescriptor<Entity>(sortBy: sortBy)
        return try modelContext.fetch(descriptor)
    }

    // MARK: - Delete Operations

    func delete(_ item: Entity) throws {
        modelContext.delete(item)
        try modelContext.save()
    }

    func deleteAll() throws {
        let descriptor = FetchDescriptor<Entity>()
        let allItems = try modelContext.fetch(descriptor)
        allItems.forEach { modelContext.delete($0) }
        try modelContext.save()
    }
}
