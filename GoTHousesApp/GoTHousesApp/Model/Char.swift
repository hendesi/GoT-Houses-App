//
//  Char.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 04.05.22.
//

import Foundation

struct Char: Codable {
    let url: String
    let name: String
    let gender: String
    let culture: String
    let born: String
    let died: String
    let titles: [String]
    let aliases: [String]
    let father: String
    let mother: String
    let spouse: String
    let tvSeries: [String]
    let playedBy: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        self.name = try container.decode(String.self, forKey: .name)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.culture = try container.decode(String.self, forKey: .culture)
        self.born = try container.decode(String.self, forKey: .born)
        self.died = try container.decode(String.self, forKey: .died)
        self.titles = try container.decode([String].self, forKey: .titles)
        self.aliases = try container.decode([String].self, forKey: .aliases)
        self.father = try container.decode(String.self, forKey: .father)
        self.mother = try container.decode(String.self, forKey: .mother)
        self.spouse = try container.decode(String.self, forKey: .spouse)
        self.tvSeries = try container.decode([String].self, forKey: .tvSeries)
        self.playedBy = try container.decode([String].self, forKey: .playedBy)
    }
}
