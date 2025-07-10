import UIKit

class PlanetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var planets: [Planet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        fetchPlanets(searchText: "")
    }
    
    func fetchPlanets(searchText: String) {
        let urlString = "https://swapi.py4e.com/api/planets/?search=\(searchText)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(PlanetResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.planets = result.results
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Erro ao decodificar planetas: \(error)")
                }
            }
        }.resume()
    }

    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath)
        let planet = planets[indexPath.row]
        cell.textLabel?.text = planet.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlanet = planets[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "PlanetDetailViewController") as? PlanetDetailViewController {
            detailVC.planet = selectedPlanet
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchPlanets(searchText: query)
        searchBar.resignFirstResponder()
    }
}

