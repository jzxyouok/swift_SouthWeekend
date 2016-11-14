//
//  LeftSectionRowViewController.swift
//  SwiftSouthWeekend
//
//  Created by 123456 on 16/10/27.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit


class LeftSectionRowViewController: ParentViewController {
    var start: Int = 0 //页数
    var count: Int = 11 //每页加载的数目
    //点击cell执行block
    typealias DidSelectItemAtBlock = (_ modelItem: ModelItem) -> Swift.Void
    var didSelectItemAtBlock:DidSelectItemAtBlock!
    var sectionId: Int = 0
    
    var modelItem: LeftMenuSubItem! {
        didSet {
            //            sectionId = modelItem.id!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = modelItem.title
        self.view.addSubview(sectionRowView)
        self.getData()
    }
    
    func getData() {
        let url = "http://www.infzm.com/mobile/get_list_by_cat_ids?cat_id%5B%5D=" + String.init(format: "%@", modelItem.cat_id!) + "&" + String.init(format: "start=%i&count=%i", self.start, self.count) + "&platform=ireader&device=Unknown%20iPhone&version=5.1.0&system_version=9.3&hash=f2cdde51e779dd63b44690b9c86b216b&format=json"
        print("url---------:\(url)")
        
        RequestManager.sharedInstance.requestWithUrl(url: url, requestSucceedHandler: { (value) in
            self.sectionRowView.endRefreshing()
            self.sectionRowView.parseModels(data: value, start: self.start)
            
        }) { (error) in
            self.sectionRowView.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy var sectionRowView: SectionRowView = {
        let sectionRowView = SectionRowView(frame: self.view.bounds)
        //点击cell
        sectionRowView.didSelectItemAtBlock = {(modelItem) in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeDetailViewController = storyboard.instantiateViewController(withIdentifier: "HomeDetailViewController") as! HomeDetailViewController
            homeDetailViewController.modelItem = modelItem
            self.navigationController?.pushViewController(homeDetailViewController, animated: true)            
        }
        
        
        //下拉刷新
        sectionRowView.headerRefreshBlock = {() in
            self.start = 0
            self.getData()
        }
        
        //上拉加载
        sectionRowView.footerLoadMoreBlock = {() in
            self.start += 1
            self.getData()
        }
        
        return sectionRowView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("frame---------%@:\(sectionRowView.frame)")
    }
    
    
    
}