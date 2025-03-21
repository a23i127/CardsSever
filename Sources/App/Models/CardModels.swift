//
//  File.swift
//  cardData
//
//  Created by 高橋沙久哉 on 2025/01/14.
//
import Foundation
import Fluent
import Vapor
final class CardModels: Model,Content {
    static let schema = "cardData"
    @ID var id: UUID?
    @Field(key: "名前") var name: String
    @Field(key: "属性") var attribute: String
    @Field(key: "レベル") var lebel: String
    @Field(key: "種族") var race: String
    @Field(key: "imageUrl") var imageUrl: String
    @Field(key: "正式名称") var trueName: String
    @Field(key: "特徴") var description: String   //チューナー/効果　など（モンスターの詳細）
    @Field(key: "カテゴリ") var searchTag: String  //カードをカテゴリーで管理できるようにする
    init() {}
    init(id:UUID? = nil,name:String,attribute: String,lebel: String,race: String,imageUrl: String,trueName: String,description:String,searchTag:String) {
        self.id = id
        self.name = name
        self.attribute = attribute
        self.lebel = lebel
        self.race = race
        self.imageUrl = imageUrl
        self.trueName = trueName
        self.description = description
        self.searchTag = searchTag
    }
    
}
