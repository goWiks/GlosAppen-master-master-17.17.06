//
//  QuizTest21ViewController.swift
//  glosor
//
//  Created by malgorzata wikström on 2016-03-25.
//  Copyright © 2016 malgorzata wikström. All rights reserved.

// KÄLLOR:
// http://www.appcoda.com/view-animation-in-swift/ animationer
// https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard keyboard och notifiaktions

import UIKit

class QuizTest21ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {
    
    //:MARK ELMENTS
    @IBOutlet weak var ButtonShowAnswerOutlet: UIButton!
    
    @IBOutlet weak var ButtonRedoOutlet: UIButton!
  
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var VCName: UINavigationItem!
    
    
    
    var delegerare:SelectQuizTypeViewController?

    var AllaGlosListorArray:ListDescribe?
    
    var cells:[CustomCellQuizTest21TableViewCell] = []
    
    var helperStruct:HelperStruct = HelperStruct()
    
    var myFormatedClassElements:MyFormatedClassElements = MyFormatedClassElements()
    
    var settingsAppLanguageUppdate:String?
    
     var soundSettigsApp:Bool?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(AllaGlosListorArray!.language2)-\(AllaGlosListorArray!.language1)"
        self.setUpSettingsAppLanguage()

        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: #selector(QuizTest21ViewController.adjustForKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)

        notificationCenter.addObserver(self, selector: #selector(QuizTest21ViewController.adjustForKeyboard(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        self.myFormatedClassElements.formated_ButtonSelectQuizButton(ButtonShowAnswerOutlet)
        self.myFormatedClassElements.formated_ButtonSelectQuizButton(ButtonRedoOutlet)
        TableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
  
    //:MARK PROTOKOLLS FUNCKTIONS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AllaGlosListorArray?.glosListorArray.count)!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //MARK: SET UP SETTINGS APPLanguage
    func setUpSettingsAppLanguage(){
            if settingsAppLanguageUppdate == "Svenska" {
                ButtonShowAnswerOutlet.setTitle("lägg till", forState: .Normal)
                ButtonRedoOutlet.setTitle("gör om", forState: .Normal)
            }
            if settingsAppLanguageUppdate == "English"{
                ButtonShowAnswerOutlet.setTitle("add", forState: .Normal)
                ButtonRedoOutlet.setTitle("redo", forState: .Normal)
            }
    }

    //:MARK CUSTOM CELL
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = TableView.dequeueReusableCellWithIdentifier("CellQuizType21", forIndexPath: indexPath) as! CustomCellQuizTest21TableViewCell
        
        if cells.count < AllaGlosListorArray?.glosListorArray.count {
            cells.append(cell)
        }
        if cells.count >= 0 {
            print("lägg ej flera celler")
        }
        
        cell.WordToTranslate.text = AllaGlosListorArray!.glosListorArray[indexPath.row].word2
        
        if settingsAppLanguageUppdate == "Svenska" || settingsAppLanguageUppdate == nil {
            cell.TheTranslatedWord.placeholder = "ditt svar"
        }
        if settingsAppLanguageUppdate == "English" {
            cell.TheTranslatedWord.placeholder = "your answer"
        }
        
        ButtonShowAnswerOutlet.addTarget(self, action: #selector(QuizTest21ViewController.ButtonShowAnswer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    

    //:MARK ANIMATIONS CUSTOM CELL
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    
    func animateTable() { //animerar celler:
        TableView.reloadData()
        
        _ = TableView.visibleCells
        let screenHeight:CGFloat = TableView.bounds.size.height
        
        for myCell in cells { //loppar igenom cells Arraygen
            let myCell:UITableViewCell = myCell as UITableViewCell
            myCell.transform = CGAffineTransformMakeTranslation(0, screenHeight)
        }
        for myCell in cells {
            let mycell: UITableViewCell = myCell as UITableViewCell
            if soundSettigsApp == true || soundSettigsApp == nil {
                self.helperStruct.playAudio()
            }

            UIView.animateWithDuration(0.8, delay:0.03, usingSpringWithDamping: 1, initialSpringVelocity: 0,
                                       options: .LayoutSubviews, animations: {
                                        mycell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)

        }
    }

    
    //:MARK  NAVIGATIONS:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowSynonim" {
            let VC = segue.destinationViewController as? SynonimViewController
            if let cell = sender as? UITableViewCell {
                if let indexPath = TableView.indexPathForCell(cell) {
                    VC?.synonimWord = String(AllaGlosListorArray!.glosListorArray[indexPath.row].word2)
                }
            }
        }
    }
    
    //:MARK ACTIONS:
    func ButtonShowAnswer(sender:UIButton) {
        
      var i = 0
        for cell in cells {
            cell.TheTranslatedWord.text! = cell.TheTranslatedWord.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if AllaGlosListorArray!.glosListorArray[i].word1.caseInsensitiveCompare(cell.TheTranslatedWord.text!) == .OrderedSame {
                cell.ImageToShow.hidden = false
            } else {
                cell.ImageToShow.hidden = true
            }
            i+=1
        }
    }
    
    
    @IBAction func ButtonRedoACTION(sender: UIButton) {
        for cell in cells {
            cell.TheTranslatedWord.text! = ""
            cell.ImageToShow.hidden = true
        }
        
    }
    
    
    // MARK: Keyboard up and down
    func adjustForKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let keyboardScreenFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue() //format för screnFrame
        let keyboardViewFrame = view.convertRect(keyboardScreenFrame, fromView: view.window)//och viewFrame
        
        if notification.name == UIKeyboardWillHideNotification { //om notifaktions.NAME  är Hide
            TableView.contentInset = UIEdgeInsetsZero
        } else { // keybord height
            TableView .contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewFrame.height, right: 0) //from bottom dess hight
        }
        
        TableView.scrollIndicatorInsets = TableView.contentInset
    }
    

   
}
    
    
    

    

