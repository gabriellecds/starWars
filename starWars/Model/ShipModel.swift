import Foundation

struct Ship: Codable {
    let name: String
    let model: String
    let manufacturer: String
    let cost_in_credits: String
    let length: String
    let crew: String
    let passengers: String
    let starship_class: String
}

struct ShipResponse: Codable {
    let results: [Ship]
}
