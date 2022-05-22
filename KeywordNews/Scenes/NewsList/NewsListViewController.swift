//
//  NewsListViewController.swift
//  KeywordNews
//
//  Created by kmjmarine on 2022/05/21.
//

import UIKit
import SnapKit

final class NewsListViewController: UIViewController {
    private lazy var presenter = NewsListPresenter(viewController: self)
    
    private lazy var refreshContol: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didCalledRefresh), for: .valueChanged)
        
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = presenter
        tableView.dataSource = presenter
        
        tableView.register(
            NewsListTableViewCell.self,
            forCellReuseIdentifier: NewsListTableViewCell.identifier
        )
        
        tableView.refreshControl = refreshContol
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension NewsListViewController: NewsListProtocol {
    func setupNavigationBar() {
        navigationItem.title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func endRefreshing() {
        refreshContol.endRefreshing()
    }
}

private extension NewsListViewController {
    @objc func didCalledRefresh() {
        presenter.didCalledRefresh()
    }
}
