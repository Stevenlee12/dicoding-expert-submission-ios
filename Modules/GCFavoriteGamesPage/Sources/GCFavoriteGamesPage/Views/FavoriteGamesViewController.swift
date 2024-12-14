//
//  FavoriteGamesViewController.swift
//  GCFavoriteGamesPage
//
//  Created by Steven Lie on 12/12/24.
//

import UIKit
import CoreData
import Combine

import GCGames
import GCDetailGamePage
import GCDetailGame

public class FavoriteGamesViewController: UIViewController {
    lazy var root = FavoriteView()
    
    private var viewModel: FavoriteGamesViewModel
    
    public init(viewModel: FavoriteGamesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        navigationItem.title = "Favorite"
        
        root.favoriteGameView.collectionView.delegate = self
        root.favoriteGameView.collectionView.dataSource = self
        
        setupBindings()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        viewModel.getFavoriteGames()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func setupBindings() {
        viewModel.$favoriteGames
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

        cell.favGameModel = viewModel.favoriteGames.get(indexPath.item)
        
        return cell
    }
}

extension FavoriteGamesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoriteGames.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return createFavGameCell(collectionView, cellForItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = GameCell()
        cell.favGameModel = viewModel.favoriteGames.get(indexPath.item)

        let width = collectionView.getCleanBounds().width - 32
        let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let size = CGSize(width: width, height: height)
        
        return size
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel.favoriteGames.get(indexPath.item)
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
