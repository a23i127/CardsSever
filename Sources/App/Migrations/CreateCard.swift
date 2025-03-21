//
//  File.swift
//  CardServer
//
//  Created by 高橋沙久哉 on 2025/02/14.
//

//
//  File.swift
//  cardData
//
//  Created by 高橋沙久哉 on 2025/01/14.
//

import Foundation
import Fluent
struct CreateCard:AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("cardData")
            .id()
            .field("名前", .string)
            .field("属性", .string)
            .field("レベル", .string)
            .field("種族", .string)
            .field("imageUrl", .string)
            .field("正式名称",.string)
            .field("特徴",.string)
            .field("カテゴリ",.string)
            .create()
    }
    func revert(on database:Database) async throws {
        try await database.schema("cardData").delete()
    }
}
