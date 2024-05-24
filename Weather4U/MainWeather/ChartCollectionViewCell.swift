//
//  ChartCollectionViewCell.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/16/24.
//

import DGCharts
import UIKit

class ChartCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChartCollectionViewCell"
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    var lineChartView = LineChartView()
    var entries: [ChartDataEntry] = []
    var weatherStatus = ""
    var weatherType = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setEntries()
        configureUI()
        constraintLayout()
        configureLineChartView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [titleLabel,
         descriptionLabel, lineChartView].forEach(){
            addSubview($0)
        }
        titleLabel.text = "Rain Forecasted"
        titleLabel.textColor = self.setFontColor()
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        
        descriptionLabel.text = "Rain for the next hour"
        descriptionLabel.textColor = self.setFontColor()
        descriptionLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
    }
    
    func configureLineChartView() {
        let dataSet = LineChartDataSet(entries: entries, label: "강수량(mm)")
        dataSet.drawValuesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = CGFloat(3.0)
        dataSet.setColor(setFontColor())
        dataSet.setCircleColor(setFontColor())

        let data = LineChartData(dataSet: dataSet)
        
        lineChartView.data = data
        
        // String 배열 정의
        let hours = ["Now", "1h", "2h", "3h", "4h", "5h", "6h"]
        
        // Y축 범위 설정 (왼쪽 Y축)
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.axisMaximum = 50.0
        
        // xAxis valueFormatter 설정
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: hours)
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelTextColor = setFontColor()
        lineChartView.xAxis.axisLineColor = setFontColor()
        
        
        // xAxis 레이블 아래로 위치시키기
        lineChartView.xAxis.labelPosition = .bottom
        
        // 그리드 라인 제거
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        
        // 필요에 따라 축선 및 레이블 숨기기
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        lineChartView.legend.enabled = false // 범례 숨기기
        lineChartView.chartDescription.enabled = false // 차트 설명 숨기기
    }
    
    func constraintLayout() {
        titleLabel.snp.makeConstraints() {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        descriptionLabel.snp.makeConstraints() {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(18)
        }
        lineChartView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(72) // 차트의 높이 설정
        }
    }
    
    func setEntries() {
        self.entries.removeAll()
        
        for i in 0...6 {
            if !DataProcessingManager.dayForecast.isEmpty {
                let doubleValue = DataProcessingManager.dayForecast[i].PCP
                self.entries.append(ChartDataEntry(x: Double(i), y: Double(doubleValue) ?? 0.0))
            } else {
                self.entries.append(ChartDataEntry(x: Double(i), y: Double.random(in: 1...50)))
            }
        }
        self.configureLineChartView()
        titleLabel.textColor = self.setFontColor()
        descriptionLabel.textColor = self.setFontColor()
    }
    
    func setFontColor() -> UIColor {
        switch self.weatherStatus {
        case "Sunny":
            return UIColor(named: "font")!
        case "Mostly Cloudy":
            switch self.weatherType {
            case "비", "소나기":
                return UIColor(named: "fontR")!
            case "눈", "비/눈":
                return UIColor(named: "fontS")!
            default:
                return UIColor(named: "fontR")!
            }
        default:
            return UIColor(named: "font")!
        }
    }
    
    func setCellColor() -> UIColor {
        switch self.weatherStatus {
        case "Sunny":
            return UIColor(named: "cell")!
        case "Mostly Cloudy":
            switch self.weatherType {
            case "비", "소나기":
                return UIColor(named: "cellR")!
            case "눈", "비/눈":
                return UIColor(named: "cellS")!
            default:
                return UIColor(named: "cellR")!
            }
        default:
            return UIColor(named: "cell")!
        }
    }
}
