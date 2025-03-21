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
import Vapor
import Fluent
struct CardController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.post("api","card", use: createHandler)
        routes.get("api","card",use: allGetHandler)
        routes.delete("api","users",":userID",use: deletHandler)
        routes.get("searchCard",use:searchCard)
    }
    func createHandler(req: Request) async throws -> CardModels {
        let card = try req.content.decode(CardModels.self)
        print(card)
        try await card.save(on: req.db)
        return card
    }
    func allGetHandler(req: Request) async throws -> [CardModels] {
        let cards = try await CardModels.query(on: req.db).all()
        return cards
    }
    func searchCard(req: Request) async throws -> [CardModels] {
        var queryObuj = CardModels.query(on: req.db)
        if let name = req.query[String.self, at: "name"] {
            let katakanaString = name.applyingTransform(.hiraganaToKatakana, reverse: false) //ひらがなをカタカナの変換
            if let katakanaString {
                queryObuj = queryObuj.filter(\CardModels.$name ~~ katakanaString)
            }
        } else {
            print("No label parameter provided1")
        }
        if let attribute = try? req.query.get([String].self, at: "attribute") {
            if attribute.count != 0{
                queryObuj.filter(\CardModels.$attribute ~~ attribute)
            }
        }
        else {
            print("No label parameter provided2")
        }
        if let lebel = try? req.query.get([String].self, at: "lebel") {
            if (lebel.count != 0) { //空配列はnilにならないので、ifletを通ってきてしまう
                queryObuj.filter(\CardModels.$lebel ~~ lebel)
            }
        }
        else {
            print("No label parameter provided3")
        }
        if let  race = try? req.query.get([String].self, at: "race") {
            if (race.count != 0) {
                queryObuj.filter(\CardModels.$race ~~ race)
            }
        }
        else {
            print("No label parameter provided4")
        }
        if let trueName = req.query[String.self, at: "trueName"] {
            print(trueName)
             queryObuj.filter(\CardModels.$trueName == trueName)
        }
        else {
            print("No label parameter provided5")
        }
        if let description = try? req.query.get([String].self,at:"description") {
            if description.count != 0{
                queryObuj.filter(\CardModels.$description ~~ description)
            }
        }
        else {
            print("No label parameter provided6")
        }
        if let searchTag = req.query[String.self, at: "searchTag"] {
             queryObuj.filter(\CardModels.$searchTag ~~ searchTag)
        }
        else {
            print("No label parameter provided7")
        }
        let result = try await queryObuj.all()
        return result
    }
    func deletHandler(req: Request) async throws -> HTTPStatus {
        guard let user = try await CardModels.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }
}
