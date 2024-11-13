//
//  SearchViewController.swift
//  GameCenter
//
//  Created by Steven Lie on 18/08/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    lazy var root = SearchView()
    let viewModel = DependencyInjection.shared.container.resolve(SearchViewModel.self)
    
    private var cancellables = Set<AnyCancellable>()
    var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        
        setupBindings()
        
        root.searchResultView.collectionView.delegate = self
        root.searchResultView.collectionView.dataSource = self
        root.searchBar.searchTextField.delegate = self
        
        dismissKeyboardOnTap()
        
        root.searchResultView.tryAgainBtnDidTapped = { [weak self] in
            self?.viewModel?.searchGame(query: self?.keyword)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Binding the ViewModel to update UI
    private func setupBindings() {
        viewModel?.$gameResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self, let result else { return }
                
                switch result {
                case .success:
                    root.searchResultView.setState(.success)
                    root.searchResultView.collectionView.reloadData()
                case .loading:
                    root.searchResultView.setState(.loading)
                case .failure(let message):
                    root.searchResultView.setState(.failed)
                    showAlert("Error", message: message)
                }
                
            }
            .store(in: &cancellables)
    }
    
    fileprivate func getGameCellSize(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> CGSize {
        let cell = GameCell()

        cell.model = viewModel?.getSpecificGame(idx: indexPath.item)

        let width = collectionView.getCleanBounds().width - 32
        let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let size = CGSize(width: width, height: height)
        
        return size
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getGamesCount() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCell.cellIdentifier,
            for: indexPath) as? GameCell
        else { return UICollectionViewCell() }
        
        cell.model = viewModel?.getSpecificGame(idx: indexPath.item)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getGameCellSize(collectionView, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel?.getSpecificGame(idx: indexPath.item)
        else { return }
        
        let detailGameVC = GameDetailViewController(gameId: data.id)
        detailGameVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailGameVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let keyword = textField.text else { return true }
        self.keyword = keyword
        viewModel?.searchGame(query: keyword)
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel?.resetData()
        root.searchResultView.collectionView.reloadData()
        return true
    }
}
