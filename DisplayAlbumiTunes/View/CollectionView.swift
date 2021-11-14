import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: CharImageView!
    
    func configure(with album: Album?) {
        image.getImage(from: album?.artworkUrl100 ?? "")
    }
}
