//
//  FavoriteViewController.swift
//  GameCenter
//
//  Created by Steven Lie on 18/08/21.
//

import UIKit
import CoreData
import Combine

class FavoriteViewController: UIViewController {
    lazy var root = FavoriteView()
    
    let viewModel = DependencyInjection.shared.container.resolve(FavoriteViewModel.self)
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        navigationItem.title = "Favorite"
        
        root.favoriteGameView.collectionView.delegate = self
        root.favoriteGameView.collectionView.dataSource = self
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        viewModel?.getFavoriteGames()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func setupBindings() {
        viewModel?.$favoriteGames
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                if data.isEmpty {
                    self?.root.favoriteGameView.setState(.empty)
                } else {
                    self?.root.favoriteGameView.setState(.success)
                }
                self?.root.favoriteGameView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    fileprivate func createFavGameCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCell.cellIdentifier,
            for: indexPath) as? GameCell
        else { return UICollectionViewCell() }

        cell.favGameModel = viewModel?.favoriteGames.get(indexPath.item)
        
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.favoriteGames.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return createFavGameCell(collectionView, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = GameCell()
        cell.favGameModel = viewModel?.favoriteGames.get(indexPath.item)

        let width = collectionView.getCleanBounds().width - 32
        let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let size = CGSize(width: width, height: height)
        
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel?.favoriteGames.get(indexPath.item)
        else { return }
        
        let detailGameVC = GameDetailViewController(gameId: Int(data.id))
        detailGameVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailGameVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
