//
//  HomeViewController.swift
//  GCHomePage
//
//  Created by Steven Lie on 09/12/24.
//

import UIKit
import Combine

import GCCommon
import GCGames
import GCDetailGamePage
import GCDetailGame

public class HomeViewController: UIViewController {
    lazy var root = HomeView()
    private var viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        viewModel.getGamesData()
        
        root.gameGenreCollectionView.delegate = self
        root.gameGenreCollectionView.dataSource = self
        root.recommendedGameView.collectionView.delegate = self
        root.recommendedGameView.collectionView.dataSource = self
        root.popularGamesView.collectionView.delegate = self
        root.popularGamesView.collectionView.dataSource = self
        
        setupInteractions()
        setupBindings()
        
        if UserDefault.name.load() == nil {
            UserDefault.name.save(value: "Steven Lie")
        }
        
        if UserDefault.email.load() == nil {
            UserDefault.email.save(value: "stevenliee1206@gmail.com")
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        root.headerView.setGreeting(
            greeting: "Welcome back,",
            username: UserDefault.name.load() as? String ?? "User",
            image: AssetResource.profileImage.render()
        )
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func setupBindings() {
        viewModel.$gameResult
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

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        root.gameGenreCollectionView.automaticallyAdjustsContentSize()
        root.popularGamesView.collectionView.automaticallyAdjustsContentSize()
    }
    
    fileprivate func setupInteractions() {
        root.recommendedGameView.tryAgainBtnDidTapped = { [weak self] in
            self?.viewModel.getGamesData()
        }
        
        root.popularGamesView.tryAgainBtnDidTapped = { [weak self] in
            self?.viewModel.getGamesData()
        }
    }

    fileprivate func createGameGenreCollectionCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameGenreCell.cellIdentifier,
            for: indexPath) as? GameGenreCell
        else { return UICollectionViewCell() }
        cell.model = viewModel.gameGenreData.get(indexPath.item)

        cell.setNeedsLayout()
        
        return cell
    }

    fileprivate func createRecommendedGameCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedGameCell.cellIdentifier,
            for: indexPath) as? RecommendedGameCell
        else { return UICollectionViewCell() }

        cell.model = viewModel.getSpecificGame(idx: indexPath.item)
        
        return cell
    }

    fileprivate func createGameCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCell.cellIdentifier,
            for: indexPath) as? GameCell
        else { return UICollectionViewCell() }

        cell.model = viewModel.getSpecificGame(idx: indexPath.item)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return viewModel.gameGenreData.count
        case 1:
            let count = viewModel.getGamesCount()
            return count >= 7 ? 7 : count
        case 2:
            return viewModel.getGamesCount()
        default:
            return 0
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            let cell = GameGenreCell()
            cell.model = viewModel.gameGenreData.get(indexPath.item)

            cell.setNeedsLayout()
            let width = (UIScreen.main.fixedCoordinateSpace.bounds.width - 32) / 5
            let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let size = CGSize(width: width, height: height)
            return size
        case 1:
            let cell = RecommendedGameCell()
            cell.model = viewModel.getSpecificGame(idx: indexPath.item)

            let width = collectionView.getCleanBounds().width - 64
            let height = collectionView.getCleanBounds().height
            let size = CGSize(width: width, height: height)
            return size
        case 2:
            let cell = GameCell()
            cell.model = viewModel.getSpecificGame(idx: indexPath.item)

            let width = collectionView.getCleanBounds().width - 32
            let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let size = CGSize(width: width, height: height)
            return size
        default:
            return CGSize()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            showAlert("Yuhu", message: "Coming soon!")
        default:
            handleGameCellDidTap(collectionView, didSelectItemAt: indexPath)
        }
    }

    func handleGameCellDidTap(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = viewModel.getSpecificGame(idx: indexPath.item)
        else { return }
        
        let detailUseCase = DetailGameInjection().provideDetailGame()
        let detailGameVC = GameDetailViewController(gameId: data.id, detailGameUseCase: detailUseCase)
        detailGameVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailGameVC, animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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
