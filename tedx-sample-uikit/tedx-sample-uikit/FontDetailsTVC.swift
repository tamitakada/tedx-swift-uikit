//
//  FontDetailsTVC.swift
//  tedx-sample-uikit
//
//  Created by Tami Takada on 5/8/22.
//

import UIKit


private let fontCellId = "FontTableCell ID"

class FontDetailsTVC: UITableViewController {
    
    var textToShow: String = ""
    var fontFamily: String = ""
    private var fontFamilyMembers: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        let names = UIFont.fontNames(forFamilyName: fontFamily)
        if names.isEmpty { fontFamilyMembers.append(fontFamily) }
        else { fontFamilyMembers = names }
        
        tableView.backgroundColor = Constants.Colors.bg

        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        tableView.separatorStyle = .none
        
        tableView.register(FontTableCell.self, forCellReuseIdentifier: fontCellId)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontFamilyMembers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: fontCellId, for: indexPath) as! FontTableCell
        
        let components = fontFamilyMembers[indexPath.item].components(separatedBy: "-")
        cell.fontLabel.text = components.count > 1 ? components[1] : "Regular"
        cell.text.font = UIFont(name: fontFamilyMembers[indexPath.item], size: 20)
        cell.text.text = textToShow.isEmpty ? "Almost before we knew it, we had left the ground." : textToShow
        cell.favoriteButton.isHidden = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        let title: UILabel = {
            let l = UILabel()
            l.setUpLabel(text: fontFamily, color: Constants.Colors.text, align: .center, font: fontFamilyMembers[0], size: 40)
            l.numberOfLines = 0
            return l
        }()
        header.addSubview(title)
        title.setSize(view: header, multiplier: 0.85, type: .width)
        title.centerView(x: true, y: true)
        
        return header
    }

}
