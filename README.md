# NYTimesArticles

NYTimesArticles app is demo application for getting most viewed articles from NYTimes api. The feed is available for a day/week/month.

Notable features:
1. Dark mode support
2. Universal app, compatible with iPhone, iPad, iPod
3. Period change option (represents how far back, in days, the API returns results for)
4. Command line script for building the project. (Executable file)

Built With 🛠
1. MBProgressHUD
2. Alamofire
3. SwiftLint

Architecture:
This project uses MVVM architecture.

NYTimesArticles

├ ── Utilities           # Utilities for Fetching data ans Scraping HTML
├ ── Cell                # Contains UITableviewCells
├ ── Views               # Viewcontrollers and Views
├ ── ViewModel           # Viewmodels
├ ── Model               # Model files
└ ── pre generated files # Appdelegate, SceneDelegate.
