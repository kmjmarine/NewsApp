//
//  NewsWebViewController.swift
//  KeywordNews
//
//  Created by kmjmarine on 2022/05/23.
//

import WebKit
import UIKit
import SnapKit

final class NewsWebViewController: UIViewController {
    private let news: News
    
    private let webView = WKWebView()
    
    private let rigthBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "link"),
        style: .plain,
        target: self,
        action: #selector(didTapBarButtonItem)
    )
    
    init(news: News) {
        self.news = news
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupWebView()
    }
}

private extension NewsWebViewController {
    func setupNavigationBar() {
        navigationItem.title = news.title.htmlToString
        navigationItem.rightBarButtonItem = rigthBarButtonItem
    }
    
    func setupWebView() {
        guard let linkURL = URL(string: news.link) else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        view = webView
        
        let urlRequest = URLRequest(url: linkURL)
        
        webView.load(urlRequest)
    }
    
    @objc func didTapBarButtonItem() {
        UIPasteboard.general.string = news.link 
    }
}


