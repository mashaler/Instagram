//
//  DMtableViewController.swift
//  Instagram
//
//  Created by Rolva Mashale on 2024/09/06.
//

import Foundation
import UIKit
import Firebase

enum UserCategorySearch: Int {
    case all = 0
    case followers
    case following
    static subscript(index: Int) -> UserCategorySearch {
        return UserCategorySearch(rawValue: index)!
    }
}

class DMtableViewController: UITableViewController {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
        searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    var user: User?
    var users = [User]()
    var lastMessages = [Message]()
    var filteredUsers = [User]()
    var followersIds = [String]()
    var followingIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserDMCell.self, forCellReuseIdentifier: cellId)
        setupNavBar()
        
    }
    
    let cellId = "cellId"

    private func setupNavBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView?.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        searchController.searchBar.scopeButtonTitles = ["All", "Followers", "Following"]
        fetchAllUsers()
        fetchFollowersIds()
        fetchFollowingIds()
    }
    
    private func fetchFollowersIds() {
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("followers").child(uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            if let dictionaries = snapshot.value as? [String:Any] {
                dictionaries.forEach { (arg) in
                    self.followersIds.append(arg.key)
                    //print("follower: \(arg.key)")
                }
            }
        }
    }
    
    private func fetchFollowingIds() {
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            if let dictionaries = snapshot.value as? [String:Any] {
                //print(dictionaries.keys)
                dictionaries.forEach { (arg) in
                    self.followingIds.append(arg.key)
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String, for category: UserCategorySearch) {
        filteredUsers = users.filter { (user: User) -> Bool in
            var doesCateforyMatch:Bool = false
            
            switch category {
            case .all:
                doesCateforyMatch = true
            case .followers:
                doesCateforyMatch = followersIds.contains { (str) -> Bool in
                    str == user.uid
                }
            case .following:
                doesCateforyMatch = followingIds.contains { (str) -> Bool in
                    str == user.uid
                }
            }
            if isSearchBarEmpty {
                return doesCateforyMatch
            } else {
                return doesCateforyMatch &&
                    user.username.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    private func fetchAllUsers() {
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            if let dictionaries = snapshot.value as? [String:Any] {
                //print(dictionaries.keys)
                dictionaries.forEach { (arg) in
                    let (key, value) = arg
                    let dictionary = value as! [String: Any]
                    let user = User(uid: key, dictionary: dictionary)
                    self.users.append(user)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagesTVC = MessagesTableViewController()
        if isFiltering {
            messagesTVC.user = filteredUsers[indexPath.row]
        } else {
            messagesTVC.user = users[indexPath.row]
        }
        navigationController?.pushViewController(messagesTVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserDMCell
        cell.delegate = self
        if isFiltering {
            cell.user = filteredUsers[indexPath.row]
        } else {
            cell.user = users[indexPath.row]
        }
        return cell
    }
    
}

extension DMtableViewController: UserDMCellDelegate {
    func userDidFetch(for user: User, with cell: UserDMCell) {
        guard let uid1 = Auth.auth().currentUser?.uid else { return }
        let uid2 = user.uid
        let ref = Database.database().reference().child("Direct/messagesPreview/\(uid1)/\(uid2)")
        ref.observe(.value) { snapshot in
            if let dic = snapshot.value as? [String:Any] {
                DispatchQueue.main.async {
                    let fromId = dic["fromId"] as! String
                    if uid1 == fromId {
                        cell.lastMessageLabel.text = "You " + (dic["text"] as! String)
                    } else {
                        cell.lastMessageLabel.text = (dic["text"] as! String)
                    }
                    if let timestamp = dic["timeStamp"] as? Double {
                        let timestampDate = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm:ss a"
                        cell.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
                    }
                }
            } else {
                cell.lastMessageLabel.text = "Say hi to your new Instgram friend!"
            }
        }
    }
    
    
    
    
}

extension DMtableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category: UserCategorySearch = UserCategorySearch[searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, for: category)
    }
}

extension DMtableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let searchBar = searchController.searchBar
        let category: UserCategorySearch = UserCategorySearch[selectedScope]
        filterContentForSearchText(searchBar.text!, for: category)
    }
}
