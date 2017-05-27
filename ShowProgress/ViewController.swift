//
//  ViewController.swift
//  ShowProgress
//
//  Created by 刘恒 on 2017/2/28.
//  Copyright © 2017年 YunRuiJiTuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //swift版本的进度view
//    let progressView = ProgressView(frame:CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 60))
    var currentProgress = 8
    
    //OC版的进度view
    let taskSingnInProgressView = TaskSingnInProgressView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 60));
    let array = [["day":"2","gold":"8"],["day":"10","gold":"16"],["day":"20","gold":"32"],["day":"30","gold":"64"],["day":"40","gold":"128"]];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //swift版本进度初始化
//        progressView.signArray = [2,10,20,30,40] //数组中的第一个值不能为0；
//        progressView.configMask(position: currentProgress)
//        self.view.addSubview(progressView)
        
        //OC版本进度初始化
        
        taskSingnInProgressView.signArray = array
        taskSingnInProgressView.configMask(withPosition: currentProgress)
        self.view.addSubview(taskSingnInProgressView)
        
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: (UIScreen.main.bounds.width-50)/2, y: 200, width: 50, height: 50)
        button.layer.cornerRadius = 50.0/2
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.blue
        button.setTitle("签到", for: UIControlState.normal)
        button.addTarget(self, action: #selector(signInClick(button:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }
    func signInClick(button:UIButton){
        currentProgress += 1
        //swift版进度变化
//        if currentProgress>(progressView.signArray?.last)!{
//            currentProgress = 0;
//        }
//        progressView.startAnimation(topositon: currentProgress)
        
        //OC版进度变化
        let lastDay = array.last?["day"]
        
        let lastDayInt = Int(lastDay!)
        if currentProgress > lastDayInt!{
            currentProgress = 0
        }
        taskSingnInProgressView.startAnimation(withPosition: currentProgress)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

