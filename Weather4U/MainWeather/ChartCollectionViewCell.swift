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
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        titleLabel.textColor = UIColor(named: "font")
        
        descriptionLabel.text = "Rain for the next hour"
        descriptionLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 15)
        titleLabel.textColor = UIColor(named: "font")
    }
    
    func configureLineChartView() {
        let dataSet = LineChartDataSet(entries: entries, label: "강수량(mm)")
        dataSet.drawValuesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = CGFloat(3.0)
        if let customColor = UIColor(named: "font") {
            dataSet.setColor(customColor)
            dataSet.setCircleColor(customColor)
        }
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
    }
    
}
