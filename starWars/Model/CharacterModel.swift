import Foundation

struct Character: Codable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let species: [String]
}

struct CharacterResponse: Codable {
    let results: [Character]
}

struct Species: Codable {
    let name: String
}
