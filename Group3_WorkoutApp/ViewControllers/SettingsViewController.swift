//
//  SettingsViewController.swift
//  Group3_WorkoutApp
//
//  Created by Albaraa Mohammed Janahi  on 10/01/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var switchOnImg: UIImage = UIImage(named: "switch_on.svg")!
    var switchOffImg: UIImage = UIImage(named: "switch_off.svg")!
    var isPoundFeet = false
    
    let userDefaults = UserDefaults()

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headView1: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var heightValue: UILabel!
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var goalValue: UILabel!
    @IBOutlet weak var heightTxt: UILabel!
    @IBOutlet weak var weightTxt: UILabel!
    @IBOutlet weak var goalTxt: UILabel!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var headView2: UIView!
    @IBOutlet weak var appSettingsLabel: UILabel!
    @IBOutlet weak var settingsView2: UIView!
    @IBOutlet weak var timeSoundTxt: UILabel!
    @IBOutlet weak var darkModeTxt: UILabel!
    @IBOutlet weak var unitTxt: UILabel!
    @IBOutlet weak var soundSwitch: UIImageView!
    @IBOutlet weak var darkModeSwitch: UIImageView!
    @IBOutlet weak var unitSwitch: UIImageView!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the default styles to the page elements by calling a funcation from Constants struct.
        Constants.applyDefaultStyling(backgroundView: view, headerView: headView1, bodyView: settingsView, mainButton: saveButton, secondaryButton: nil)
        Constants.buildRoundedUIView(headerView: headView2, bodyView: settingsView2, button: nil)
        scrollView.backgroundColor = AppColors.phoneBg
        backView.backgroundColor = AppColors.phoneBg
        
        // Changing view 1 elements colors to match the app theme by calling AppColors stuct.
        headLabel.textColor = AppColors.textColor
        nameField.textColor = AppColors.phoneBg
        heightTxt.textColor = AppColors.textColor
        weightTxt.textColor = AppColors.textColor
        goalTxt.textColor = AppColors.textColor
        heightValue.textColor = AppColors.buttonColor
        weightValue.textColor = AppColors.buttonColor
        goalValue.textColor = AppColors.buttonColor
        slider1.thumbTintColor = AppColors.buttonColor
        slider1.tintColor = AppColors.buttonColor
        slider2.thumbTintColor = AppColors.buttonColor
        slider2.tintColor = AppColors.buttonColor
        slider3.thumbTintColor = AppColors.buttonColor
        slider3.tintColor = AppColors.buttonColor
        
        // Changing view 2 elements colors to match the app theme by calling AppColors stuct.
        timeSoundTxt.textColor = AppColors.textColor
        darkModeTxt.textColor = AppColors.textColor
        unitTxt.textColor = AppColors.textColor
        line1.textColor = AppColors.phoneBg
        line2.textColor = AppColors.phoneBg
        //Checking if name key is not nil, if it is not it means that the user did the quiz so we will retrieve the data.
        if let usrName = userDefaults.value(forKey: "name") as? String
        {
            nameField.text = usrName
            nameField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            isPoundFeet = userDefaults.value(forKey: "isPound") as! Bool
            let usrHeight = userDefaults.value(forKey: "height") as! Int
            let usrWeight = userDefaults.value(forKey: "weight") as! Int
            let usrGoal = userDefaults.value(forKey: "goal") as! Int
            let heightInFloat = Float(usrHeight)
            let weightInFloat = Float(usrWeight)
            let goalInFloat = Float(usrGoal)
            slider1.value = heightInFloat
            slider2.value = weightInFloat
            slider3.value = goalInFloat
        }
        else
        {
            //If the code reached here it means there is no data saved, the user skipped the quiz so we will set the defualt values.
            slider1.value = 175
            slider2.value = 120
            slider3.value = 120
        }
        heightValue.text = getHeight()
        weightValue.text = getWeight()
        goalValue.text = getGoal()
    }
    @IBAction func fieldEditted(_ sender: UITextField)
    {
        if (sender.text == "Your name")
        {
            sender.text = "";
            sender.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    @IBAction func sliderMoved(_ sender: UISlider)
    {
        //Checking which slider is moved.
        switch sender.tag {
        case 1:
            heightValue.text = getHeight()
        case 2:
            weightValue.text = getWeight()
        case 3:
            goalValue.text = getGoal()
        default:
            return;
        }
    }
    
    func getHeight() -> String
    {
        var height: String
        if (!isPoundFeet)
        {
            height = String(Int(slider1.value))
            height += " cm"
        }
        else
        {
            let roundedInFoot = round((slider1.value / 30.48) * 10) / 10.0
            height = String(roundedInFoot)
            height += " Foot"
        }
        
        return height
    }
    func getWeight() -> String
    {
        var weight: String
        if (!isPoundFeet)
        {
            weight = String(Int(slider2.value))
            weight += " Kg"
        }
        else
        {
            weight = String(Int(slider2.value * 2.205))
            weight += " lbs"
        }
        return weight
    }
    func getGoal() -> String {
        var goal: String
        if (!isPoundFeet)
        {
            goal = String(Int(slider3.value))
            goal += " Kg"
        }
        else
        {
            goal = String(Int(slider3.value * 2.205))
            goal += " lbs"
        }
        return goal
    }

    @IBAction func saveClicked(_ sender: Any)
    {
        if (nameField.text == "Your name" || nameField.text == "")
        {
            Constants.displayAlert(thisClass: self, alertTitle: "Alert", msg: "Please enter your name!", printInConsole: nil)
            return
        }
        
        //validating if very short name or only spaces.
        var name = nameField.text!
        name = name.trimmingCharacters(in: .whitespaces)
        if(name == "")
        {
            Constants.displayAlert(thisClass: self, alertTitle: "Alert", msg: "Please enter your name!", printInConsole: nil)
            return
        }
        if(name.count < 3)
        {
            Constants.displayAlert(thisClass: self, alertTitle: "Alert", msg: "Your name should be at least three letters", printInConsole: nil)
            return
        }
        
        //validating if name contain any number or special charecter, also counting spaces if more than one.
        var numOfSpaces = 0
        for l in name
        {
            if (!l.isLetter)
            {
                if(!l.isWhitespace)
                {
                    Constants.displayAlert(thisClass: self, alertTitle: "Alert", msg: "Your name can contain only letters and a white space", printInConsole: nil)
                    return
                }
                else
                {
                    numOfSpaces += 1
                }
            }
        }
        if numOfSpaces > 1
        {
            Constants.displayAlert(thisClass: self, alertTitle: "Alert", msg: "The name text field can contain only one white space (between first and last name)", printInConsole: nil)
            return
        }
        
        //Since the code reached hear it means that the input passed all the validations.
        //Saving the data to retrieve it later.
        let height = Int(slider1.value)
        let weight = Int(slider2.value)
        let goal = Int(slider3.value)
        userDefaults.setValue(name, forKey: "name")
        userDefaults.setValue(height, forKey: "height")
        userDefaults.setValue(weight, forKey: "weight")
        userDefaults.setValue(goal, forKey: "goal")
        Constants.displayAlert(thisClass: self, alertTitle: "Done", msg: "Your data updated successfully", printInConsole: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
