//
//  ArticleListViewController.swift
//  NyTimes
//
//  Created by Kivanda, Narendra on 22/11/20.
//

import Alamofire
import MBProgressHUD
import UIKit

/// View controller Class for diaplying the most viewed articles at NyTimes
class ArticleListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var tblDetails: UITableView!
    @IBOutlet weak private var btnPeriod: UISegmentedControl!
    
    // MARK: - Variables
    var articleList: [Article] = []
    var refreshControl = UIRefreshControl()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        tblDetails.addSubview(refreshControl)
        
        if UserDefaults.standard.object(forKey: Constants.period) == nil {
            UserDefaults.standard.set(ArticlePeriod.day.rawValue, forKey: Constants.period)
            
        } else {
            if UserDefaults.standard.value(forKey: Constants.period) as! String == ArticlePeriod.day.rawValue {
                btnPeriod.selectedSegmentIndex = 0
                
            } else if UserDefaults.standard.value(forKey: Constants.period) as! String == ArticlePeriod.week.rawValue {
                btnPeriod.selectedSegmentIndex = 1
                
            } else {
                btnPeriod.selectedSegmentIndex = 2
            }
        }
        fetchArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tblDetails.indexPathForSelectedRow {
            tblDetails.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - IBActions
    /// Function to handle the change in period
    /// - Parameter sender: event sender object
    @IBAction func periodChanged(_ sender: Any) {
        switch btnPeriod.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(ArticlePeriod.day.rawValue, forKey: Constants.period)
        case 1:
            UserDefaults.standard.set(ArticlePeriod.week.rawValue, forKey: Constants.period)
        case 2:
            UserDefaults.standard.set(ArticlePeriod.month.rawValue, forKey: Constants.period)
        default:
            UserDefaults.standard.set(ArticlePeriod.day.rawValue, forKey: Constants.period)
        }
        
        fetchArticles()
    }
    
    // MARK: - Custom function
    /// Function to fetch the list of most viewed articles on NYTimes
    func fetchArticles() {
        MBProgressHUD.showAdded(to: view, animated: true)
        ArticleViewModel.shared.fetchArticle { [self] _, response  in
            MBProgressHUD.hide(for: view, animated: true)
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            if response == nil {
                return
            }

            articleList = (response?.articles)!
            tblDetails.reloadData()
            tblDetails.flashScrollIndicators()
            if (UIDevice.current.userInterfaceIdiom == .pad) && splitViewController?.displayMode == UISplitViewController.DisplayMode.oneBesideSecondary {
                tblDetails.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                let mainNc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailNc") as! UINavigationController
                let detailVc = mainNc.viewControllers.last as! ArticleViewController
                detailVc.articleIndex = 0
                detailVc.articleList = articleList
                splitViewController?.showDetailViewController((mainNc), sender: nil)
            }
        }
    }

    /// Function to handle the PULL-TO-REFRESH property of refresh conntrol on Tableview
    @objc
    func handlePullToRefresh() {
        fetchArticles()
    }
}

// MARK: - Extension for handling tableview display (Delegate, Datasource)
extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleListCell") as! ArticleListCell
        cell.fillData(article: articleList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainNc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailNc") as! UINavigationController
        let detailVc = mainNc.viewControllers.last as! ArticleViewController
        detailVc.articleIndex = indexPath.row
        detailVc.articleList = articleList
        splitViewController?.showDetailViewController((mainNc), sender: nil)
    }
}

/// SpiltViewController subclass for handling the master details transitions
class NYSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    /// Function to handle side by side display of columns in wider devices. (Landscape modes)
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

/// TableviewCell subclass for handling the display of each article in list
class ArticleListCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak private var lblHeader: UILabel!
    @IBOutlet weak private var imgThumbnail: UIImageView!
    @IBOutlet weak private var lblSubHeader: UILabel!
    @IBOutlet weak private var lblDate: UILabel!

    // MARK: - Custom function
    /// Function to fill datsource for the cell
    /// - Parameter article: article model object
    func fillData(article: Article) {
        lblHeader.text = article.title
        lblSubHeader.text = article.byline
        lblDate.text = article.published_date
        imgThumbnail.image = UIImage(systemName: "safari")

        guard article.media!.isEmpty else {
            let media = article.media!

            guard media[0].media_metadata!.isEmpty else {
                let metadata = media[0].media_metadata!

                ArticleViewModel.shared.fetchPhoto(url: metadata[0].url!) { [self] responseData in
                    if responseData == nil {
                        return
                    }
                    imgThumbnail.image = UIImage(data: responseData!)
                }
                return
            }
            return
        }
    }
}
