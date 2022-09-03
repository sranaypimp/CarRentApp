//
//  CarListTableViewCell.swift
//  CarRentApp
//
//  Created by Kushal Rana on 02/09/22.
//

import UIKit

//MARK: - CarListTableViewCell
class CarListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var transmissionLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Properties
    var carListCellViewModel : CarListCellViewModel? {
        didSet {
            idLabel.text = carListCellViewModel?.id
            groupLabel.text = carListCellViewModel?.groupFuelTypeFuelLavel
            carNameLabel.text = carListCellViewModel?.descText
            carImageView?.sd_setImage(with: URL( string: carListCellViewModel?.imageUrl ?? "" ), completed: nil)
            licensePlateLabel.text = carListCellViewModel?.licensePlate
        }
    }
}
