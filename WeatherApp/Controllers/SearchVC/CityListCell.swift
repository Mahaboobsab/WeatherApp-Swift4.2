//
//  CityListCell.swift
//  WeatherApp
//
//  Created by Meheboob Nadaf on 22/03/23.
//

import UIKit

class CityListCell: UITableViewCell {
    @IBOutlet weak var aboveView: UIView!
    
    @IBOutlet weak var cityStateLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.aboveView.layer.cornerRadius = 10.0
        self.aboveView.clipsToBounds = true

        // Configure the view for the selected state
    }

}
