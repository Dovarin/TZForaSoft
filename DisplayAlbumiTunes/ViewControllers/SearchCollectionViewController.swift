import UIKit

protocol TableViewControllerDelegate {
    func updateArtistName(searchName: String, closure: () -> Void)
}

class SearchCollectionViewController: UICollectionViewController {
    
    let cellID = "searchCVCell"
    let itemsPerRow: CGFloat = 4
    let sectionBound: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    let searchController = UISearchController(searchResultsController: nil)
    let connect = Connectivity()
    var albumsData: ResultAlbums?
    var artistName = ""
    
    // MARK: - viewWillAppear()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        setupSearchController()
    }
    
    // MARK: - viewWillAppear()
    
    override func viewWillAppear(_ animated: Bool) {
        if DataManager.shared.indexOfAppearance == 1 {
            fetchData(album: DataManager.shared.nameArtist)
            searchController.searchBar.text = DataManager.shared.nameArtist
            collectionView.reloadData()
        } else {
            DataManager.shared.indexOfAppearance = 0
        }
    }
    
    //MARK: - setupSearchController()
    
    private func setupSearchController() {
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search album"
        searchController.searchBar.barTintColor = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .black
        }
    }
    
    func fetchData(album: String?) {
        if Connectivity.isConnectedToNetwork {
            
            NetworkManager.shared.fetch(dataType: ResultAlbums.self, url: NetworkManager.shared.urlForAlbums(term: album!)) { result in
                switch result {
                case .success(let albums):
                    self.albumsData = albums
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            let alert = UIAlertController(title: "No Network", message: "Check the network connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func save(_ searchName: String) {
        StorageManager.shared.save(searchName)
    }
    
    // MARK: - UICollectionViewDataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albumsData?.resultCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CollectionViewCell
        cell.configure(with: albumsData?.results[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailVC
        if let indexPath = collectionView.indexPathsForSelectedItems?.first{
            detailVC.actor = (albumsData?.results[indexPath.item].artistName) ?? ""
            detailVC.collectionId = (albumsData?.results[indexPath.item].collectionId) ?? 0
            detailVC.album = (albumsData?.results[indexPath.item].collectionName) ?? ""
            detailVC.imageURL = (albumsData?.results[indexPath.item].artworkUrl100) ?? ""
        }
        guard let navigationVC = segue.destination as? UINavigationController else {return}
        guard let historyVC = navigationVC.topViewController as? TableViewController else { return }
        historyVC.delegate = self
    }
}

//MARK: - TableViewController Delegate

extension SearchCollectionViewController: TableViewControllerDelegate{
    
    func updateArtistName(searchName: String, closure: () -> Void) {
        artistName = searchName
        fetchData(album: searchName)
        searchController.searchBar.text = searchName
    }
    
}
