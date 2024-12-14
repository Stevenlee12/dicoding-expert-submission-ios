//
//  SearchViewController.swift
//  GCSearchPage
//
//  Created by Steven Lie on 12/12/24.
//

import UIKit
import Combine

import GCGames
import GCDetailGamePage
import GCDetailGame

public final class SearchViewController: UIViewController {
    lazy var root = SearchView()
    
    private var viewModel: SearchViewModel
    
    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    var keyword = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        
        setupBindings()
        
        root.searchResultView.collectionView.delegate = self
        root.searchResultView.collectionView.dataSource = self
        root.searchBar.searchTextField.delegate = self
        
        dismissKeyboardOnTap()
        
        root.searchResultView.tryAgainBtnDidTapped = { [weak self] in
            self?.viewModel.searchGame(query: self?.keyword)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Binding the ViewModel to update UI
    private func setupBindings() {
        viewModel.$gameResult
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

        cell.model = viewModel.getSpecificGame(idx: indexPath.item)

        let width = collectionView.getCleanBounds().width - 32
        let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let size = CGSize(width: width, height: height)
        
        return size
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getGamesCount()
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCell.cellIdentifier,
            for: indexPath) as? GameCell
        else { return UICollectionViewCell() }
        
        cell.model = viewModel.getSpecificGame(idx: indexPath.item)
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getGameCellSize(collectionView, cellForItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel.getSpecificGame(idx: indexPath.item)
        else { return }
        
        let detailUseCase = DetailGameInjection().provideDetailGame()
        let detailGameVC = GameDetailViewController(gameId: data.id, detailGameUseCase: detailUseCase)
        
        detailGameVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailGameVC, animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension SearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let keyword = textField.text else { return true }
        self.keyword = keyword
        viewModel.searchGame(query: keyword)
        return false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.resetData()
        root.searchResultView.collectionView.reloadData()
        return true
    }
}
