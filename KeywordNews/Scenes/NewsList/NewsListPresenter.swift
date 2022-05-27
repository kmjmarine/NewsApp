//
//  NewsListPresenter.swift
//  KeywordNews
//
//  Created by kmjmarine on 2022/05/21.
//

import Foundation
import UIKit

protocol NewsListProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func endRefreshing()
    func moveToNewsWebViewController(with news: News)
    func reloadTableView()
}

final class NewsListPresenter: NSObject {
    private weak var viewController: NewsListProtocol?
    private let newsSearchManager: NewsSearchManagerProtocol
    
    private var currentKeyword = "아이폰"
    private var currentPage: Int = 0
    private let displayCount: Int = 20
    
    private var newsList: [News] = [ ]
    
    init(viewController: NewsListProtocol,
         newsSearchManager: NewsSearchManagerProtocol = NewsSearchManager()
    ) {
        self.viewController = viewController
        self.newsSearchManager = newsSearchManager
    }
    
    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
        requestNewsList()
    }
    
    func didCalledRefresh() {
        viewController?.endRefreshing()
    }
}

extension NewsListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        viewController?.moveToNewsWebViewController(with: news)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentRow = indexPath.row
        
        guard (currentRow % 20) == displayCount - 3 && (currentRow / displayCount) == (currentPage - 1)
        else {
            return
        }
        
        requestNewsList()
    }
}

extension NewsListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.identifier, for: indexPath) as? NewsListTableViewCell
        
        let news = newsList[indexPath.row]
        cell?.setup(news: news)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsListTableViewHeaderView.identifier) as? NewsListTableViewHeaderView
        header?.setup()
        
        return header
    }
}

private extension NewsListPresenter {
    func requestNewsList() {
        newsSearchManager.request(
            from: currentKeyword,
            start: (currentPage * displayCount) + 1,
            display: displayCount
        ) { [weak self] newValue in
                self?.newsList += newValue
                self?.currentPage += 1
                self?.viewController?.reloadTableView()
            }
    }
}
