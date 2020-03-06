//
//  ViewController.swift
//  TodoList
//
//  Created by あきら on 3/6/20.
//  Copyright © 2020 Akira. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class ViewController: UIViewController, UITableViewDelegate {
    let mainStopwatch = Stopwatch()
    let lapStopwatch = Stopwatch()
    var isPlay: Bool = false

    var laps: [String] = []
    //UI components

    @IBOutlet weak var lapRestButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lapTimerLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //background
        let tblBackgroundColor = UIColor.clear
        lapsTableView.backgroundColor = tblBackgroundColor



        self.addBackground(name: "henry-be-6mwtDZUOFrw-unsplash.jpg")


        lapRestButton.isEnabled = false

        lapsTableView.dataSource = self
        lapsTableView.delegate = self
    }
    //UI Settings
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }


    //Actions
    @IBAction func playPauseTimer(_ sender: Any) {
        lapRestButton.isEnabled = true
        changeButton(lapRestButton, title: "Lap", color: .white)
//play時
        if !isPlay {
            mainStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateLapTimer), userInfo: nil, repeats: true)

            RunLoop.current.add(mainStopwatch.timer, forMode: .common)
            RunLoop.current.add(lapStopwatch.timer, forMode: .common)

            isPlay = true

            changeButton(playPauseButton, title: "Stop", color: UIColor.white)
        } else {
            //止まっている時
            mainStopwatch.timer.invalidate()
            lapStopwatch.timer.invalidate()
            isPlay = false
            changeButton(playPauseButton, title: "Start", color: .white)
            changeButton(lapRestButton, title: "Reset", color: .white)
        }
    }


    @IBAction func lapResetTimer(_ sender: Any) {
        //playしてた時
        if !isPlay {
            resetMainTimer()
            resetLapTimer()
            changeButton(lapRestButton, title: "Lap", color: .white)
            lapRestButton.isEnabled = false
        } else {
            if let timerLabelText = timerLabel.text {
                laps.append(timerLabelText)
            }
            lapsTableView.reloadData()
            resetLapTimer()
            lapStopwatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateLapTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(lapStopwatch.timer, forMode: .common)

        }
    }
//function
    func changeButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(color, for: UIControl.State())
    }
    func resetMainTimer() {
        resetTimer(mainStopwatch, label: lapTimerLabel)
        laps.removeAll()
        lapsTableView.reloadData()
    }

    func resetLapTimer() {
        resetTimer(lapStopwatch, label: lapTimerLabel)
    }
    func resetTimer(_ stopwatch: Stopwatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }




    @objc func updateMainTimer() {
        updateTimer(mainStopwatch, label: timerLabel)
    }
    @objc func updateLapTimer() {
        updateTimer(lapStopwatch, label: lapTimerLabel)
    }

    func updateTimer(_ stopwatch: Stopwatch, label: UILabel)
    {
        stopwatch.counter = stopwatch.counter + 0.035

        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        label.text = minutes + ":" + seconds
    }

}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier: String = "lapCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear


        if let labelNumber = cell.viewWithTag(11) as? UILabel {
            labelNumber.text = "Lap \(laps.count - indexPath.row)"
        }
        if let labelTimer = cell.viewWithTag(12) as? UILabel {
            labelTimer.text = laps[laps.count - indexPath.row - 1]
        }

        return cell
    }

}
extension ViewController {
    func addBackground(name: String) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: name)

        imageViewBackground.contentMode = .scaleAspectFill

        self.view.addSubview(imageViewBackground)

        self.view.sendSubviewToBack(imageViewBackground)
    }
}



