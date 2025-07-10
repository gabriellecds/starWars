import Foundation

struct Planet: Codable {
    let name: String
    let climate: String
    let terrain: String
    let population: String
    let diameter: String
    let gravity: String
    let orbital_period: String
    let rotation_period: String
}

struct PlanetResponse: Codable {
    let results: [Planet]
}
