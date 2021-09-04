//
//  MealsTableViewCell.swift
//  ReadingRightTask
//
//  Created by Ganga Durgarao Kothapalli on 02/09/21.
//

import UIKit

protocol ButtonDelegate {
    func getIndex(index: Int)
}

class MealsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgOL: UIImageView!
    @IBOutlet weak var mealNameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var areaLbl: UILabel!
    
    @IBOutlet weak var clickBtn: UIButton!
    
    var delegate: ButtonDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        imgOL.layer.cornerRadius = 12
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.delegate?.getIndex(index: sender.tag)
        
    }
}
