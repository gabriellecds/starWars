import UIKit

struct Character: Codable {
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
}

struct CharacterResponse: Codable {
    let results: [Character]
}

class CharactersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var characters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.lowercased(), !query.isEmpty else { return }
        fetchCharacters(searchText: query)
        searchBar.resignFirstResponder()
    }
    
    func fetchCharacters(searchText: String) {
        //dominio alternativo pois o oficial nao funcionou (erro de SSL (-1200): nao conseguiu estabelecer uma conexao segura
        let urlString = "https://swapi.py4e.com/api/people/?search=\(searchText)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.characters = result.results
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Erro ao decodificar: ", error)
                }
            }
        }.resume()
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        let character = characters[indexPath.row]
        cell.textLabel?.text = character.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = characters[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.character = selectedCharacter
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
