//
//  ProfileViewController.swift
//  GCProfilePage
//
//  Created by Steven Lie on 13/12/24.
//

import UIKit
import Combine

import GCProfile
import GCCommon

public class ProfileViewController: UIViewController {
    lazy var root = ProfileView()

    private var viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    /// <#Description#>
    public override func viewDidLoad() {
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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getActivityLog()
        viewModel.getUserData()
    }
    
    fileprivate func setupBindings() {
        viewModel.$activitiesLog
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
        
        viewModel.$email
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.root.emailLbl.text = data
            }
            .store(in: &cancellables)
        
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.root.nameLbl.text = data
            }
            .store(in: &cancellables)
    }
    
    fileprivate func createActivityLogCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LogCell.cellIdentifier,
            for: indexPath) as? LogCell
        else { return UICollectionViewCell() }

        cell.model = viewModel.activitiesLog.get(indexPath.item)
        
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.activitiesLog.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return createActivityLogCell(collectionView, cellForItemAt: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = LogCell()
        
        cell.model = viewModel.activitiesLog.get(indexPath.item)

        let width = collectionView.getCleanBounds().width - 32
        let height = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let size = CGSize(width: width, height: height)
        
        return size
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
