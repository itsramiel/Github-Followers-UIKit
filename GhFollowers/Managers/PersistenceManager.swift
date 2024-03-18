//
//  PersistenceManager.swift
//  GhFollowers
//
//  Created by Rami Elwan on 17.03.24.
//

import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let favorites = "favorites"
    }
    
    enum PersistenceActionType {
        case add, remove
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    if favorites.contains(favorite) {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeFirst { $0.login == favorite.login}
                }
                completed(saveFavorites(favorites))
            case .failure(let failure):
                break
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToRetreiveFavs))
        }
    }
    
    static func saveFavorites(_ favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let favoritesData = try encoder.encode(favorites)
            defaults.setValue(favoritesData, forKey: Keys.favorites)
        } catch {
            return .unableToSaveFavs
        }
        
        return nil
    }
}
