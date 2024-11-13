//
//  ViewController.swift
//  GameCenter
//
//  Created by Steven Lie on 16/08/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    lazy var root = HomeView()
//    lazy var viewModel = HomeViewModel()
    let viewModel = DependencyInjection.shared.container.resolve(HomeViewModel.self)
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        viewModel?.getGamesData()
        
        root.gameGenreCollectionView.delegate = self
        root.gameGenreCollectionView.dataSource = self
        root.recommendedGameView.collectionView.delegate = self
        root.recommendedGameView.collectionView.dataSource = self
        root.popularGamesView.collectionView.delegate = self
        root.popularGamesView.collectionView.dataSource = self
        
        setupInteractions()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        root.headerView.setGreeting(
            greeting: "Welcome back,",
            username: UserDefault.name.load() as? String ?? "",
            image: UIImage(named: "profileImage") ?? UIImage()
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func setupBindings() {
        viewModel?.$gameResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self, let result else { return }
                
                switch result {
                case .success:
                    root.recommendedGameView.setState(.success)
                    root.popularGamesView.setState(.success)
                    root.recommendedGameView.collectionView.reloadData()
                    root.popularGamesView.collectionView.reloadData()
                    root.popularGamesView.collectionView.automaticallyAdjustsContentSize()
                case .loading:
                    root.recommendedGameView.setState(.loading)
                    root.popularGamesView.setState(.loading)
                case .failure(let errorMessage):
                    root.recommendedGameView.stateAction = { [weak self] in
                        self?.showAlert("Failed", message: errorMessage)
                    }
                    root.recommendedGameView.setState(.failed)
                    root.popularGamesView.setState(.failed)
                }
            }
            .store(in: &cancellables)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        root.gameGenreCollectionView.automaticallyAdjustsContentSize()
        root.popularGamesView.collectionView.automaticallyAdjustsContentSize()
    }
    
    fileprivate func setupInteractions() {
        root.recommendedGameView.tryAgainBtnDidTapped = { [weak self] in
            self?.viewModel?.getGamesData()
        }
        
        root.popularGamesView.tryAgainBtnDidTapped = { [weak self] in
            self?.viewModel?.getGamesData()
        }
    }

    fileprivate func createGameGenreCollectionCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameGenreCell.cellIdentifier,
            for: indexPath) as? GameGenreCell
        else { return UICollectionViewCell() }
        cell.model = viewModel?.gameGenreData.get(indexPath.item)

        cell.setNeedsLayout()
        
        return cell
    }

    fileprivate func createRecommendedGameCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedGameCell.cellIdentifier,
            for: indexPath) as? RecommendedGameCell
        else { return UICollectionViewCell() }

        cell.model = viewModel?.getSpecificGame(idx: indexPath.item)
        
        return cell
    }

    fileprivate func createGameCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCell.cellIdentifier,
            for: indexPath) as? GameCell
        else { return UICollectionViewCell() }

        cell.model = viewModel?.getSpecificGame(idx: indexPath.item)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return viewModel?.gameGenreData.count ?? 0
        case 1:
            guard let count = viewModel?.getGamesCount() else { return 0 }
            return count >= 7 ? 7 : count
        case 2:
            return viewModel?.getGamesCount() ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            return createGameGenreCollectionCell(collectionView, cellForItemAt: indexPath)
        case 1:
            return createRecommendedGameCell(collectionView, cellForItemAt: indexPath)
        case 2:
            return createGameCell(collectionView, cellForItemAt: indexPath)
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            let cell = GameGenreCell()
            cell.model = viewModel?.gameGenreData.get(indexPath.item)

            cell.setNeedsLayout()
            let width = (root.gameGenreCollectionView.frame.size.width) / 5
            let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let size = CGSize(width: width, height: height)
            return size
        case 1:
            let cell = RecommendedGameCell()
            cell.model = viewModel?.getSpecificGame(idx: indexPath.item)

            let width = collectionView.getCleanBounds().width - 64
            let height = collectionView.getCleanBounds().height
            let size = CGSize(width: width, height: height)
            return size
        case 2:
            let cell = GameCell()
            cell.model = viewModel?.getSpecificGame(idx: indexPath.item)

            let width = collectionView.getCleanBounds().width - 32
            let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let size = CGSize(width: width, height: height)
            return size
        default:
            return CGSize()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            showAlert("Yuhu", message: "Coming soon!")
        default:
            handleGameCellDidTap(collectionView, didSelectItemAt: indexPath)
        }
    }

    func handleGameCellDidTap(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel?.getSpecificGame(idx: indexPath.item)
        else { return }
        
        let detailGameVC = GameDetailViewController(gameId: data.id)
        detailGameVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailGameVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case 1:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case 2:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        default:
            return .zero
        }
    }
}
