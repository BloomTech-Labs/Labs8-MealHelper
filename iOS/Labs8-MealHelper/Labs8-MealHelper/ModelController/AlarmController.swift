//
//  AlarmController.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 12/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AlarmController {
    
//    private(set) var alarms = [Alarm]()
    
    func timeUntilNextAlarm(alarms: [Alarm]) -> Int? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let now = Date()
        let timeString = dateFormatter.string(from: now)
        let timeValue = timeString.replacingOccurrences(of: ".", with: "")
        var closestAlarm: Alarm?
        var firstAlarmOfTheDay: Alarm?
        
        for alarm in alarms {
            if timeValue < alarm.time {
                if alarm.time < closestAlarm?.time ?? "2359" {
                    closestAlarm = alarm
                }
            } else {
                if alarm.time < firstAlarmOfTheDay?.time ?? "2359" {
                    firstAlarmOfTheDay = alarm
                }
            }
        }
        
        if let closestAlarm = closestAlarm {
            
            let alarmHour = String(closestAlarm.time.prefix(2))
            let alarmMinute = String(closestAlarm.time.suffix(2))
            let alarmHourInt = Int(alarmHour)!
            let alarmMinuteInt = Int(alarmMinute)!
            let nowHour = String(timeValue.prefix(2))
            let nowMinute = String(timeValue.suffix(2))
            let nowHourInt = Int(nowHour)!
            let nowMinuteInt = Int(nowMinute)!
            
            let hoursRemainingInSeconds = (alarmHourInt * 3600) - (nowHourInt * 3600)
            let minutesRemainingInSeconds = (alarmMinuteInt * 60) - (nowMinuteInt * 60)
            let timeRemaining = hoursRemainingInSeconds + minutesRemainingInSeconds
            return timeRemaining
            
        } else if let firstAlarm = firstAlarmOfTheDay {
            
            let alarmHour = String(firstAlarm.time.prefix(2))
            let alarmMinute = String(firstAlarm.time.suffix(2))
            let alarmHourInt = Int(alarmHour)!
            let alarmMinuteInt = Int(alarmMinute)!
            let nowHour = String(timeValue.prefix(2))
            let nowMinute = String(timeValue.suffix(2))
            let nowHourInt = Int(nowHour)!
            let nowMinuteInt = Int(nowMinute)!
            
            let hoursAndMinutesInSeconds = (nowHourInt * 3600) + (nowMinuteInt * 60)
            let timeRemainingOfTheDay = 86400 - hoursAndMinutesInSeconds
            let alarmHoursAndMinutesInSeconds = (alarmHourInt * 3600) + (alarmMinuteInt * 60)
            let timeRemaining = timeRemainingOfTheDay + alarmHoursAndMinutesInSeconds
            return timeRemaining
        } else {
            return nil
        }
    }
}
