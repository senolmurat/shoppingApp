//
//  SearchViewController.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 1.11.2022.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navBarItem = UIBarButtonItem()
        navBarItem.title = "22.0"
        navBarItem.image = UIImage(named: "cart")
        navigationItem.rightBarButtonItem = navBarItem
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
