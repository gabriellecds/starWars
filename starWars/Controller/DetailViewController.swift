
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet weak var skinColorLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    
    }

    func configureView (){
          guard let character = character else { return }
          nameLabel.text = "Name: \(character.name)"
          heightLabel.text = "Height: \(character.height)"
          massLabel.text = "Mass: \(character.mass) KILOGRAMS"
          hairColorLabel.text = "Hair Color: \(character.hair_color)"
          skinColorLabel.text = "Skin Color: \(character.skin_color)"
          eyeColorLabel.text = "Eye Color: \(character.eye_color)"
          birthYearLabel.text = "Birth Year: \(character.birth_year)"
          genderLabel.text = "Gender: \(character.gender)"
    }
    
}
