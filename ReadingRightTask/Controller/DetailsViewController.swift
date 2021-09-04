//
//  DetailsViewController.swift
//  ReadingRightTask
//
//  Created by Ganga Durgarao Kothapalli on 03/09/21.
//

import UIKit
import Alamofire
import Kingfisher
import CoreData

class DetailsViewController: UIViewController {

    @IBOutlet weak var imgOL: UIImageView!
    @IBOutlet weak var mealNameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var areaLbl: UILabel!
    @IBOutlet weak var instructionsLbl: UILabel!
    @IBOutlet weak var favoriteBtnOL: UIButton!
    var id: String?
    var mealModel: MealByNameModel?
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let request: NSFetchRequest<FavoriteFood> = FavoriteFood.fetchRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        imgOL.layer.cornerRadius = 12
        favoriteBtnOL.layer.cornerRadius = 8
        favoriteBtnOL.layer.borderWidth = 1
        favoriteBtnOL.layer.borderColor = #colorLiteral(red: 0.3490196078, green: 0.3215686275, blue: 0.3764705882, alpha: 1)
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "Food Details"
        callMealByIdApi()
      
    }
    
    //save data into core data
    func saveData(){
        do{
            try context!.save()
            print("Saved on context")
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func callMealByIdApi(){
        guard let ids = id else {return}
        let param = [KeyContants.i: ids]
        AF.request(APP_URL.MEALBYID_URL, method: .get, parameters: param, headers: nil).responseJSON { response in
            print(response)
            if let data = response.data{
                print(response)
                do{
                    
                    self.mealModel = try JSONDecoder().decode(MealByNameModel.self, from: data)
                    DispatchQueue.main.async {
                        self.imgOL.kf.setImage(with: URL(string: self.mealModel?.meals?[0].strMealThumb ?? ""))
                        self.mealNameLbl.text = "Meal Name: \(self.mealModel?.meals?[0].strMeal ?? "")"
                        self.categoryLbl.text = "Meal Category: \(self.mealModel?.meals?[0].strCategory ?? "")"
                        self.areaLbl.text = "Meal Area: \(self.mealModel?.meals?[0].strArea ?? "")"
                        self.instructionsLbl.text = "Meal Instructions: \(self.mealModel?.meals?[0].strInstructions ?? "")"
                        
                    }
                    
                }catch{
                    print(error.localizedDescription)
                    
                }
            }
        
    }
    }
    @IBAction func favoriteTapped(_ sender: UIButton) {
        let item = FavoriteFood(context: self.context!)
       
        item.image = mealModel?.meals?[0].strMealThumb ?? ""
        item.mealName = mealModel?.meals?[0].strMeal ?? ""
        item.mealArea = mealModel?.meals?[0].strArea ?? ""
        item.mealCategory = mealModel?.meals?[0].strCategory ?? ""
        item.mealInstructions = mealModel?.meals?[0].strInstructions ?? ""
        
        saveData()
        let alert = UIAlertController.init(title: "Success", message: "successfully added your data", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { act in
            self.navigationController?.popViewController(animated: true)
            
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
   
}
