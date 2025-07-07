import UIKit

class ShipDetailViewController: UIViewController {
    
    var ship: Ship?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var passengersLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        guard let ship = ship else { return }
       
           nameLabel.text = ship.name
           modelLabel.text = "Model: \(ship.model)"
           manufacturerLabel.text = "Manufacturer: \(ship.manufacturer)"
           costLabel.text = "Cost: \(ship.cost_in_credits)"
           lengthLabel.text = "Length: \(ship.length)"
           crewLabel.text = "Crew: \(ship.crew)"
           passengersLabel.text = "Passengers: \(ship.passengers)"
           classLabel.text = "Class: \(ship.starship_class)"
    
    }
    
    //evita que a resposta unknown ou valores vazios causem crashes
    func safeText(_ value: String) -> String {
        let cleaned = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                return cleaned == "unknown" || cleaned == "n/a" || cleaned.isEmpty ? "Not available" : value
    }
}
