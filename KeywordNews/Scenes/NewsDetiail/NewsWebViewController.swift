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
    private let webView = WKWebView()
    
    private let rigthBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "link"),
        style: .plain,
        target: self,
        action: #selector(didTapBarButtonItem)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupWebView()
    }
}

private extension NewsWebViewController {
    func setupNavigationBar() {
        navigationItem.title = "기사제목"
        navigationItem.rightBarButtonItem = rigthBarButtonItem
    }
    
    func setupWebView() {
        guard let linkURL = URL(string: "https://drjart.co.kr/") else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        view = webView
        
        let urlRequest = URLRequest(url: linkURL)
        
        webView.load(urlRequest)
    }
    
    @objc func didTapBarButtonItem() {
        UIPasteboard.general.string = "뉴스링크"
    }
}


