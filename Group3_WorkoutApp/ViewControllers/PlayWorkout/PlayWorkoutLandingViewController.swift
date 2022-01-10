//
//  LandingPlayWorkoutViewController.swift
//  Group3_WorkoutApp
//
//  Created by Ali Alqallaf on 29/12/2021.
//

import UIKit
import SwiftUI

class PlayWorkoutLandingViewController:UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet weak var restTimeButton: UIButton!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var scheduleNameLabel: UILabel!
    @IBOutlet weak var scheduleTargetLabel: UILabel!
    
    // default rest time
    static var restTime = 45
    var schedule: Schedule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // apply default styling
        Constants.applyDefaultStyling(backgroundView: view, headerView: headerView, bodyView: bodyView, mainButton: startButton, secondaryButton: restTimeButton)
        
        setDefaultData()
    }
    
    func setDefaultData(){
        schedule = DefaultData.user.activeSchedule
        
        if schedule != nil{
            scheduleNameLabel.text = DefaultData.schedules[0].name
            scheduleTargetLabel.text = "Waiting for schedule activation"
            customTableView.delegate = self
            customTableView.dataSource = self
            //styling table view
            customTableView.separatorStyle = .none
            customTableView.showsVerticalScrollIndicator = false
        }else{
            customTableView.isHidden = true
            restTimeLabel.isHidden = true
            restTimeButton.isHidden = true
            startButton.isEnabled = false
            
            let image = UIImage(named: "no_selection")
            let imageView = UIImageView(image: image!)

            bodyView.addSubview(imageView)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule?.exercises.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customTableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = AppColors.bodyBg
        cell.selectedBackgroundView = bgColorView
        cell.titleLabel.text = DefaultData.schedules[0].exercises[indexPath.row].name
        cell.subtitleLabel.text = "\(schedule?.exercises[indexPath.row].reps ?? 0) reps x \(schedule?.exercises[indexPath.row].sets ?? 0) sets"
        cell.cellImage.image = UIImage(named: schedule?.exercises[indexPath.row].imagePath ?? "")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    @IBAction func setRestTimeTapped(_ sender: Any) {
        guard let restTimeView = storyboard?.instantiateViewController(identifier: "restTimeView") as? RestTimeViewController else {return}
        restTimeView.modalPresentationStyle = .custom
        restTimeView.transitioningDelegate = self
        present(restTimeView, animated: true)
    }
    
    @IBAction func didUnwindFromSelectRestTime(_ seague: UIStoryboardSegue)
    {
        if let restTimeVc = seague.source as? RestTimeViewController {
            PlayWorkoutLandingViewController.restTime = restTimeVc.totalSeconds
            
            let time = Constants.secondsToMinutesSeconds(seconds: Int(PlayWorkoutLandingViewController.restTime))
            let timeString = Constants.formatTimeString(minutes: time.0, seconds: time.1)
            
            restTimeLabel.text = timeString
        }
        else{
            return
        }
    }
}

extension PlayWorkoutLandingViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
