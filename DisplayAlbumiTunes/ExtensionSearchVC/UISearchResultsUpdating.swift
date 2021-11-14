import UIKit

extension SearchCollectionViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {
        fetchData(album: searchText)
        save(searchText)
        collectionView.reloadData()
    }
}
