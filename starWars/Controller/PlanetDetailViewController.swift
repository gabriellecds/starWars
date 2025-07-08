import UIKit

class PlanetDetailViewController: UIViewController {
    
    var planet: Planet?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var terrainLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var diameterLabel: UILabel!
    @IBOutlet weak var gravityLabel: UILabel!
    @IBOutlet weak var orbitalLabel: UILabel!
    @IBOutlet weak var rotationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        guard let planet = planet else { return }
       
        nameLabel.text = planet.name
        climateLabel.text = "Climate: \(safeText(planet.climate))"
        terrainLabel.text = "Terrain: \(safeText(planet.terrain))"
        populationLabel.text = "Population: \(safeText(planet.population))"
        diameterLabel.text = "Diameter: \(safeText(planet.diameter))"
        gravityLabel.text = "Gravity: \(safeText(planet.gravity))"
        orbitalLabel.text = "Orbital Period: \(safeText(planet.orbital_period))"
        rotationLabel.text = "Rotation Period: \(safeText(planet.rotation_period))"
    }
    
    //evita que a resposta unknown ou valores vazios causem crashes
    func safeText(_ value: String) -> String {
        let cleaned = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                return cleaned == "unknown" || cleaned == "n/a" || cleaned.isEmpty ? "Not available" : value
    }
}
