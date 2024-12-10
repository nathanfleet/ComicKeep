//
//  StatisticsViewController.swift
//  ComicKeep
//
//  Created by Nathan Fleet on 11/13/24.
//

import UIKit
import CoreData
import SwiftUI
import Charts

class StatisticsViewController: UIViewController {
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var chartContainerView: UIView!
    
    var comics: [Comic] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchComics()
        updateTotalValue()
        updateChartData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyAppearanceSettings), name: NSNotification.Name("AppearanceDidChange"), object: nil)
    }
    
    @objc func applyAppearanceSettings() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "DarkModeEnabled")
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
    
    func updateTotalValue() {
        let total = comics.reduce(0.0) { sum, comic in
            let priceDouble = comic.price?.doubleValue ?? 0.0
            return sum + priceDouble
        }

        totalValueLabel.text = String(format: "Total Collection Value: $%.2f", total)
    }

    func updateChartData() {
        let groupedData = groupComicsByDay(comics: comics)
        drawChart(with: groupedData)
    }
    
    func groupComicsByDay(comics: [Comic]) -> [Date: Double] {
        var dailyTotals: [Date: Double] = [:]
        let calendar = Calendar.current

        for comic in comics {
            guard let dateAdded = comic.dateAdded else { continue }
            let components = calendar.dateComponents([.year, .month, .day], from: dateAdded)
            if let dayDate = calendar.date(from: components) {
                let priceDouble = comic.price?.doubleValue ?? 0.0
                dailyTotals[dayDate, default: 0.0] += priceDouble
            }
        }

        return dailyTotals
    }
    
    func drawChart(with data: [Date: Double]) {
        chartContainerView.subviews.forEach { $0.removeFromSuperview() }

        let chartView = DailySpendingChart(data: data)

        let hostingController = UIHostingController(rootView: chartView)
        addChild(hostingController)
        hostingController.view.frame = chartContainerView.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        chartContainerView.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    // MARK: Data Methods
    func fetchComics() {
        if let fetched = CoreDataManager.shared.fetchComics(acquired: true, wishlist: false) {
            comics = fetched
        } else {
            comics = []
        }
    }
}

