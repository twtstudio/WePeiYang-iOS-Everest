////
////  ECard.swift
////  Spider
////
////  Created by Shawnee on 2020/10/3.
////
//
//import Foundation
//
//struct ECardOverview: Codable, Storable {
//    let no: String
//    let state: String
//    let balance: String
//    let expire: String
//    let subsidy: String
//
//    init(no: String, state: String, balance: String, expire: String, subsidy: String) {
//        self.no = no
//        self.state = state
//        self.balance = balance
//        self.expire = expire
//        self.subsidy = subsidy
//    }
//
//    init() {
//        self.no = "******"
//        self.state = "******"
//        self.balance = "******"
//        self.expire = "******"
//        self.subsidy = "******"
//    }
//}
//
//struct WBYTransaction: Codable, Storable {
//    let qtype: String
//    let date: String
//    let time: String
//    let device: String
//    let amount: Double
//    let balance: Double
//
//    var dateTime: String {
//        var dateStr = ""
//        for (i, c) in date.enumerated() {
//            dateStr += String(c)
//            if [3, 5].contains(i) {
//                dateStr += "-"
//            }
//        }
//
//        var timeStr = ""
//        for (i, c) in time.enumerated() {
//            timeStr += String(c)
//            if [1, 3].contains(i) {
//                timeStr += ":"
//            }
//        }
//
//        return "\(dateStr) \(timeStr)"
//    }
//
//    var signedAmount: String {
//        qtype == "1" ? "+\(amount)" : "-\(amount)"
//    }
//
////    init(qtype: String, date: String, time: String, device: String, amount: Double, balance: Double) {
////        self.qtype = qtype
////        self.date = date
////        self.time = time
////        self.device = device
////        self.amount = amount
////        self.balance = balance
////    }
//
//    init(qtype: String, transaction: [String]) {
//        self.qtype = qtype
//        self.date = transaction[0]
//        self.time = transaction[1]
//        self.device = transaction[2]
//        self.amount = Double(transaction[3]) ?? 0
//        self.balance = Double(transaction[4]) ?? 0
//    }
//
//    init() {
//        self.qtype = ""
//        self.date = ""
//        self.time = ""
//        self.device = ""
//        self.amount = 0
//        self.balance = 0
//    }
//}
//
//struct DailyAmount: Codable, Storable {
//    let date: String
//    let amount: Double
//
//    var formatDate: String {
//        var dateStr = ""
//        for (i, c) in date.enumerated() {
//            dateStr += String(c)
//            if [3, 5].contains(i) {
//                dateStr += "-"
//            }
//        }
//
//        return dateStr
//    }
//
////    init(date: String, amount: Double) {
////        self.date = date
////        self.amount = amount
////    }
//
//    init(dailyAmount: [String]) {
//        self.date = dailyAmount[1]
//        self.amount = Double(dailyAmount[2]) ?? 0
//    }
//
//    init() {
//        self.date = ""
//        self.amount = 0
//    }
//}
//
//struct SiteAmount: Codable, Storable {
//    let name: String
//    let amount: Double
//
////    init(name: String, amount: Double) {
////        self.name = name
////        self.amount = amount
////    }
//
//    init(siteAmount: [String]) {
//        self.name = siteAmount[1]
//        self.amount = Double(siteAmount[2]) ?? 0
//    }
//
//    init() {
//        self.name = ""
//        self.amount = 0
//    }
//}
//
//struct PeriodAmount: Codable, Storable {
//    let period: String
//    let transactionArray: [WBYTransaction]
//    let dailyConsumeArray: [DailyAmount]
//    let siteConsumeArray: [SiteAmount]
//    let siteRechargeArray: [SiteAmount]
//
//    init(
//        period: String,
//        transactionArray: [WBYTransaction],
//        dailyConsumeArray: [DailyAmount],
//        siteConsumeArray: [SiteAmount],
//        siteRechargeArray: [SiteAmount]
//    ) {
//        self.period = period
//        self.transactionArray = transactionArray.sorted { $0.date > $1.date }
//        self.dailyConsumeArray = dailyConsumeArray.sorted { $0.date < $1.date }
//        self.siteConsumeArray = siteConsumeArray.sorted { $0.amount < $1.amount }
//        self.siteRechargeArray = siteRechargeArray.sorted { $0.amount < $1.amount }
//    }
//
//    init() {
//        self.period = ""
//        self.transactionArray = []
//        self.dailyConsumeArray = []
//        self.siteConsumeArray = []
//        self.siteRechargeArray = []
//    }
//}
//
//struct ECard: Codable, Storable {
//    let overview: ECardOverview
//    let periodAmountArray: [PeriodAmount]
//
//    init(overview: ECardOverview, periodAmountArray: [PeriodAmount]) {
//        self.overview = overview
//        self.periodAmountArray = periodAmountArray
//    }
//
//    init() {
//        self.overview = ECardOverview()
//        self.periodAmountArray = []
//    }
//}
