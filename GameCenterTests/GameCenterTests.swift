//
//  GameCenterTests.swift
//  GameCenterTests
//
//  Created by Steven Lie on 29/10/24.
//

import XCTest
import Combine
import Alamofire
@testable import GameCenter

final class GameCenterTests: XCTestCase {
    var viewModel: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        DependencyInjection.reset() // Reset the DI to clear any previous registrations

        let sampleGames = Games(results: [
            GameModel(id: 0, name: "Game 1", released: "", backgroundImage: "", rating: 0, ratingTop: 0, genres: nil, shortScreenshots: nil),
            GameModel(id: 1, name: "Game 2", released: "", backgroundImage: "", rating: 0, ratingTop: 0, genres: nil, shortScreenshots: nil),
            GameModel(id: 2, name: "Game 3", released: "", backgroundImage: "", rating: 0, ratingTop: 0, genres: nil, shortScreenshots: nil)
        ], error: nil)
        
        let mockNetworkManager = MockNetworkManager(mockGames: sampleGames)
        
        // Register the mock instance
        DependencyInjection.shared.container.register(NetworkManagerProtocol.self) { _ in
            return mockNetworkManager
        }

        // Resolve HomeViewModel
        viewModel = DependencyInjection.shared.container.resolve(HomeViewModel.self)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        cancellables.removeAll()
    }
    
    func testFetchGamesSuccess() {
        let expectation = self.expectation(description: "Fetch games successfully")
        
        viewModel.$gameResult
            .sink { result in
                switch result {
                case .success(let games):
                    XCTAssertEqual(games?.results?.count, 3, "Expected 3 games in the list")
                    expectation.fulfill()
                case .failure, .loading:
                    break
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
        
        viewModel.getGamesData()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchGamesFailure() {
        let mockNetworkManager = MockNetworkManager(mockError: AFError.explicitlyCancelled)

        // Register the mock instance for failure case
        DependencyInjection.shared.container.register(NetworkManagerProtocol.self) { _ in
            return mockNetworkManager
        }

        // Resolve HomeViewModel again
        viewModel = DependencyInjection.shared.container.resolve(HomeViewModel.self)
        
        let expectation = self.expectation(description: "Fetch games failure")
        
        viewModel.$gameResult
            .sink { result in
                if case .failure = result {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.getGamesData()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
