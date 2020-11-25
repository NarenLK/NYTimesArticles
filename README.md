# NYTimesArticles

NYTimesArticles app is demo application for getting most viewed articles from NYTimes api. The feed is available for a day/week/month.

## Notable features:
1. Dark and light mode support
2. Landscape and Portrait orientation support
2. Universal app, compatible with iPhone, iPad, iPod
3. Period change option (represents how far back, in days, the API returns results for)
4. Navigate between next and previous article in deltaled article page
5. Command line script for building the project. (Executable file)

## To run the project:
1. Open terminal and navigate to project folder
2. Run the command 

       pod install
3. Open NyTimes.xcworkspace to open the project in Xcode.
 

## Screenshots:
### iPad
![ScreenShot](https://github.com/NarenLK/NYTimesArticles/blob/main/NyTimes/Screens/one.png)
![ScreenShot](https://github.com/NarenLK/NYTimesArticles/blob/main/NyTimes/Screens/four.png)

             
### iPhone
![ScreenShot](https://github.com/NarenLK/NYTimesArticles/blob/main/NyTimes/Screens/two.png).   ![ScreenShot](https://github.com/NarenLK/NYTimesArticles/blob/main/NyTimes/Screens/three.png)


## Built With 🛠
1. MBProgressHUD
2. Alamofire
3. SwiftLint

## Architecture:
This project uses MVVM architecture.
  
## Command line build:
To build the project with command line script
1.  *Open terminal and navigate to NyTimes project folder.*
2.  *Run the build.sh script file. -> /. build.sh "release" "0.1" "1" "YourTeamId"*
          
    To run build.sh pass the following parmeter
          
        1. build type - (release or debug)
        2. App version number
        3. Build number
        4. TEAM ID from which builds are signed.
        
        Example :
        /. build.sh "release" "0.1" "1" "YourTeamId"
          
3.   *This would build and archive the project. Logs would be captured and stored in the build directory at the PWD(same path of project).*
4.   *The archived file would be exported and stored at the PWD path level.* 
  
  
  #### This build.sh(Configuration) can be used with fastlane, Jenkins, or with any CI/CD agents like Bamboo.
  If any of the above parameters are missed, script would throw an error for specific case.
  
  #### ![ScreenShot](https://github.com/NarenLK/NYTimesArticles/blob/main/NyTimes/Screens/BuildError.png)

