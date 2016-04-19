//
//  CustomCellQuizType12TableViewCell.swift
//  glosor
//
//  Created by malgorzata wikström on 2016-03-23.
//  Copyright © 2016 malgorzata wikström. All rights reserved.
//

import UIKit

class CustomCellQuizType12TableViewCell: UITableViewCell , UITextFieldDelegate {
    
    
   @IBOutlet weak var WordToTranslate: UITextField!
    
   @IBOutlet weak var TheTranslatedWord: UITextField!
    
   @IBOutlet weak var ImageToShowResults: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.WordToTranslate.delegate = self
        self.TheTranslatedWord.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        WordToTranslate.resignFirstResponder()
        TheTranslatedWord.resignFirstResponder()
        return true
    }
}