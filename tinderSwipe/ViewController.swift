//
//  ViewController.swift
//  tinderSwipe
//
//  Created by Aditya Vikram Godawat on 16/05/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: CGRect(x: 5, y: self.view.bounds.width/4 , width: self.view.bounds.width - 10, height: self.view.bounds.width - 10))
        self.view.addSubview(draggableBackground)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

