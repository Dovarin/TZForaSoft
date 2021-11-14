import UIKit

class DetailVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameAlbum: UILabel!
    @IBOutlet weak var actorName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Private
    
    private var songsData: AlbumDetail?
    private var cellID = "song"
    
    var imageURL = ""
    var actor = ""
    var album = ""
    var collectionId = 0
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        actorName.text = actor
        nameAlbum.text = album
    
        guard let url = URL(string: imageURL) else { return }
        ImageManager.shared.fetchImage(from: url) { data, _  in
            self.imageView.image = UIImage(data: data)
        }
        
        fetchSongs()
    }
    
    //MARK: - fetchSongs()
    
    private func fetchSongs() {
        NetworkManager.shared.fetch(dataType: AlbumDetail.self, url: NetworkManager.shared.urlForSongsInAlbum(collectionId: collectionId)) { result in
            switch result {
            case .success(let songs):
                self.songsData = songs
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Table view data source

extension DetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (songsData?.resultCount ?? 0 ) - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = songsData?.results[indexPath.row + 1].trackCensoredName
        cell.contentConfiguration = content
        return cell
    }
}
