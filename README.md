SwiftTweetGettr
===============

New to iOS or Swift? This tiny twitter client project will hopefully get you started building your own apps or seeing common iOS patterns in Swift.

You'll need to replace the API Key and API Secret in the Client class with those of your own. You can get them by getting a Twitter developer account and creating an app. Just go here: https://apps.twitter.com/app/new

# Updated

Updated for Swift 3.1 / Xcode 8.3.3+ by @sarah_j_smith

You can put the credentials into the PLIST file `SwiftTweetGettr/TwitterCredentials.plist` and they'll be read from there (so you don't need to embed them in the code if you don't want to). Handy if you're going to be displaying the code in a group setting.  :-)

Handy git tip: `git update-index --assume-unchanged SwiftTweetGetter/TwitterCredentials.plist` will ignore your changes so you don't push secrets to your repo, if you wind up forking this project.
