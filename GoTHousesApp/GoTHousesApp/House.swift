//
//  House.swift
//  GoTHousesApp
//
//  Created by Felix Desiderato on 02.05.22.
//

import Foundation
import UIKit

struct House: Codable {
    let url: String
    let name: String
    let region: String
    let coatOfArms: String
    let words: String
    let titles: [String]
    let seats: [String]
    let currentLord: String
    let heir: String
    let overlord: String
    let founded: String
    let founder: String
    let diedOut: String
    let ancestralWeapons: [String]
    let cadetBranches: [String]
    let swornMembers: [String]
}

//struct House: Codable {
//    let url: URL
//    let name: String
//    let region: String
//    let coatOfArms: String
//    let words: String
//    let titles: [String]
//    let seats: [String]
//    let currentLord: URL
//    let heir: URL
//    let overlord: URL
//    let founded: String
//    let founder: String
//    let diedOut: String
//    let ancestralWeapons: [String]
//    let cadetBranches: [URL]
//    let swornMembers: [URL]
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.url = try container.decode(URL.self, forKey: .url)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.region = try container.decode(String.self, forKey: .region)
//        self.coatOfArms = try container.decode(String.self, forKey: .coatOfArms)
//        self.words = try container.decode(String.self, forKey: .words)
//        self.titles = try container.decode([String].self, forKey: .titles)
//        self.seats = try container.decode([String].self, forKey: .seats)
//        URL.
//        self.currentLord = try container.decode(URL.self, forKey: .currentLord)
//        self.heir = try container.decode(URL.self, forKey: .heir)
//        self.overlord = try container.decode(URL.self, forKey: .overlord)
//        self.founded = try container.decode(String.self, forKey: .founded)
//        self.founder = try container.decode(String.self, forKey: .founder)
//        self.diedOut = try container.decode(String.self, forKey: .diedOut)
//        self.ancestralWeapons = try container.decode([String].self, forKey: .ancestralWeapons)
//        self.cadetBranches = try container.decode([URL].self, forKey: .cadetBranches)
//        self.swornMembers = try container.decode([URL].self, forKey: .swornMembers)
//    }
//}


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
/* name    string    The name of this character
gender    string    The gender of this character.
culture    string    The culture that this character belongs to.
born    string    Textual representation of when and where this character was born.
died    string    Textual representation of when and where this character died.
titles    array of strings    TThe titles that this character holds.
aliases    array of strings    The aliases that this character goes by.
father    string    The character resource URL of this character's father.
mother    string    The character resource URL of this character's mother.
spouse    string    An array of Character resource URLs that has had a POV-chapter in this book.
allegiances    array of strings    An array of House resource URLs that this character is loyal to.
books    array of strings    An array of Book resource URLs that this character has been in.
povBooks    array of strings    An array of Book resource URLs that this character has had a POV-chapter in.
tvSeries    array of strings    An array of names of the seasons of Game of Thrones that this character has been in.
playedBy    array of strings    An array of actor names that has played this character in the TV show Game Of Thrones.
 */
