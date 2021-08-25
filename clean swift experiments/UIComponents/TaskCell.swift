//
//  TaskCell.swift
//  clean swift experiments
//
//  Created by Kanaan Zafar on 24/08/2021.
//

import UIKit

class TaskCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
