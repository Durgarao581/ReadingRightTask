//
//  ViewController.swift
//  ReadingRightTask
//
//  Created by Ganga Durgarao Kothapalli on 01/09/21.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBarOL: UISearchBar!
    
    @IBOutlet weak var randomImageOL: UIImageView!
    @IBOutlet weak var randomMealNameLbl: UILabel!
    @IBOutlet weak var randomMealCategoryLbl: UILabel!
    @IBOutlet weak var randonMealAreaLbl: UILabel!
    @IBOutlet weak var hideViewOL: UIView!
    @IBOutlet weak var backViewOL: UIView!
    @IBOutlet weak var closeBtnOL: UIButton!
    var mealByNameModel: MealByNameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        searchBarOL.delegate = self
        backViewOL.layer.cornerRadius = 12
        backViewOL.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        backViewOL.layer.borderWidth = 1
        randomImageOL.layer.cornerRadius = 12
        closeBtnOL.layer.cornerRadius = 8
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
        callRandomMealApi()
    }
    func setup(){
        let Nib = UINib(nibName: "MealsTableViewCell", bundle: nil)
        tableView.register(Nib, forCellReuseIdentifier: "MealsTableViewCell")
    }
    
    //MARK:- Search Api
    func callMealNameApi(){
        let param = [KeyContants.s: searchBarOL.text]
        AF.request(APP_URL.MEALBYNAME_URL, method: .get, parameters: param, headers: nil).responseJSON { response in
            print(response)
            if let data = response.data{
                print(response)
                do{
                    
                    self.mealByNameModel = try JSONDecoder().decode(MealByNameModel.self, from: data)
                    if self.mealByNameModel?.meals == nil{
                        let alert = UIAlertController.init(title: "Alert", message: "Please Search Valid Data", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default) { act in
                            self.navigationController?.popViewController(animated: true)
                            
                            
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                   
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }catch{
                    print(error.localizedDescription)
                    
                }
            }
        }
        
    }
    
    //MARK:- Random meal Api
    func callRandomMealApi(){
        
        AF.request(APP_URL.RANDOMMEAL_URL, method: .get, parameters: nil, headers: nil).responseJSON { response in
            print(response)
            if let data = response.data{
                print(response)
                do{
                    
                    let response = try JSONDecoder().decode(MealByNameModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.randomImageOL.kf.setImage(with: URL(string: response.meals?[0].strMealThumb ?? ""))
                        self.randomMealNameLbl.text = "Meal Name: \(response.meals?[0].strMeal ?? "")"
                        self.randomMealCategoryLbl.text = "Meal Category: \(response.meals?[0].strCategory ?? "")"
                        self.randonMealAreaLbl.text = "Meal Area: \(response.meals?[0].strArea ?? "")"
                        
                    }
                    
                }catch{
                    print(error.localizedDescription)
                    
                }
            }
        }
        
    }
//MARK:- actions
    @IBAction func searchAction(_ sender: UIButton) {
        callMealNameApi()
        searchBarOL.resignFirstResponder()
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.hideViewOL.isHidden = true
            })
        
    }
    
}
//MARK:- TableView Delegate and Datasource methods
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealByNameModel?.meals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealsTableViewCell", for: indexPath) as? MealsTableViewCell
        cell?.selectionStyle = .none
        cell?.imgOL?.kf.setImage(with: URL(string: mealByNameModel?.meals?[indexPath.row].strMealThumb ?? ""))
        cell?.mealNameLbl.text = mealByNameModel?.meals?[indexPath.row].strMeal ?? ""
        cell?.areaLbl.text = mealByNameModel?.meals?[indexPath.row].strArea ?? ""
        cell?.categoryLbl.text = mealByNameModel?.meals?[indexPath.row].strCategory ?? ""
        cell?.delegate = self
        cell?.clickBtn.tag = indexPath.row
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
}

extension ViewController: ButtonDelegate{
    func getIndex(index: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        vc?.id = mealByNameModel?.meals?[index].idMeal
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
extension ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBarOL.text != "" {
            callMealNameApi()
            searchBarOL.resignFirstResponder()
        }else{
            print("Please fill the search bar")
            searchBarOL.resignFirstResponder()
        }
            
        
    }
}

