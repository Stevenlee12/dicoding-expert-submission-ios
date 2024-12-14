//
//  File.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import UIKit
import CoreData
import Combine

import GCDetailGame

public final class GameDetailViewController: UIViewController {
    lazy var root = GameDetailView()
    
    lazy var gameLogo = ""
    lazy var isFav = false
    lazy var contentOffset = 0.0
    
    private var viewModel: GameDetailViewModel
    
    public init(viewModel: GameDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public convenience init(gameId: Int, detailGameUseCase: DetailGameUseCase) {
        let viewModel = GameDetailViewModel(detailGameUseCase: detailGameUseCase)
        viewModel.getGameDetail(gameId: gameId)
        
        self.init(viewModel: viewModel)
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        root.backgroundColor = .backgroundColor
        
        root.scrollView.delegate = self
        setupInteractions()
        
        setupBindings()
    }
    
    fileprivate func setupBindings() {
        viewModel.$detailGameResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self, let result else { return }
                
                switch result {
                case .success(let data):
                    guard let data else { return }
                    root.isLoading(false)
                    
                    root.setData(data: data)
                    gameLogo = data.backgroundImage ?? ""
                    
                    isFav = viewModel.checkFavoriteGameIsFavorited()
                    root.setFavoriteButton(isFav)
                    
                case .loading:
                    root.isLoading(true)
                case .failure(let errorMessage):
                    root.isLoading(false)
                    showAlert("Failed", message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
       return .lightContent
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.alpha = 0
        navigationController?.navigationBar.backItem?.title = "Home"
        navigationItem.hidesBackButton = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    fileprivate func setupInteractions() {
        root.backBtnDidTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        root.favBtnDidTapped = { [weak self] in
            guard let `self` = self else { return }
            self.isFav = !self.isFav
            self.root.setFavoriteButton(self.isFav)
            
            if self.contentOffset > 256 {
                self.setupRightBarItem(isFav: self.isFav)
            }
            
            var activityStatus = 0
            
            if self.isFav {
                self.viewModel.addFavoriteGame()
                activityStatus = 1
                
            } else {
                self.viewModel.deleteFavoriteGameById()
                activityStatus = 0
            }
            
            self.viewModel.addActivityLog(activityStatus: activityStatus)
        }
    }
    
    fileprivate func navigationItemView(_ showLogo: Bool) {
        let imageView = UIImageView()
        imageView.style {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        
        if showLogo {
            imageView.setImage(string: gameLogo)
        } else {
            imageView.image = UIImage()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        self.navigationItem.titleView = imageView
    }
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        root.scrollView.scrollToView(view: root.backgroundImg, animated: true)
    }
    
    fileprivate func setupRightBarItem(isFav: Bool) {
        let customButton = UIButton.init(type: .custom)
        customButton.text(isFav ? "ADDED!": "ADD")
        customButton.backgroundColor = isFav ? .baseColor : .systemBlue
        customButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        customButton.setTitleColor(.white, for: .normal)
        customButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 24, bottom: 4, right: 24)
        customButton.sizeToFit()
        customButton.setLayer(cornerRadius: 12)
        
        customButton.addTarget(self, action: #selector(rightBarBtnDidTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customButton)
    }
    
    @objc fileprivate func rightBarBtnDidTapped() {
        root.favBtnDidTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameDetailViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        
        if offset.y < 0.0 {
            var transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset.y, 0)
            let scaleFactor = 1 + (-1 * offset.y / (200 / 2))
            transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1)
            root.backgroundImg.layer.transform = transform
        } else {
            root.backgroundImg.layer.transform = CATransform3DIdentity
        }
        
        let onscrollPosition = scrollView.contentOffset.y.rounded() / 100.0
        navigationController?.navigationBar.alpha = (onscrollPosition > 1 ? 1 : onscrollPosition)
        self.navigationItem.hidesBackButton = (onscrollPosition > 1 ? false : true)
        
        contentOffset = scrollView.contentOffset.y.rounded()
        
        if scrollView.contentOffset.y.rounded() > 256 {
            setupRightBarItem(isFav: isFav)
            navigationItemView(true)
        } else {
            navigationItemView(false)
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }
}
