//
//  File.swift
//  CardsSever
//
//  Created by 高橋沙久哉 on 2025/04/23.
//
import Foundation
import Fluent
struct Intro2Migration:AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("intro2")
            .id()
            .field("テキスト", .string)
            .field("position", .int)
            .field("カテゴリ", .string)
            .field("写真", .string)
            .create()
    }
    func revert(on database:Database) async throws {
        try await database.schema("intro2").delete()
    }
}

