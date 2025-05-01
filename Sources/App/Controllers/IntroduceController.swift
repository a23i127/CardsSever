//
//  File.swift
//  CardsSever
//
//  Created by 高橋沙久哉 on 2025/04/22.
//

import Foundation
import Vapor
import Fluent
struct ImageAndTextController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.post("textCreate", use: createTextHandler)
        routes.get("textGet",use: allGetTextHandler)
        routes.delete("textDelete",":id",use: deletTextHandler)
        routes.put("textPut",":id",use: putTextHandler)
        routes.get("introSearch",use: searchCard)
    }
    //Text
    func createTextHandler(req: Request) async throws -> [IntroduceDataModel] {
        let text = try req.content.decode([IntroduceDataModel].self) // ← 配列にする！
            for text in text {
                try await text.save(on: req.db)
            }
        return text
    }
    func allGetTextHandler(req: Request) async throws -> [IntroduceDataModel] {
        let textData = try await IntroduceDataModel.query(on: req.db).all()
        print(textData)
        return textData
    }
    func putTextHandler(req: Request) async throws -> IntroduceDataModel {
        let putObject = try await req.content.decode(IntroduceDataModel.self)
        guard let data = try await IntroduceDataModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        data.position = putObject.position
        data.text = putObject.text
        data.kategori = putObject.kategori
        data.photo = putObject.photo
        try await data.update(on: req.db)
        return data
    }
    func deletTextHandler(req: Request) async throws -> HTTPStatus {
        guard let user = try await IntroduceDataModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }
    func searchCard(req: Request) async throws -> [IntroduceDataModel] {
        var queryObuj = IntroduceDataModel.query(on: req.db)
        if let kategoriString = req.query[String.self, at: "kategori"] {
            queryObuj = queryObuj.filter(\IntroduceDataModel.$kategori ~~ kategoriString)
        } else {
            print("No label parameter provided")
        }
        if let dataContentString = req.query[String.self, at: "dataContent"] {
            queryObuj = queryObuj.filter(\IntroduceDataModel.$dataContent ~~ dataContentString)
        } else {
            print("No label parameter provided")
        }
        let result = try await queryObuj.all()
        return result
    }
}
