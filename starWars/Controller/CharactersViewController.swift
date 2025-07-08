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
    let species: [String]
}

struct CharacterResponse: Codable {
    let results: [Character]
}

struct Species: Codable {
    let name: String
}

class CharactersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet var speciesButtons: [UIButton]!
    @IBOutlet var genderButtons: [UIButton]!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func filterButton(_ sender: UIButton) {
        filterView.isHidden.toggle()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var characters: [Character] = []
    var speciesNameCache: [String: String] = [:]
    
    var selectedSpecies: String?
    var selectedGender: String?
    
    let speciesByTag: [Int: String] = [
        0: "human",
        1: "droid",
        2: "ewoks",
        3: "keshiri",
        4: "zeltrons",
        5: "jawas"
    ]
    
    let genderByTag: [Int: String] = [
        0: "male",
        1: "female",
        2: "n/a"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filterView.isHidden = true
        
        fetchCharacters(searchText: "")
    
    }
    
    @IBAction func speciesButtonTapped(_ sender: UIButton) {
        //print("🔘 Botão clicado: tag \(sender.tag)")
        // Destaque visual: deixa todos apagados, só o clicado com destaque
        // Remove seleção anterior visual (opcional)
        speciesButtons.forEach { $0.alpha = 0.5 }
        sender.alpha = 1.0
        
        if let speciesName = speciesByTag[sender.tag]{
            selectedSpecies = speciesName
            //print("✅ Espécie selecionada via tag: \(speciesName)")
        } else {
            selectedSpecies = nil
            //print("⚠️ Nenhuma espécie encontrada para essa tag.")
        }
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        //print("👕 Botão de gênero clicado: tag \(sender.tag)")
        
        genderButtons.forEach { $0.alpha = 0.5 }
        sender.alpha = 1.0

        if let gender = genderByTag[sender.tag] {
            selectedGender = gender
            //print("✅ Gênero selecionado via tag: \(gender)")
        } else {
            selectedGender = nil
            //print("⚠️ Nenhum gênero encontrado para essa tag.")
        }
    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        fetchCharacters(searchText: searchBar.text ?? "")
        filterView.isHidden = true
    }
    
    @IBAction func resetFilters(_ sender: UIButton) {
        selectedSpecies = nil
        selectedGender = nil

        // Reseta visual
        speciesButtons.forEach { $0.alpha = 1.0 }
        genderButtons.forEach { $0.alpha = 1.0 }

        fetchCharacters(searchText: searchBar.text ?? "")
        filterView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.lowercased(), !query.isEmpty else { return }
        fetchCharacters(searchText: query)
        searchBar.resignFirstResponder()
    }
    
    func fetchCharacters(searchText: String) {
        let urlString = "https://swapi.py4e.com/api/people/?search=\(searchText)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    let fetchedCharacters = result.results

                    let group = DispatchGroup()
                    var tempCache: [String: String] = [:]

                    for character in fetchedCharacters {
                        for speciesURL in character.species {
                            if self.speciesNameCache[speciesURL] == nil && tempCache[speciesURL] == nil {
                                group.enter()
                                URLSession.shared.dataTask(with: URL(string: speciesURL)!) { data, _, _ in
                                    if let data = data {
                                        if let speciesData = try? JSONDecoder().decode(Species.self, from: data) {
                                            tempCache[speciesURL] = speciesData.name.lowercased()
                                        }
                                    }
                                    group.leave()
                                }.resume()
                            }
                        }
                    }

                    group.notify(queue: .main) {
                        // Atualiza o cache global
                        for (url, name) in tempCache {
                            self.speciesNameCache[url] = name
                        }

                        var filtered = fetchedCharacters

                        if let gender = self.selectedGender {
                            filtered = filtered.filter {
                                $0.gender.lowercased() == gender
                            }
                        }

                        if let speciesFilter = self.selectedSpecies {
                            //print("Filtro de espécie selecionado: \(speciesFilter)")
                            filtered = filtered.filter { character in
                                character.species.contains { url in
                                    self.speciesNameCache[url] == speciesFilter
                                }
                            }
                        }

                        self.characters = filtered
                        self.tableView.reloadData()
                    }

                } catch {
                    print("Erro ao decodificar personagens: \(error)")
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
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailCharactersViewController") as? DetailCharactersViewController {
            detailVC.character = selectedCharacter
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
