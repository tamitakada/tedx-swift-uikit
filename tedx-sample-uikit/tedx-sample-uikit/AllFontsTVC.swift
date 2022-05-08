//
//  PageTVC.swift
//  tedx-sample-uikit
//
//  Created by Tami Takada on 4/21/22.
//

import UIKit


private let fontCellId = "FontTableCell ID"

class AllFontsTVC: UITableViewController {
    
    private var currentText: String = ""
    private var allFonts: [(String, Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        for family in UIFont.familyNames {
            if let c = family.first {
                if c != "." {
                    var favorited = false
                    if let savedFont = CoreDataUtils.fetchSavedFonts(name: family) {
                        favorited = savedFont.favorited
                    }
                    allFonts.append((family, favorited))
                }
            }
        }
        
        let imageView: UIImageView = {
            let i = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            i.contentMode = .scaleAspectFill
            i.image = UIImage(named: "star")?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.text)
            i.isUserInteractionEnabled = true
            i.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(goToFavorites))
            )
            return i
        }()
        
        let button: UIBarButtonItem = {
            let b = UIBarButtonItem()
            b.customView = imageView
            b.customView?.isUserInteractionEnabled = true
            return b
        }()
        
        navigationItem.rightBarButtonItem = button
        
        tableView.backgroundColor = Constants.Colors.bg
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        
        tableView.register(FontTableCell.self, forCellReuseIdentifier: fontCellId)
    }
    
    @objc func goToFavorites() {
        let favoritesView = FavoriteFontsTVC(style: .grouped)
        favoritesView.textToShow = currentText
        self.navigationController?.pushViewController(favoritesView, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFonts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: fontCellId, for: indexPath) as! FontTableCell
        if currentText.isEmpty { cell.text.text = "Almost before we knew it, we had left the ground." }
        else { cell.text.text = currentText }
        cell.text.font = UIFont(name: allFonts[indexPath.item].0, size: 20)
        cell.fontLabel.text = allFonts[indexPath.item].0
        cell.setFavorite(favorite: allFonts[indexPath.item].1)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        let title = UILabel()
        title.setUpLabel(text: "FONTBOOK", color: Constants.Colors.text, align: .center, font: .display, size: 40)
        
        let fieldContainer: UIView = {
            let v = UIView()
            v.layer.borderWidth = 2
            v.layer.borderColor = Constants.Colors.text.cgColor
            v.layer.cornerRadius = 15
            return v
        }()
        
        let field: UITextField = {
            let t = UITextField()
            t.setUpTextField(placeholder: "Enter text here", size: 16, color: Constants.Colors.text, align: .left)
            t.text = currentText
            t.delegate = self
            return t
        }()
        
        fieldContainer.addSubview(field)
        field.constraint(top: fieldContainer.topAnchor, ct: 10, bottom: fieldContainer.bottomAnchor, cb: -10, trail: fieldContainer.trailingAnchor, ctr: -10, lead: fieldContainer.leadingAnchor, cl: 10)
        
        let stack = UIStackView(arrangedSubviews: [title, fieldContainer])
        stack.axis = .vertical
        stack.spacing = 20
        
        header.addSubview(stack)
        stack.setSize(view: header, multiplier: 0.85, type: .width)
        stack.centerView(x: true, y: true)
        
        return header
    }
}

extension AllFontsTVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentText = textField.text ?? ""
        self.tableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

protocol FontCellDelegate {
    func showFontDetails(font: String)
    func favoriteFont(cell: FontTableCell)
}

extension AllFontsTVC: FontCellDelegate {
    func showFontDetails(font: String) {
        let detailView = FontDetailsTVC(style: .grouped)
        detailView.fontFamily = font
        detailView.textToShow = currentText
        present(detailView, animated: true, completion: nil)
    }
    
    func favoriteFont(cell: FontTableCell) {
        if let index = tableView.indexPath(for: cell)?.item {
            allFonts[index].1 = !allFonts[index].1
            if !CoreDataUtils.upsertSavedFont(name: allFonts[index].0, favorited: allFonts[index].1) { print("Error!") }
        }
    }
}

class FontTableCell: UITableViewCell {
    
    let text: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = Constants.Colors.text
        return l
    }()
    
    let fontLabel: UILabel = {
        let l = UILabel()
        l.setUpLabel(text: nil, color: Constants.Colors.text, align: .left, font: .regular, size: 14)
        l.backgroundColor = Constants.Colors.bg
        return l
    }()
    
    var delegate: FontCellDelegate?
    
    private let textContainer: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1
        v.layer.borderColor = Constants.Colors.text.cgColor
        v.layer.cornerRadius = 10
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private var favorited = false
    let favoriteButton: UIImageView = {
        let i = UIImageView(image: UIImage(named: "star")?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.text))
        i.contentMode = .scaleAspectFit
        i.isUserInteractionEnabled = true
        i.backgroundColor = Constants.Colors.bg
        return i
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        textContainer.addSubview(text)
        text.constraint(top: textContainer.topAnchor, ct: 25, bottom: textContainer.bottomAnchor, cb: -20, trail: textContainer.trailingAnchor, ctr: -20, lead: textContainer.leadingAnchor, cl: 20)
        
        addSubview(textContainer)
        addSubview(fontLabel)
        addSubview(favoriteButton)
        
        textContainer.constraint(top: self.topAnchor, ct: 10, bottom: self.bottomAnchor, cb: -10, trail: self.trailingAnchor, ctr: -20, lead: self.leadingAnchor, cl: 20)
        fontLabel.constraint(top: textContainer.topAnchor, ct: -5, bottom: nil, cb: 0, trail: nil, ctr: 0, lead: textContainer.leadingAnchor, cl: 10)
        favoriteButton.setSize(width: 24, height: 24)
        favoriteButton.constraint(top: textContainer.topAnchor, ct: -10, bottom: nil, cb: 0, trail: textContainer.trailingAnchor, ctr: -10, lead: nil, cl: 0)
        
        textContainer.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(seeFontDetails))
        )
        favoriteButton.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(favoriteFont))
        )
    }
    
    @objc func seeFontDetails() {
        delegate?.showFontDetails(font: fontLabel.text ?? "Megrim")
    }
    
    @objc private func favoriteFont() {
        favorited = !favorited
        delegate?.favoriteFont(cell: self)
        changeFavoriteIcon()
    }
    
    func setFavorite(favorite: Bool) {
        self.favorited = favorite
        changeFavoriteIcon()
    }
    
    private func changeFavoriteIcon() {
        if favorited { favoriteButton.image = UIImage(named: "filled-star")?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.text) }
        else { favoriteButton.image = UIImage(named: "star")?.withRenderingMode(.alwaysOriginal).withTintColor(Constants.Colors.text) }
    }
}
