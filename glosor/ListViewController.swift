//
//  ListViewController.swift
//  glosor
//
//  Created by malgorzata wikström on 2016-03-10.
//  Copyright © 2016 malgorzata wikström. All rights reserved.
//

/*i klassen ska:
visas namnet på gloslistan/gloslistor och datum då gloslistan/listor skapades
en gloslista i respektive cell (med datum)
man ska kunna ta bort cellen
när man tryker på cellen navigeras man till nästa vy där presentationen av glosListaArray sker och användaren får flera val:
*/

import UIKit
import AVFoundation


class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    // MARK: ELEMENTS
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var NavBarItem: UIBarButtonItem!
    

    
    var helperStruct:HelperStruct = HelperStruct()
    
    var delegateEditList:EditListViewController?
    
    var delagateCreateAListViewController:CreateAListViewController?
    
    var AllaGlosListorArray:[ListDescribe] = []
    
    var cells:[CellTableViewCell] = []
    
    
    var settingsAppLanguageUppdate:String?

    var toShare:String = ""
    
    var words:String = ""
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSettingsAppLanguage()
        TableView.backgroundColor = UIColor(patternImage: UIImage(named: "RosaOBackgraund.png")!)
        TableView.dataSource = self
        TableView.delegate =  self
        TableView.reloadData()

    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: PROTOKOLS FUNCKTIONS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return AllaGlosListorArray.count
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    // MARK: CUSTOM CELLS
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = TableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellTableViewCell
        
        if cells.count < AllaGlosListorArray.count {
            cells.append(cell)//lägg till celler i arragen bara förtsa gången func. körs
        }
        if cells.count >= 0 { //lägg ej flera celler
            print("lägg ej flera celler")
        }
      
        cell.TextLabelOutlet.text = AllaGlosListorArray[indexPath.row].name
        //cell.TextLabelDatum.text = ("Listan skapad: \(helperStruct.dateFormatter())")
        
        for cell in cells {
            if settingsAppLanguageUppdate == "Svenska" {
                cell.TextLabelDatum.text = ("Listan skapad: \(helperStruct.dateFormatter())")
            }
            if settingsAppLanguageUppdate == "English"{
                cell.TextLabelDatum.text = ("List created: \(helperStruct.dateFormatter())")
            }
            if settingsAppLanguageUppdate == "Polska" {
                cell.TextLabelDatum.text = ("Lista utworzona: \(helperStruct.dateFormatter())")
            }
        }

        
        return cell
    }
    
    
    // MARK: DELATE CUSTOM CELL
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //func ska visa alert, som parameter titel för alert, message typen String
    func displayAlert(title: String, message: String) {
        
        //definerar en alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //:MARK  MY FUNCKTIONS
   //func körs från förra vyn vid action "save"
    func addObjPropertyToArray(listDescribeObj:ListDescribe){
        AllaGlosListorArray.append(listDescribeObj) //lägger till obj. med eneskaper: namn, språk1, språk2
        TableView.reloadData()
    }
    
    
    
    func setUpSettingsAppLanguage(){
            if settingsAppLanguageUppdate == "Svenska" {
                title = "dina listor"
                NavBarItem.title = "skapa"
                //cell.TextLabelDatum.text = ("Listan skapad: \(helperStruct.dateFormatter())")
            }
            if settingsAppLanguageUppdate == "English"{
                title = "your lists"
                NavBarItem.title = "create"
                //cell.TextLabelDatum.text = ("List created: \(helperStruct.dateFormatter())")
            }
            if settingsAppLanguageUppdate == "Polska" {
                title = "twoje listy slowek"
                NavBarItem.title = "utworz"
        }
    }
    
    
    
    
    
    // MARK: NAVIGATIONS
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "CreateList" {
           let VC = segue.destinationViewController as? CreateAListViewController
             VC?.settingsAppLanguageUppdate = settingsAppLanguageUppdate
                VC?.delegateListViewController = self
        }
        
       if segue.identifier == "SelectQuiz" {
            let VC = segue.destinationViewController as? SelectQuizTypeViewController
                
            if let cell = sender as? UITableViewCell {
                if let indexPath = TableView.indexPathForCell(cell) {
                    VC?.AllaGlosListorArray = AllaGlosListorArray[indexPath.row] //skickar data som ligger i respektive cell till  SelectQuiz Vyn
                    VC?.settingsAppLanguageUppdate = settingsAppLanguageUppdate
                    }
            }
        }
    }
    
    
    //MARK: CUSTOM CELLS ANIMATIONS
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    func animateTable() { //animerar celler:
        TableView.reloadData()
        
        let myCell = TableView.visibleCells //deklarerar en myCell typen UITableViewCell på existerande rowen
        let screenHeight:CGFloat = TableView.bounds.size.height //anger mått för hight tabel
        
        for myCell in cells { //loppar igenom cells Arraygen
            let myCell:UITableViewCell = myCell as UITableViewCell //cell lika med UITableViewCell
            myCell.transform = CGAffineTransformMakeTranslation(0, screenHeight)//så hög är skärmen
        }
        
        //loppar igenom cellsArraygen som populerar celler
        for myCell in cells {
            let mycell: UITableViewCell = myCell as UITableViewCell //deklarerar en myCell typen UITableViewCell på existerande rowen
            
            //kör animationen:
            self.helperStruct.playAudio() //ljudet spelas upp samtigit som animationene körs
            UIView.animateWithDuration(0.9, delay:0.03, usingSpringWithDamping: 1, initialSpringVelocity: 0,
                                       options: .LayoutSubviews, animations: {
                                        mycell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
        
        }
        //duration:NSTimeInterval:-tid, interval
        //delay:NstimeInterval: snabhet->tid,interval
        //usingSpringWithDamping:dämpnig Float
        //options: enum (finns flea att välja mellan)
        //animation: transform....
    }
    
    // MARK: SAHRE CONTENT
    func toDisplayShare(ToShareContent: String) { //som parameter det som ska delas
    
        //definerar en activityController med items typen String
        let activityViewController = UIActivityViewController(activityItems: [ToShareContent as String], applicationActivities: nil)
        //hur presenteras:
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
                let alert = UIAlertController(title: "Vill ta bort listan?", message: "tryck på JA för att radera", preferredStyle: .Alert)
            let taBort =  UIAlertAction(title: "JA", style: UIAlertActionStyle.Destructive) {
                (UIAlertAction) -> Void in
                //datan tas bort....
                self.AllaGlosListorArray.removeAtIndex(indexPath.row)//från indexPath
                self.TableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)//animation
            }
            
            let cancel = UIAlertAction(title: "NEJ", style: .Cancel, handler: nil)
            //alertAction
            alert.addAction(cancel)
            alert.addAction(taBort)
            self.presentViewController(alert, animated: true,completion: nil)
        }
         
    
        //SHARE LIST--------------------------------------
        let share = UITableViewRowAction(style: .Normal, title: "dela") { (action, indexPath) in
            
       //en loop som konverterar min datatyp:Lista till String för att kunna skriva ut- DELA utan hackparanteser
        for var i = 0; i <= self.AllaGlosListorArray[indexPath.row].glosListorArray.count - 1; i += 1 {
            let content = String(self.AllaGlosListorArray[indexPath.row].glosListorArray[i])
            self.toShare = self.toShare + " " + content
        }
         self.toDisplayShare("Dina gloslisa\r\n Namn på gloslistan: \(self.AllaGlosListorArray[indexPath.row].name)\r\n Språk1: \(self.AllaGlosListorArray[indexPath.row].language1) språk2: \(self.AllaGlosListorArray[indexPath.row].language2) \r\n Glosor: \(self.toShare)")

            self.toShare = ""
        }

        share.backgroundColor = UIColor.darkGrayColor()
    
    return [delete,share]
    
    }

    
    // MARK: ACTIONS
    
    @IBAction func ButtonHelpAction(sender: UIBarButtonItem) {
    
        let VC = storyboard?.instantiateViewControllerWithIdentifier("ShowHelp") as! HelpViewController
        //formeterar popover
        VC.preferredContentSize = CGSize(width: 350, height: 600)
        
        let navController =  UINavigationController(rootViewController: VC)
        //presentation av popover
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        let popover = navController.popoverPresentationController
        popover?.delegate = self
        popover?.barButtonItem = sender as UIBarButtonItem
        
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
    
    
   @IBAction func SwipeGRToLoadningSreen(sender: UISwipeGestureRecognizer) {
        performSegueWithIdentifier("GoBackToLoadningScreen", sender: settingsAppLanguageUppdate)
    }
    
    
}




