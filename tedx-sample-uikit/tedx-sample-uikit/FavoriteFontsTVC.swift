//
//  FavoriteFontsTVC.swift
//  tedx-sample-uikit
//
//  Created by Tami Takada on 5/8/22.
//

import UIKit


private let fontCellId = "FontTableCell ID"
private let emptyCellId = "EmptyMessageTableCell ID"

class FavoriteFontsTVC: UITableViewController {
    
    var textToShow: String = ""
    private var favoriteFonts: [SavedFont] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        if let fonts = CoreDataUtils.fetchFavoritedFonts() {
            favoriteFonts = fonts
        }
        
        tableView.backgroundColor = Constants.Colors.bg

        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        tableView.separatorStyle = .none
        
        tableView.register(FontTableCell.self, forCellReuseIdentifier: fontCellId)
        tableView.register(EmptyMessageTableCell.self, forCellReuseIdentifier: emptyCellId)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteFonts.isEmpty ? 1 : favoriteFonts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favoriteFonts.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellId, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: fontCellId, for: indexPath) as! FontTableCell
            
            cell.fontLabel.text = favoriteFonts[indexPath.item].fontName ?? ""
            cell.text.font = UIFont(name: favoriteFonts[indexPath.item].fontName ?? "Comfortaa-Regular", size: 20)
            cell.text.text = textToShow.isEmpty ? "Almost before we knew it, we had left the ground." : textToShow
            cell.favoriteButton.isHidden = true
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        let title: UILabel = {
            let l = UILabel()
            l.setUpLabel(text: "FAVORITE\nFONTS", color: Constants.Colors.text, align: .center, font: .display, size: 40)
            l.numberOfLines = 0
            return l
        }()
        header.addSubview(title)
        title.setSize(view: header, multiplier: 0.85, type: .width)
        title.centerView(x: true, y: true)
        
        return header
    }

}

extension FavoriteFontsTVC: FontCellDelegate {
    func showFontDetails(font: String) {
        let detailView = FontDetailsTVC(style: .grouped)
        detailView.fontFamily = font
        detailView.textToShow = textToShow
        present(detailView, animated: true, completion: nil)
    }
    
    func favoriteFont(cell: FontTableCell) { return }
}

class EmptyMessageTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        let emptyFaces = ["乁( º  ʖ̯ º )ㄏ", "└[óᗝò]┘"]
        let emptyFace = UILabel()
        emptyFace.setUpLabel(text: emptyFaces.randomElement(), color: Constants.Colors.text, align: .center, font: .regular, size: 40)
        
        let emptyMessage: UILabel = {
            let l = UILabel()
            l.setUpLabel(text: "No favorites yet", color: Constants.Colors.text, align: .center, font: .regular, size: 20)
            l.numberOfLines = 0
            return l
        }()
        
        let stack = UIStackView(arrangedSubviews: [emptyFace, emptyMessage])
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 40
        
        addSubview(stack)
        stack.setSize(view: self, multiplier: 0.6, type: .width)
        stack.constraint(top: self.topAnchor, ct: 60, bottom: self.bottomAnchor, cb: -40, trail: nil, ctr: 0, lead: nil, cl: 0)
        stack.centerView(x: true, y: false)
    }
    
}
