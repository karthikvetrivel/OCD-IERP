//
//  AppDelegate.swift
//  OCD Therapy
//
//  Created by KarsickKeep on 8/18/19.
//  Copyright © 2019 KarsickKeep. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    // MARK: Manage Sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
        if let error = error {
            print("Ran into an error: " + error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error signing in: " + error.localizedDescription)
                return
            }
            let id = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(id!)
            docRef.getDocument { (document, error) in
                if document!.exists {
                    // Document exists so route to home
                    self.routeToHomeScreen()
               } else {
                    // Document does not exist aka user is signing up, make a document
                    let token = user.authentication.accessToken!
                    // Make a url request to get basic user information: email, first name, last name
                    let url = URL(string: "https://www.googleapis.com/oauth2/v3/userinfo?access_token=" + token)
                    URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                        guard let data = data, error == nil else { return }
                        do {
                            let userData = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:AnyObject]

                            let fullName = (userData!["given_name"] as! String) + " " + (userData!["family_name"] as! String)
                            let email = userData!["email"] as! String
                        
                            db.collection("users").document(id!).setData(["name": fullName, "email": email]) {
                                (error) in if (error != nil) {
                                // TODO: Error message
                                }
                                self.routeToHomeScreen()
                            }
                        } catch let error {
                            print(error)
                        }
                    }).resume()
                }
            }
        }
    }
    
    func routeToHomeScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: NavigationConstants.Storyboard.tabBarController) as! TabBarController
        self.window?.rootViewController = nextViewController
        self.window?.makeKeyAndVisible()
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        // MARK: Automatic routing

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if Auth.auth().currentUser != nil {
            // Since the user is signed in set the rootViewController to the home page
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: NavigationConstants.Storyboard.tabBarController) as! TabBarController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        } else {
            // User must sign in so the rootViewController is the sign in page
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: NavigationConstants.Storyboard.signInViewController) as! SignInViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = nextViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OCD_Therapy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

