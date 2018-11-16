//
//  Created by Honghao Zhang on 12/13/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import Nimble
import Quick

class Date_ExtensionsTests: QuickSpec {
    override func spec() {
        randomDateSpec()
        dateComponentSpec()
    }
}

extension Date_ExtensionsTests {
    func randomDateSpec() {
        context("random date in range", {
            it("should get a random date in range.") {
                guard let fromDate = Date(year: 1989, month: 12, day: 24) else {
                    fail()
                    return
                }

                guard let toDate = fromDate.setting(.day, with: fromDate.day + 5) else {
                    fail()
                    return
                }

                let randomDate = Date.randomDate(in: fromDate..<toDate)
                expect(randomDate) >= fromDate
                expect(randomDate) < toDate
            }

            it("should get nil date when range is empty") {
                guard let fromDate = Date(year: 1989, month: 12, day: 24) else {
                    fail()
                    return
                }

                let toDate = fromDate
                let randomDate = Date.randomDate(in: fromDate..<toDate)
                expect(randomDate).to(beNil())
            }
        })

        context("random date in closed range", {
            it("should get a random date in range.") {
                guard let fromDate = Date(year: 1989, month: 12, day: 24) else {
                    fail()
                    return
                }

                guard let toDate = fromDate.setting(.day, with: fromDate.day + 5) else {
                    fail()
                    return
                }

                let randomDate = Date.randomDate(in: fromDate..<toDate)
                expect(randomDate) >= fromDate
                expect(randomDate) <= toDate
            }

            it("should get the same date") {
                guard let fromDate = Date(year: 1989, month: 12, day: 24) else {
                    fail()
                    return
                }

                let toDate = fromDate
                let randomDate = Date.randomDate(in: fromDate...toDate)
                expect(randomDate) == fromDate
            }
        })

        it("should get a random date since 1970.") {
            expect(Date.randomDateSince1970()) > Date(timeIntervalSince1970: 0)
            expect(Date.randomDateSince1970()) != Date.randomDateSince1970()
        }
    }
}

extension Date_ExtensionsTests {
    func dateComponentSpec() {
        context("Setting/getting date components") {
            var date: Date!
            beforeEach {
                date = Date(year: 2018,
                            month: 11,
                            day: 15,
                            hour: 12,
                            minute: 13,
                            second: 14,
                            nanosecond: 678000000,
                            timeZone: TimeZone.pst,
                            calendar: Calendar.gregorian) ?? Date()
            }

            it("should get correct date components") {
                expect(date.era) == 1
                expect(date.year) == 2018
                expect(date.month) == 11
                expect(date.day) == 15
                // Ignore hour since the test environment is undetermined.
                expect(date.minute) == 13
                expect(date.second) == 14
                expect(date.weekday) == 5
                expect(date.weekdayOrdinal) == 3
                expect(date.quarter) == 4
                expect(date.weekOfMonth) == 3
                expect(date.weekOfYear) == 46
                expect(date.yearForWeekOfYear) == 2018
                expect(abs(date.nanosecond - 678000000)) < 100
            }

            it("should get correct date components in time zone") {
                expect(date.hour(in: TimeZone.est, for: Calendar.gregorian)) == 15
                expect(date.minute(in: TimeZone.est, for: Calendar.gregorian)) == 13
            }

            it("should get correct date by setting date components") {
                // `era`
                expect(date.setting(.era, with: 0)?.era) == 0

                // `year`
                let year1990 = date.setting(.year, with: 1990)
                expect(year1990?.year) == 1990
                expect(year1990?.yearForWeekOfYear) == 1990

                // `month`
                let month12 = date.setting(.month, with: 12)
                expect(month12?.month) == 12
                expect(month12?.weekday) == 7
                let month13 = date.setting(.month, with: 13)
                expect(month13?.year) == date.year + 1
                expect(month13?.month) == 1
                expect(month13?.weekday) == 3
                let month_2 = date.setting(.month, with: -2)
                expect(month_2?.year) == 2017
                expect(month_2?.month) == 10
                expect(month_2?.day) == 15

                // `day`
                let day30 = date.setting(.day, with: 30)
                expect(day30?.day) == 30
                let day31 = date.setting(.day, with: 31)
                expect(day31?.month) == date.month + 1
                expect(day31?.day) == 1
                expect(day31?.weekdayOrdinal) == 1
                let day_1 = date.setting(.day, with: -1)
                expect(day_1?.month) == date.month - 1
                expect(day_1?.day) == 30

                // `hour`
                let hour14 = date.setting(.hour, with: 14)
                expect(hour14?.hour) == 14
                let hour25 = date.setting(.hour, with: 25)
                expect(hour25?.day) == date.day + 1
                expect(hour25?.hour) == 1
                let hour_2 = date.setting(.hour, with: -2)
                expect(hour_2?.day) == date.day - 1
                expect(hour_2?.hour) == 22

                // `minute`
                let minute31 = date.setting(.minute, with: 31)
                expect(minute31?.minute) == 31
                let minute61 = date.setting(.minute, with: 61)
                expect(minute61?.hour) == date.hour + 1
                expect(minute61?.minute) == 1
                let minute_2 = date.setting(.minute, with: -2)
                expect(minute_2?.hour) == date.hour - 1
                expect(minute_2?.minute) == 58

                // `second`
                let second31 = date.setting(.second, with: 31)
                expect(second31?.second) == 31
                let second61 = date.setting(.second, with: 61)
                expect(second61?.minute) == date.minute + 1
                expect(second61?.second) == 1
                let second_1 = date.setting(.second, with: -1)
                expect(second_1?.minute) == date.minute - 1
                expect(second_1?.second) == 59

                // `weekday`
                let weekday6 = date.setting(.weekday, with: 6)
                expect(weekday6?.weekday) == 6
                expect(weekday6?.day) == 16
                let weekday8 = date.setting(.weekday, with: 8)
                expect(weekday8?.weekday) == 1
                expect(weekday8?.day) == date.day + 3
                let weekday16 = date.setting(.weekday, with: 16)
                expect(weekday16?.weekday) == 2
                expect(weekday16?.day) == date.day + 11
                let weekday_2 = date.setting(.weekday, with: -3)
                expect(weekday_2?.weekday) == 4
                expect(weekday_2?.month) == 11
                expect(weekday_2?.day) == 7

                // `weekdayOrdinal`
                let weekdayOrdinal2 = date.setting(.weekdayOrdinal, with: 2)
                expect(weekdayOrdinal2?.weekdayOrdinal) == 2
                expect(weekdayOrdinal2?.day) == 8
                let weekdayOrdinal_1 = date.setting(.weekdayOrdinal, with: -1)
                expect(weekdayOrdinal_1?.weekdayOrdinal) == 3
                expect(weekdayOrdinal_1?.month) == 10
                expect(weekdayOrdinal_1?.day) == 18

                // `quarter`
                let quarter2 = date.setting(.quarter, with: 2)
                expect(quarter2?.quarter) == 2
                expect(quarter2?.month) == date.month - 6
                expect(quarter2?.day) == 15
                let quarter_1 = date.setting(.quarter, with: -1)
                expect(quarter_1?.quarter) == 3
                expect(quarter_1?.month) == date.month - 3
                expect(quarter_1?.day) == 15

                // `weekOfMonth`
                let weekOfMonth4 = date.setting(.weekOfMonth, with: 4)
                expect(weekOfMonth4?.weekOfMonth) == 4
                expect(weekOfMonth4?.day) == 22
                expect(weekOfMonth4?.weekdayOrdinal) == 4
                let weekOfMonth_1 = date.setting(.weekOfMonth, with: -1)
                expect(weekOfMonth_1?.weekOfMonth) == 3
                expect(weekOfMonth_1?.month) == 10
                expect(weekOfMonth_1?.day) == 18

                // `weekOfYear`
                let weekOfYear47 = date.setting(.weekOfYear, with: 47)
                expect(weekOfYear47?.weekOfYear) == 47
                expect(weekOfYear47?.weekOfMonth) == 4
                expect(weekOfYear47?.month) == 11
                expect(weekOfYear47?.day) == 22
                expect(weekOfYear47?.weekdayOrdinal) == 4
                let weekOfYear_1 = date.setting(.weekOfYear, with: -1)
                expect(weekOfYear_1?.weekOfYear) == 51
                expect(weekOfYear_1?.weekOfMonth) == 4
                expect(weekOfYear_1?.year) == 2017
                expect(weekOfYear_1?.month) == 12
                expect(weekOfYear_1?.day) == 21
                expect(weekOfYear_1?.weekdayOrdinal) == 3

                // `yearForWeekOfYear`
                let yearForWeekOfYear2019 = date.setting(.yearForWeekOfYear, with: 2019)
                expect(yearForWeekOfYear2019?.yearForWeekOfYear) == 2019
                expect(yearForWeekOfYear2019?.year) == 2019

                // `nanosecond`
                expect(abs(date.setting(.nanosecond, with: 789000000)?.nanosecond ?? 0) - 789000000) < 100

                // `timeZone`, `calendar`
                expect(date.setting(.timeZone, with: 1)) == date
                expect(date.setting(.calendar, with: 1)) == date
            }

            it("should get correct date by setting date components, leap month") {
                let date0229 = Date(year: 2020,
                                    month: 2,
                                    day: 29,
                                    hour: 12,
                                    minute: 13,
                                    second: 14,
                                    nanosecond: 678000000,
                                    timeZone: TimeZone.autoupdatingCurrent,
                                    calendar: Calendar.gregorian) ?? Date()
                // `year`
                let year2019 = date0229.setting(.year, with: 2019)
                expect(year2019?.year) == 2019
                expect(year2019?.month) == 3
                expect(year2019?.day) == 1

                let date0331 = Date(year: 2020,
                                    month: 3,
                                    day: 31,
                                    hour: 12,
                                    minute: 13,
                                    second: 14,
                                    nanosecond: 678000000,
                                    timeZone: TimeZone.autoupdatingCurrent,
                                    calendar: Calendar.gregorian) ?? Date()
                // `month`
                let month4 = date0331.setting(.month, with: 4)
                expect(month4?.month) == 5
                expect(month4?.day) == 1
            }

            it("should get correct date by setting date components in timezone") {
                let hour14 = date.setting(.hour, with: 14, in: TimeZone.est)
                expect(hour14?.hour(in: TimeZone.pst)) == 11
            }
        }
    }
}
