import UIKit

class ShipsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ships: [Ship] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        fetchShips(searchText: "")
    }
    
    func fetchShips(searchText: String) {
        let urlString = "https://swapi.py4e.com/api/starships/?search=\(searchText)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) {data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ShipResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.ships = result.results
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Erro ao decodificar naves: \(error)")
                }
            }
        }.resume()
    }

    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ships.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShipCell", for: indexPath)
        let ship = ships[indexPath.row]
        cell.textLabel?.text = ship.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedShip = ships[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ShipDetailViewController") as? ShipDetailViewController {
            detailVC.ship = selectedShip
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        fetchShips(searchText: query)
        searchBar.resignFirstResponder()
    }
}

