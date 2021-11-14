import UIKit

class TableViewController: UITableViewController {
    
    var delegate: TableViewControllerDelegate!
    
    private let cellID = "historyTBCell"
    private var artists: [Search] = []
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        artists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = artists[indexPath.row].title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let search = artists[indexPath.row]
        
        if editingStyle == .delete {
            artists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(search)
        }
    }
    
    // MARK: - Table view data source delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = artists[indexPath.row].title else { return }

        DataManager.shared.nameArtist = name
        DataManager.shared.indexOfAppearance = 1
        tabBarController?.selectedIndex = 0
    }
    
    //MARK: -  fetchData()
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let artists):
                self.artists = artists
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
