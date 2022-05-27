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
    
    private var currentKeyword = ""
    private var currentPage: Int = 0
    private let displayCount: Int = 20
    
    private let tags: [String] = ["ducati", "scrambler", "night shift", "kawasaki", "honda", "bmw s1000rr", "bmw r-ninet", "triumph", "suzuki"]
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
    }
    
    func didCalledRefresh() {
        requestNewsList(isNeededReset: true)
    }
}

extension NewsListPresenter: NewsListTableViewHeaderViewDelegate {
    func didSelectTag(_ selectedIndex: Int) {
        currentKeyword = tags[selectedIndex]
        requestNewsList(isNeededReset: true)
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
        
        requestNewsList(isNeededReset: false)
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
        header?.setup(tags: tags, delegate: self)
        
        return header
    }
}

private extension NewsListPresenter {
    func requestNewsList(isNeededReset: Bool) {
        if isNeededReset {
            currentPage = 0
            newsList = []
        }
        newsSearchManager.request(
            from: currentKeyword,
            start: (currentPage * displayCount) + 1,
            display: displayCount
        ) { [weak self] newValue in
                self?.newsList += newValue
                self?.currentPage += 1
                self?.viewController?.reloadTableView()
                self?.viewController?.endRefreshing()
        }
    }
}
