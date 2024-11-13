//
//  ProfileViewController.swift
//  GameCenter
//
//  Created by Steven Lie on 18/08/21.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    lazy var root = ProfileView()
    let viewModel = DependencyInjection.shared.container.resolve(ProfileViewModel.self)
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        title = "Profile"
        
        root.activityLogView.collectionView.delegate = self
        root.activityLogView.collectionView.dataSource = self
        
        root.profileViewDidTapped = { [weak self] in
            let editProfileVC = EditProfileViewController()
            self?.navigationController?.pushViewController(editProfileVC, animated: true)
        }
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getActivityLog()
        setupProfileData()
    }
    
    fileprivate func setupBindings() {
        viewModel?.$activitiesLog
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                if data.isEmpty {
                    self?.root.activityLogView.setState(.empty)
                } else {
                    self?.root.activityLogView.setState(.success)
                }
                
                self?.root.activityLogView.collectionView.reloadData()
                self?.root.activityLogView.collectionView.automaticallyAdjustsContentSize()
            }
            .store(in: &cancellables)
    }
    
    fileprivate func createActivityLogCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LogCell.cellIdentifier,
            for: indexPath) as? LogCell
        else { return UICollectionViewCell() }

        cell.model = viewModel?.activitiesLog.get(indexPath.item)
        
        return cell
    }
    
    fileprivate func setupProfileData() {
        root.nameLbl.text = UserDefault.name.load() as? String ?? ""
        root.emailLbl.text = UserDefault.email.load() as? String ?? ""
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.activitiesLog.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return createActivityLogCell(collectionView, cellForItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = LogCell()
        
        cell.model = viewModel?.activitiesLog.get(indexPath.item)

        let width = collectionView.getCleanBounds().width - 32
        let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let size = CGSize(width: width, height: height)
        
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
