//
//  PhotoGallery.swift
//  PhotoGallery
//
//  Created by Vuong Nguyen on 2/22/18.
//  Copyright © 2018 Vuong Nguyen. All rights reserved.
//

import Foundation
import UIKit

public protocol PhotoGalleryDataSource: class {
    func numberOfImages(_ gallery: PhotoGallery) -> Int
    func photoGallery(_ gallery: PhotoGallery, imageAt index: Int) -> UIImage?
}

public protocol PhotoGalleryDelegate: class {
    func photoGallery(_ gallery: PhotoGallery, didTapAt index: Int)
}

extension PhotoGalleryDelegate {
    func photoGallery(_ gallery: PhotoGallery, didTapAt index: Int) { }
}

public class PhotoGallery: UIViewController {

    fileprivate var animateImageTransition = false
    fileprivate var isViewFirstAppearing = true
    fileprivate var deviceInRotation = false

    public weak var dataSource: PhotoGalleryDataSource?
    public weak var delegate: PhotoGalleryDelegate?

    public lazy var collectionView: UICollectionView = self.setupCollectionView()

    public var numberOfImages: Int {
        return collectionView(collectionView, numberOfItemsInSection: 0)
    }

    public var backgroundColor: UIColor {
        get {
            return view.backgroundColor!
        }
        set(newBackgroundColor) {
            view.backgroundColor = newBackgroundColor
        }
    }

    public var currentPageIndicatorTintColor: UIColor {
        get {
            return pageControl.currentPageIndicatorTintColor!
        }
        set(newCurrentPageIndicatorTintColor) {
            pageControl.currentPageIndicatorTintColor = newCurrentPageIndicatorTintColor
        }
    }

    public var pageIndicatorTintColor: UIColor {
        get {
            return pageControl.pageIndicatorTintColor!
        }
        set(newPageIndicatorTintColor) {
            pageControl.pageIndicatorTintColor = newPageIndicatorTintColor
        }
    }

    public var numberOfImagesTextColor: UIColor {
        get {
            return numberOfImagesLabel.textColor
        }
        set {
            numberOfImagesLabel.textColor = newValue
        }
    }

    public var currentPage: Int {
        set(page) {
            if page < numberOfImages {
                scrollToImage(withIndex: page, animated: false)
            } else {
                scrollToImage(withIndex: numberOfImages - 1, animated: false)
            }
            updatePageControl()
            updateNumberOfImagesLabel()
        }
        get {
            if isRevolvingCarouselEnabled {
                pageBeforeRotation = Int(collectionView.contentOffset.x / collectionView.frame.size.width) - 1
                return Int(collectionView.contentOffset.x / collectionView.frame.size.width) - 1
            } else {
                pageBeforeRotation = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
                return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
            }
        }
    }

    public var hidePageControl: Bool = false {
        didSet {
            pageControl.isHidden = hidePageControl
        }
    }

    public var hideNumberOfImagesLabel: Bool = false {
        didSet {
            numberOfImagesLabel.isHidden = hideNumberOfImagesLabel
        }
    }

    public var hideStatusBar: Bool = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    public var isSwipeToDismissEnabled: Bool = true
    public var isRevolvingCarouselEnabled: Bool = true

    private var pageBeforeRotation: Int = 0
    private var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var pageControl: UIPageControl = UIPageControl()
    private var numberOfImagesLabel: UILabel = UILabel()
    private var pageControlBottomConstraint: NSLayoutConstraint?
    private var pageControlCenterXConstraint: NSLayoutConstraint?
    private var needsLayout = true

    // MARK: Public Interface
    public init() {
        super.init(nibName: nil, bundle: nil)
        //
        //        self.dataSource = dataSource
        //        self.delegate = delegate
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func reload(imageIndexes: Int...) {

        if imageIndexes.isEmpty {
            collectionView.reloadData()

        } else {
            let indexPaths: [IndexPath] = imageIndexes.map({IndexPath(item: $0, section: 0)})
            collectionView.reloadItems(at: indexPaths)
        }
    }

    // MARK: Lifecycle methods
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        flowLayout.itemSize = view.bounds.size
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if needsLayout {
            let desiredIndexPath = IndexPath(item: pageBeforeRotation, section: 0)

            if pageBeforeRotation >= 0 {
                scrollToImage(withIndex: pageBeforeRotation, animated: false)
            }

            collectionView.reloadItems(at: [desiredIndexPath])

            for cell in collectionView.visibleCells {
                if let cell = cell as? PhotoGalleryCollectionViewCell {
                    cell.configureForNewImage(animated: false)
                }
            }

            needsLayout = false
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor(white: 0.75, alpha: 0.35) //Dim Gray

        isRevolvingCarouselEnabled = numberOfImages > 1
        setupPageControl()
        setupNumberOfImagesLabel()
        setupGestureRecognizers()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if currentPage < 0 {
            currentPage = 0
        }
        isViewFirstAppearing = false
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    public override var prefersStatusBarHidden: Bool {
        get {
            return hideStatusBar
        }
    }

    // MARK: Rotation Handling
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        deviceInRotation = true
        needsLayout = true
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .allButUpsideDown
        }
    }

    public override var shouldAutorotate: Bool {
        get {
            return true
        }
    }

    // MARK: - Internal Methods
    func updatePageControl() {
        pageControl.currentPage = currentPage
    }

    func updateNumberOfImagesLabel() {
        numberOfImagesLabel.text = "\(currentPage + 1) of \(numberOfImages)"
    }

    // MARK: Gesture Handlers
    private func setupGestureRecognizers() {

        let panGesture = PanDirectionGestureRecognizer(direction: PanDirection.vertical, target: self, action: #selector(wasDragged(_:)))
        collectionView.addGestureRecognizer(panGesture)
        collectionView.isUserInteractionEnabled = true

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        collectionView.addGestureRecognizer(singleTap)
    }

    @objc
    private func wasDragged(_ gesture: PanDirectionGestureRecognizer) {

        guard let image = gesture.view, isSwipeToDismissEnabled else { return }

        let translation = gesture.translation(in: self.view)
        image.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY + translation.y)

        let yFromCenter = image.center.y - self.view.bounds.midY

        let alpha = 1 - abs(yFromCenter / self.view.bounds.midY)
        self.view.backgroundColor = backgroundColor.withAlphaComponent(alpha)

        if gesture.state == UIGestureRecognizer.State.ended {

            var swipeDistance: CGFloat = 0
            let swipeBuffer: CGFloat = 50
            var animateImageAway = false

            if yFromCenter > -swipeBuffer && yFromCenter < swipeBuffer {
                // reset everything
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.backgroundColor = self.backgroundColor.withAlphaComponent(1.0)
                    image.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
                })
            } else if yFromCenter < -swipeBuffer {
                swipeDistance = 0
                animateImageAway = true
            } else {
                swipeDistance = self.view.bounds.height
                animateImageAway = true
            }

            if animateImageAway {
                if self.modalPresentationStyle == .custom {
                    self.delegate?.photoGallery(self, didTapAt: currentPage)
                    return
                }

                UIView.animate(withDuration: 0.35, animations: {
                    self.view.alpha = 0
                    image.center = CGPoint(x: self.view.bounds.midX, y: swipeDistance)
                }, completion: { (complete) in
                    self.delegate?.photoGallery(self, didTapAt: self.currentPage)
                })
            }

        }
    }

    @objc
    public func singleTapAction(recognizer: UITapGestureRecognizer) {
        delegate?.photoGallery(self, didTapAt: currentPage)
    }

    // MARK: Private Methods
    private func setupCollectionView() -> UICollectionView {
        // Set up flow layout
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        // Set up collection view
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoGalleryCollectionViewCell.self, forCellWithReuseIdentifier: PhotoGalleryCollectionViewCell.reuseIdentifier)
        collectionView.register(PhotoGalleryCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PhotoGalleryCollectionViewCell.reuseIdentifier)
        collectionView.register(PhotoGalleryCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoGalleryCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true

        // Set up collection view constraints
        var imageCollectionViewConstraints: [NSLayoutConstraint] = []
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .leading,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .leading,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .trailing,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .trailing,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .bottom,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .bottom,
                                                                 multiplier: 1,
                                                                 constant: 0))

        view.addSubview(collectionView)
        view.addConstraints(imageCollectionViewConstraints)

        collectionView.contentSize = CGSize(width: 1000.0, height: 1.0)

        return collectionView
    }

    private func setupPageControl() {

        pageControl.translatesAutoresizingMaskIntoConstraints = false

        pageControl.numberOfPages = numberOfImages
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor

        pageControl.alpha = 1
        pageControl.isHidden = hidePageControl

        view.addSubview(pageControl)

        pageControlCenterXConstraint = NSLayoutConstraint(item: pageControl,
                                                          attribute: .centerX,
                                                          relatedBy: .equal,
                                                          toItem: view,
                                                          attribute: .centerX,
                                                          multiplier: 1.0,
                                                          constant: 0)

        pageControlBottomConstraint = NSLayoutConstraint(item: view ?? UIView(),
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: pageControl,
                                                         attribute: .bottom,
                                                         multiplier: 1.0,
                                                         constant: 15)

        view.addConstraints([pageControlCenterXConstraint!, pageControlBottomConstraint!])
    }

    private func setupNumberOfImagesLabel() {
        numberOfImagesLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfImagesLabel.font = UIFont.systemFont(ofSize: 17)
        numberOfImagesLabel.textAlignment = .center
        numberOfImagesLabel.alpha = 1
        numberOfImagesLabel.isHidden = hideNumberOfImagesLabel

        view.addSubview(numberOfImagesLabel)

        numberOfImagesLabel.shadow(color: .black, offset: CGSize(width: 1, height: 1), blur: 4, spread: 0, opacity: 0.5)

        numberOfImagesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        numberOfImagesLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }

    private func scrollToImage(withIndex: Int, animated: Bool = false) {
        collectionView.scrollToItem(at: IndexPath(item: withIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }

    private func getImage(currentPage: Int) -> UIImage? {
        let imageForPage = dataSource?.photoGallery(self, imageAt: currentPage)
        return imageForPage
    }

}

// MARK: UICollectionViewDataSource Methods
extension PhotoGallery: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ imageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfImages(self) ?? 0
    }

    public func collectionView(_ imageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoGalleryCollectionViewCell
        cell.image = getImage(currentPage: indexPath.row)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PhotoGalleryCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoGalleryCollectionViewCell

        switch kind {
        case UICollectionView.elementKindSectionFooter:
            cell.image = getImage(currentPage: 0)
        case UICollectionView.elementKindSectionHeader:
            cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoGalleryCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoGalleryCollectionViewCell
            if isViewFirstAppearing {
                cell.image = getImage(currentPage: 0)
            } else {
                cell.image = getImage(currentPage: numberOfImages - 1)
            }
        default:
            assertionFailure("Unexpected element kind")
        }

        return cell
    }

    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard isRevolvingCarouselEnabled else { return CGSize.zero }
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }

    @objc public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard isRevolvingCarouselEnabled else { return CGSize.zero }
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}


// MARK: UICollectionViewDelegate Methods
extension PhotoGallery: UICollectionViewDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animateImageTransition = true
        self.pageControl.alpha = 1.0
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateImageTransition = false

        // If the scroll animation ended, update the page control to reflect the current page we are on
        updatePageControl()
        updateNumberOfImagesLabel()

        UIView.animate(withDuration: 1.0, delay: 2.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.pageControl.alpha = 0.0
        }, completion: nil)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? PhotoGalleryCollectionViewCell {
            cell.configureForNewImage(animated: animateImageTransition)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if let cell = view as? PhotoGalleryCollectionViewCell {
            collectionView.layoutIfNeeded()
            cell.configureForNewImage(animated: animateImageTransition)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).isEmpty && !deviceInRotation || (currentPage == numberOfImages && !deviceInRotation) {
            currentPage = 0
        }
        if !collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).isEmpty && !deviceInRotation || (currentPage == -1 && !deviceInRotation) {
            currentPage = numberOfImages - 1
        }
        deviceInRotation = false
    }
}


// MARK: UIGestureRecognizerDelegate Methods
extension PhotoGallery: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return otherGestureRecognizer is UITapGestureRecognizer &&
            gestureRecognizer is UITapGestureRecognizer &&
            otherGestureRecognizer.view is PhotoGalleryCollectionViewCell &&
            gestureRecognizer.view == collectionView
    }
}
