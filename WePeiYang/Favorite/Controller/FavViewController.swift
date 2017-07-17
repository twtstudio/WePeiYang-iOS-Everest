//
//  FavViewController.swift
//  WePeiYang
//
//  Created by Allen X on 4/28/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit

class FavViewController: UIViewController {

    // The below override will not be called if current viewcontroller is controlled by a UINavigationController
    // We should do self.navigationController.navigationBar.barStyle = UIBarStyleBlack
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    var fooView: UIView!
    var cardTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
//        //Changing NavigationBar Title color
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
//        
//        navigationItem.title = "常用"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = Metadata.Color.WPYAccentColor
        // Changing NavigationBar Title color
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Metadata.Color.naviTextColor]
        // This is for removing the dark shadows when transitioning
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "常用"
        
        
        view.backgroundColor = Metadata.Color.GlobalViewBackgroundColor
        
        cardTableView = UITableView()
        cardTableView.frame = view.frame
        view = cardTableView
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        
        fooView = UIView(color: .red)
        fooView.frame = CGRect(x: 125, y: 200, width: 100, height: 100)
        view.addSubview(fooView)
        
        fooView.layer.cornerRadius = 30
        fooView.layer.shadowRadius = 8
        fooView.layer.shadowOffset = CGSize(width: 0, height: 4)
        fooView.layer.shadowRadius = 10
        fooView.layer.shadowOpacity = 0.5
        
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(shrink))
        swipe.direction = .up
        fooView.addGestureRecognizer(swipe)
        
        let fab = FAB(subActions: [
            ("print1", {
                let vc = UIViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            ("print2", {print(2)}),
            ("print3", {print(3)})
            
        ])
        
        tabBarController?.view.addSubview(fab)
        
        
        let tap = UITapGestureRecognizer(target: fab, action: #selector(FAB.dismissAnimated))
        
        fooView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    func expand() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.fooView.frame = CGRect(x: 75, y: 150, width: 200, height: 200)
            self.fooView.layer.cornerRadius = 0
            self.fooView.layer.shadowOpacity = 0
        }, completion: nil)
    }
    
    func shrink() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.fooView.frame = CGRect(x: 125, y: 200, width: 100, height: 100)
            self.fooView.layer.cornerRadius = 30
            self.fooView.layer.shadowOpacity = 0.5
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.3) { 
            //self.navigationController?.navigationItem.titleView?.alpha = 0
            
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FavViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    
}

extension FavViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
