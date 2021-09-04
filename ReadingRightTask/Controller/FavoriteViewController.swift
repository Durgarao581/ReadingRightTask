//
//  FavoriteViewController.swift
//  ReadingRightTask
//
//  Created by Ganga Durgarao Kothapalli on 03/09/21.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var favoriteFood = [FavoriteFood]()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let request: NSFetchRequest<FavoriteFood> = FavoriteFood.fetchRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchRequest()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    func setup(){
        let Nib = UINib(nibName: "MealsTableViewCell", bundle: nil)
        tableView.register(Nib, forCellReuseIdentifier: "MealsTableViewCell")
    }
    //MARK:- fetching data from database
    func fetchRequest(){
        do{
            favoriteFood = try (context?.fetch(self.request))!
            tableView.reloadData()
        }catch{
            print("problem with fetchind data\(error)")
        }
    }
    
}
//MARK:- tableview delegate and data source methods
extension FavoriteViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealsTableViewCell", for: indexPath) as? MealsTableViewCell
        cell?.selectionStyle = .none
        cell?.imgOL?.kf.setImage(with: URL(string: favoriteFood[indexPath.row].image ?? ""))
        cell?.mealNameLbl.text = favoriteFood[indexPath.row].mealName ?? ""
        cell?.areaLbl.text = favoriteFood[indexPath.row].mealArea ?? ""
        cell?.categoryLbl.text = favoriteFood[indexPath.row].mealCategory ?? ""
        cell?.clickBtn.isHidden = true
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    
    
}
