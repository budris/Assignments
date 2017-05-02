import UIKit

// MARK: NavigationDropdownMenu
open class NavigationDropdownMenu: UIView {
    
    // The color of menu title. Default is darkGrayColor()
    open var menuTitleColor: UIColor! {
        get {
            return configuration.menuTitleColor
        }
        set(value) {
            configuration.menuTitleColor = value
        }
    }
    
    // The height of the cell. Default is 50
    open var cellHeight: NSNumber! {
        get {
            return configuration.cellHeight as NSNumber!
        }
        set(value) {
            configuration.cellHeight = CGFloat(value)
        }
    }
    
    // The color of the cell background. Default is whiteColor()
    open var cellBackgroundColor: UIColor! {
        get {
            return configuration.cellBackgroundColor
        }
        set(color) {
            configuration.cellBackgroundColor = color
        }
    }
    
    // The tint color of the arrow. Default is whiteColor()
    open var arrowTintColor: UIColor! {
        get {
            return menuArrow.tintColor
        }
        set(color) {
            menuArrow.tintColor = color
        }
    }
    
    open var cellSeparatorColor: UIColor! {
        get {
            return configuration.cellSeparatorColor
        }
        set(value) {
            configuration.cellSeparatorColor = value
        }
    }
    
    // The color of the text inside cell. Default is darkGrayColor()
    open var cellTextLabelColor: UIColor! {
        get {
            return configuration.cellTextLabelColor
        }
        set(value) {
            configuration.cellTextLabelColor = value
        }
    }
    
    // The color of the text inside a selected cell. Default is darkGrayColor()
    open var selectedCellTextLabelColor: UIColor! {
        get {
            return configuration.selectedCellTextLabelColor
        }
        set(value) {
            configuration.selectedCellTextLabelColor = value
        }
    }
    
    open var exclusiveRows: [Int]! {
        get {
            return configuration.exclusiveRows
        }
        set(value) {
            configuration.exclusiveRows = value
        }
    }
    
    // The font of the text inside cell. Default is HelveticaNeue-Bold, size 17
    open var cellTextLabelFont: UIFont! {
        get {
            return configuration.cellTextLabelFont
        }
        set(value) {
            configuration.cellTextLabelFont = value
        }
    }
    
    // The font of the navigation bar title. Default is HelveticaNeue-Bold, size 17
    open var navigationBarTitleFont: UIFont! {
        get {
            return configuration.navigationBarTitleFont
        }
        set(value) {
            configuration.navigationBarTitleFont = value
            menuTitle.font = configuration.navigationBarTitleFont
        }
    }
    
    // The alignment of the text inside cell. Default is .Left
    open var cellTextLabelAlignment: NSTextAlignment! {
        get {
            return configuration.cellTextLabelAlignment
        }
        set(value) {
            configuration.cellTextLabelAlignment = value
        }
    }
    
    // The color of the cell when the cell is selected. Default is lightGrayColor()
    open var cellSelectionColor: UIColor! {
        get {
            return configuration.cellSelectionColor
        }
        set(value) {
            configuration.cellSelectionColor = value
        }
    }
    
    // The checkmark icon of the cell
    open var checkMarkImage: UIImage! {
        get {
            return configuration.checkMarkImage
        }
        set(value) {
            configuration.checkMarkImage = value
        }
    }
    
    // The boolean value that decides if selected color of cell is visible when the menu is shown. Default is false
    open var shouldKeepSelectedCellColor: Bool! {
        get {
            return configuration.shouldKeepSelectedCellColor
        }
        set(value) {
            configuration.shouldKeepSelectedCellColor = value
        }
    }
    
    // The animation duration of showing/hiding menu. Default is 0.3
    open var animationDuration: TimeInterval! {
        get {
            return configuration.animationDuration
        }
        set(value) {
            configuration.animationDuration = value
        }
    }
    
    // The arrow next to navigation title
    open var arrowImage: UIImage! {
        get {
            return configuration.arrowImage
        }
        set(value) {
            configuration.arrowImage = value.withRenderingMode(.alwaysTemplate)
            menuArrow.image = configuration.arrowImage
        }
    }
    
    // The padding between navigation title and arrow
    open var arrowPadding: CGFloat! {
        get {
            return configuration.arrowPadding
        }
        set(value) {
            configuration.arrowPadding = value
        }
    }
    
    // The color of the mask layer. Default is blackColor()
    open var maskBackgroundColor: UIColor! {
        get {
            return configuration.maskBackgroundColor
        }
        set(value) {
            configuration.maskBackgroundColor = value
        }
    }
    
    // The opacity of the mask layer. Default is 0.3
    open var maskBackgroundOpacity: CGFloat! {
        get {
            return configuration.maskBackgroundOpacity
        }
        set(value) {
            configuration.maskBackgroundOpacity = value
        }
    }
    
    // The boolean value that decides if you want to change the title text when a cell is selected. Default is true
    open var shouldChangeTitleText: Bool {
        get {
            return configuration.shouldChangeTitleText
        }
        set(value) {
            configuration.shouldChangeTitleText = value
        }
    }

    open var addditionalSpacePercent: CGFloat {
        get {
            return configuration.addditionalSpacePercent
        }
        set {
            configuration.addditionalSpacePercent = newValue
        }
    }
    
    open var didSelectItemAtIndexHandler: ((_ indexPath: Int) -> ())?
    open var isShown: Bool!
    
    fileprivate weak var navigationController: UINavigationController?
    fileprivate var configuration = DropdownMenuConfiguration()
    fileprivate var topSeparator: UIView!
    fileprivate var menuButton: UIButton!
    fileprivate var menuTitle: UILabel!
    fileprivate var transparentView: UIView!
    fileprivate var menuArrow: UIImageView!
    fileprivate var backgroundView: UIView!
    fileprivate var tableView: DropdownMenuTableView!
    fileprivate var items: [AnyObject]!
    fileprivate var menuWrapper: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(navigationController: UINavigationController? = nil, containerView: UIView = UIApplication.shared.keyWindow!, title: String, items: [AnyObject], bottomOffset: CGFloat? = nil) {
        // Key window
        guard let window = UIApplication.shared.keyWindow else {
            super.init(frame: CGRect.zero)
            return
        }
        
        // Navigation controller
        if let navigationController = navigationController {
            self.navigationController = navigationController
        } else {
            self.navigationController = window.rootViewController?.topMostViewController?.navigationController
        }
        
        // Get titleSize
        let titleSize = (title as NSString).size(attributes: [NSFontAttributeName:configuration.navigationBarTitleFont])
        
        // Set frame
        let frame = CGRect(x: 0, y: 0, width: titleSize.width + (configuration.arrowPadding + configuration.arrowImage.size.width)*2, height: navigationController!.navigationBar.frame.height)
        
        super.init(frame:frame)
        
        self.navigationController?.delegate = self

        isShown = false
        self.items = items
        
        // Init button as navigation title
        menuButton = UIButton(frame: frame)
        menuButton.addTarget(self, action: #selector(NavigationDropdownMenu.toogleMenu), for: UIControlEvents.touchUpInside)
        addSubview(menuButton)
        
        menuTitle = UILabel(frame: frame)
        menuTitle.text = title
        menuTitle.textColor = menuTitleColor
        menuTitle.font = configuration.navigationBarTitleFont
        menuTitle.textAlignment = configuration.cellTextLabelAlignment
        menuButton.addSubview(menuTitle)
        
        menuArrow = UIImageView(image: configuration.arrowImage.withRenderingMode(.alwaysTemplate))
        menuButton.addSubview(menuArrow)
        
        let menuWrapperBounds = window.bounds
        
        // Set up DropdownMenu
        menuWrapper = UIView(frame: CGRect(x: menuWrapperBounds.origin.x, y: 0, width: menuWrapperBounds.width, height: menuWrapperBounds.height))
        menuWrapper.clipsToBounds = true
        menuWrapper.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        // Init background view (under table view)
        backgroundView = UIView(frame: menuWrapperBounds)
        backgroundView.backgroundColor = configuration.maskBackgroundColor
        backgroundView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        let backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationDropdownMenu.hideMenu));
        backgroundView.addGestureRecognizer(backgroundTapRecognizer)
        
        // Init properties
        setupDefaultConfiguration()
        
        // Init table view
        let navBarHeight = navigationController?.navigationBar.bounds.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let bottomOffset = bottomOffset ?? 0.0
        tableView = DropdownMenuTableView(frame: CGRect(x: menuWrapperBounds.origin.x,
                                                             y: menuWrapperBounds.origin.y + 0.5,
                                                             width: menuWrapperBounds.width,
                                                             height: menuWrapperBounds.height + 300 - navBarHeight - statusBarHeight - bottomOffset),
                                               items: items, title: title, configuration: self.configuration)
        
        tableView.selectRowAtIndexPathHandler = { [weak self] (indexPath: Int) -> () in
            guard let selfie = self else {
                return
            }
            selfie.didSelectItemAtIndexHandler!(indexPath)
            if selfie.shouldChangeTitleText {
                selfie.setMenuTitle("\(selfie.tableView.items[indexPath])")
            }
            self?.hideMenu()
            self?.layoutSubviews()
        }
        
        // Add background view & table view to container view
        menuWrapper.addSubview(backgroundView)
        menuWrapper.addSubview(tableView)
        
        // Add Line on top
        topSeparator = UIView(frame: CGRect(x: 0, y: 0, width: menuWrapperBounds.size.width, height: 0.5))
        topSeparator.autoresizingMask = UIViewAutoresizing.flexibleWidth
        menuWrapper.addSubview(topSeparator)
        
        // Add Menu View to container view
        containerView.addSubview(menuWrapper)
        
        // By default, hide menu view
        menuWrapper.isHidden = true

        // transparent view between title label and arrow
        transparentView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: configuration.arrowPadding, height: menuButton.frame.size.height))
        menuButton.addSubview(transparentView)

        let transparentViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationDropdownMenu.toogleMenu))
        transparentView.addGestureRecognizer(transparentViewGestureRecognizer)

        let titleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationDropdownMenu.toogleMenu))
        menuTitle.addGestureRecognizer(titleGestureRecognizer)

        let arrowGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NavigationDropdownMenu.toogleMenu))
        menuArrow.addGestureRecognizer(arrowGestureRecognizer)
    }
    
    override open func layoutSubviews() {
        menuTitle.sizeToFit()
        menuTitle.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        menuTitle.textColor = self.configuration.menuTitleColor
        menuArrow.sizeToFit()
        menuArrow.center = CGPoint(x: menuTitle.frame.maxX + configuration.arrowPadding, y: frame.size.height/2)
        
        if menuArrow.frame.maxX > menuButton.frame.width {
            let availableWidth = (1 + addditionalSpacePercent) * menuButton.frame.width
            if menuArrow.frame.maxX > availableWidth {
                let titleLeftPadding = (menuButton.frame.width * addditionalSpacePercent) / 2
                menuTitle.frame.size.width = availableWidth - menuArrow.frame.width - configuration.arrowPadding
                menuTitle.frame.origin.x = -titleLeftPadding
                menuArrow.frame.origin.x = menuTitle.frame.maxX + configuration.arrowPadding
            }

            menuTitle.frame.size.height = menuButton.frame.size.height
            menuTitle.frame.origin.y = 0
            menuArrow.frame.origin.y = 0
            menuArrow.frame.size.height = menuButton.frame.size.height
            menuArrow.contentMode = .scaleAspectFit
        }

        transparentView.frame.origin.x = menuTitle.frame.maxX

        menuWrapper.frame.origin.y = navigationController!.navigationBar.frame.maxY
        tableView.reloadData()
    }
    
    open func show() {
        if isShown == false {
            showMenu()
        }
    }
    
    open func hide() {
        if isShown == true {
            hideMenu()
        }
    }
    
    open func toggle() {
        if(isShown == true) {
            hideMenu();
        } else {
            showMenu();
        }
    }
    
    open func updateItems(_ items: [AnyObject]) {
        if !items.isEmpty {
            tableView.items = items
            tableView.reloadData()

            if shouldChangeTitleText ,
                let index = tableView.selectedIndexPath {
                setMenuTitle("\(items[index])")
                layoutSubviews()
            }
        }
    }
    
    func setupDefaultConfiguration() {
        menuTitleColor = navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
        cellBackgroundColor = navigationController?.navigationBar.barTintColor
        cellSeparatorColor = navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
        cellTextLabelColor = navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
        
        arrowTintColor = configuration.arrowTintColor
    }
    
    func showMenu() {
        menuWrapper.frame.origin.y = navigationController!.navigationBar.frame.maxY
        
        isShown = true
        
        // Table view header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 300))
        headerView.backgroundColor = configuration.cellBackgroundColor
        tableView.tableHeaderView = headerView
        
        topSeparator.backgroundColor = configuration.cellSeparatorColor
        
        // Rotate arrow
        rotateArrow()
        
        // Visible menu view
        menuWrapper.isHidden = false
        
        // Change background alpha
        backgroundView.alpha = 0
        
        // Animation
        tableView.frame.origin.y = -CGFloat(items.count) * configuration.cellHeight - 300
        
        // Reload data to dismiss highlight color of selected cell
        tableView.reloadData()
        
        menuWrapper.superview?.bringSubview(toFront: menuWrapper)
        
        UIView.animate(
            withDuration: configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-300)
                self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
        }, completion: nil
        )
    }
    
    func hideMenu() {
        // Rotate arrow
        rotateArrow()
        
        isShown = false
        
        // Change background alpha
        backgroundView.alpha = configuration.maskBackgroundOpacity
        
        UIView.animate(
            withDuration: configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-200)
        }, completion: nil
        )
        
        // Animation
        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            options: UIViewAnimationOptions(),
            animations: {
                self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
                self.backgroundView.alpha = 0
        }, completion: { _ in
            if self.isShown == false && self.tableView.frame.origin.y == -CGFloat(self.items.count) * self.configuration.cellHeight - 300 {
                self.menuWrapper.isHidden = true
            }
        })
    }
    
    func rotateArrow() {
        UIView.animate(withDuration: configuration.animationDuration, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.menuArrow.transform = selfie.menuArrow.transform.rotated(by: 180 * CGFloat(M_PI/180))
            }
        })
    }
    
    func setMenuTitle(_ title: String) {
        menuTitle.text = title
    }

    public func toogleMenu() {
        isShown == true ? hideMenu() : showMenu()
    }
    
    func selectRow (row: Int) {
        tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
        tableView.selectedIndexPath = row
        setMenuTitle("\(tableView.items[row])")
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? DropdownMenuTableViewCell
        cell?.contentView.backgroundColor = configuration.cellSelectionColor
        cell?.textLabel?.textColor = configuration.selectedCellTextLabelColor
        layoutSubviews()
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)

        let menuTitilePoint = menuTitle.convert(point, to: menuTitle)
        let menuArrowPoint = menuArrow.convert(point, to: menuArrow)
        let menuButtonPoint = menuButton.convert(point, to: menuButton)
        let transparentViewPoint = transparentView.convert(point, to: transparentView)

        if menuTitle.frame.contains(menuTitilePoint) {
            return menuTitle
        } else if menuArrow.frame.contains(menuArrowPoint) {
            return menuArrow
        } else if menuButton.frame.contains(menuButtonPoint) {
            return menuButton
        } else if transparentView.frame.contains(transparentViewPoint) {
            return transparentView
        } else {
            return nil
        }
    }
}

extension NavigationDropdownMenu: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        hide()
    }
}

// MARK: DropdownMenuConfiguration
class DropdownMenuConfiguration {
    var menuTitleColor: UIColor?
    var cellHeight: CGFloat!
    var cellBackgroundColor: UIColor?
    var cellSeparatorColor: UIColor?
    var cellTextLabelColor: UIColor?
    var selectedCellTextLabelColor: UIColor?
    var exclusiveRows: [Int]?
    var cellTextLabelFont: UIFont!
    var navigationBarTitleFont: UIFont!
    var cellTextLabelAlignment: NSTextAlignment!
    var cellSelectionColor: UIColor?
    var checkMarkImage: UIImage!
    var shouldKeepSelectedCellColor: Bool!
    var arrowTintColor: UIColor?
    var arrowImage: UIImage!
    var arrowPadding: CGFloat!
    var animationDuration: TimeInterval!
    var maskBackgroundColor: UIColor!
    var maskBackgroundOpacity: CGFloat!
    var shouldChangeTitleText: Bool!
    var addditionalSpacePercent: CGFloat!
    
    init() {
        defaultValue()
    }
    
    func defaultValue() {
        // Default values
        menuTitleColor = UIColor.darkGray
        cellHeight = 50
        cellBackgroundColor = UIColor.white
        arrowTintColor = UIColor.white
        cellSeparatorColor = UIColor.darkGray
        cellTextLabelColor = UIColor.darkGray
        selectedCellTextLabelColor = UIColor.darkGray
        cellTextLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
        navigationBarTitleFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
        cellTextLabelAlignment = NSTextAlignment.left
        cellSelectionColor = UIColor.lightGray
//        checkMarkImage = UIImage(named: "down-arrow")
        shouldKeepSelectedCellColor = false
        animationDuration = 0.5
        arrowImage = UIImage(named: "down-arrow")
        arrowPadding = 15
        maskBackgroundColor = UIColor.black
        maskBackgroundOpacity = 0.3
        shouldChangeTitleText = true
        exclusiveRows = []
        addditionalSpacePercent = 0.4
    }
}

// MARK: Table View
class DropdownMenuTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: DropdownMenuConfiguration!
    var selectRowAtIndexPathHandler: ((_ indexPath: Int) -> ())?
    
    // Private properties
    fileprivate var items: [AnyObject]!
    fileprivate var selectedIndexPath: Int?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [AnyObject], title: String, configuration: DropdownMenuConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.plain)
        
        self.items = items
        selectedIndexPath = (items as! [String]).index(of: title)
        self.configuration = configuration
        
        // Setup table view
        delegate = self
        dataSource = self
        backgroundColor = UIColor.clear
        separatorStyle = UITableViewCellSeparatorStyle.none
        //        separatorEffect = UIBlurEffect(style: .Light)
        autoresizingMask = UIViewAutoresizing.flexibleWidth
        tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView.isKind(of: DropdownMenuTableCellContentView.self) {
            return hitView
        }
        return nil;
    }
    
    // Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configuration.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DropdownMenuTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell", configuration: configuration)
        cell.textLabel?.text = items[indexPath.row] as? String
        cell.checkmarkIcon.isHidden = indexPath.row == selectedIndexPath ? false : true
        return cell
    }
    
    // Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = (indexPath as NSIndexPath).row
        var isExclusiveRow = false
        if let exclusiveRows = configuration.exclusiveRows, exclusiveRows.contains(row) {
            isExclusiveRow = true
        } else {
            selectedIndexPath = row
        }
        configuration.shouldChangeTitleText = !isExclusiveRow
        selectRowAtIndexPathHandler!(row)
        reloadData()
        if !isExclusiveRow {
            let cell = tableView.cellForRow(at: indexPath) as? DropdownMenuTableViewCell
            cell?.contentView.backgroundColor = configuration.cellSelectionColor
            cell?.textLabel?.textColor = configuration.selectedCellTextLabelColor
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? DropdownMenuTableViewCell
        cell?.checkmarkIcon.isHidden = true
        cell?.contentView.backgroundColor = configuration.cellBackgroundColor
        cell?.textLabel?.textColor = configuration.cellTextLabelColor
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if configuration.shouldKeepSelectedCellColor == true {
            cell.backgroundColor = configuration.cellBackgroundColor
            cell.contentView.backgroundColor = indexPath.row == selectedIndexPath
                ? configuration.cellSelectionColor
                : configuration.cellBackgroundColor
        }
    }
}

// MARK: Table view cell
class DropdownMenuTableViewCell: UITableViewCell {
    let checkmarkIconWidth: CGFloat = 10
    let horizontalMargin: CGFloat = 40
    let labelLeading: CGFloat = 40
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    var configuration: DropdownMenuConfiguration!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: DropdownMenuConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configuration = configuration
        
        // Setup cell
        cellContentFrame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: self.configuration.cellHeight)
        contentView.backgroundColor = configuration.cellBackgroundColor
        selectionStyle = UITableViewCellSelectionStyle.none
        textLabel!.textColor = configuration.cellTextLabelColor
        textLabel!.font = configuration.cellTextLabelFont
        textLabel!.textAlignment = configuration.cellTextLabelAlignment

        if textLabel!.textAlignment == .center {
            textLabel!.frame = CGRect(x: labelLeading, y: 0,
                                           width: cellContentFrame.width - horizontalMargin - labelLeading,
                                           height: cellContentFrame.height)
        } else if textLabel!.textAlignment == .left {
            textLabel!.frame = CGRect(x: horizontalMargin, y: 0,
                                           width: cellContentFrame.width - horizontalMargin - labelLeading,
                                           height: cellContentFrame.height)
        } else {
            textLabel!.frame = CGRect(x: -horizontalMargin, y: 0,
                                           width: cellContentFrame.width,
                                           height: cellContentFrame.height)
        }
        
        // Checkmark icon
        if textLabel!.textAlignment == .center {
            checkmarkIcon = UIImageView(frame: CGRect(x: cellContentFrame.width - horizontalMargin,
                                                           y: (cellContentFrame.height - checkmarkIconWidth)/2,
                                                           width: checkmarkIconWidth, height: 10))
        } else if textLabel!.textAlignment == .left {
            checkmarkIcon = UIImageView(frame: CGRect(x: cellContentFrame.width - horizontalMargin,
                                                           y: (cellContentFrame.height - checkmarkIconWidth)/2,
                                                           width: checkmarkIconWidth, height: checkmarkIconWidth))
        } else {
            checkmarkIcon = UIImageView(frame: CGRect(x: horizontalMargin,
                                                           y: (cellContentFrame.height - checkmarkIconWidth)/2,
                                                           width: checkmarkIconWidth,
                                                           height: checkmarkIconWidth))
        }
        checkmarkIcon.isHidden = true
        checkmarkIcon.image = configuration.checkMarkImage
        checkmarkIcon.contentMode = UIViewContentMode.scaleAspectFill
        contentView.addSubview(checkmarkIcon)
        
        // Separator for cell
        let separator = DropdownMenuTableCellContentView(frame: cellContentFrame)
        if let cellSeparatorColor = configuration.cellSeparatorColor {
            separator.separatorColor = cellSeparatorColor
        }
        contentView.addSubview(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        bounds = cellContentFrame
        contentView.frame = bounds
    }
}

// Content view of table view cell
class DropdownMenuTableCellContentView: UIView {
    var separatorColor: UIColor = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // Set separator color of dropdown menu based on barStyle
        context?.setStrokeColor(separatorColor.cgColor)
        context?.setLineWidth(1)
        context?.move(to: CGPoint(x: 0, y: bounds.size.height))
        context?.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        context?.strokePath()
    }
}

extension UIViewController {
    // Get ViewController in top present level
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while (target?.presentedViewController != nil) {
            target = target?.presentedViewController
        }
        return target
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be visibleViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarController instance
    var topVisibleViewController: UIViewController? {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.topVisibleViewController
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.topVisibleViewController
            }
        }
        return self
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    var topMostViewController: UIViewController? {
        return topPresentedViewController?.topVisibleViewController
    }
}
