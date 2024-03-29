/*
 * Copyright (C) 2022 Application Library Engineering Group
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ClockPeriod, TimeFormat } from "./Types"

export class TimeModel {
  hour: number
  minute: number
  hourForDisplay: string
  minuteForDisplay: string
  period: ClockPeriod
  format: TimeFormat
  constructor(hour: number, minute: number, format: TimeFormat) {
    this.format = format
    this.period = ClockPeriod.AM
    this.setHour(hour)
    this.setMinute(minute)
    this.setHourOfDay(hour)
  }

  public setHour(hour: number) {
    if (hour == null || hour == undefined) {
      return
    }
    if (hour < 0 || hour > 24) {
      return
    }
    if (this.format == TimeFormat.CLOCK_24H) {
      this.hour = hour % 24
    }
    else {
      this.hour = hour % 12 + (this.period == ClockPeriod.PM ? 12 : 0)
    }
    this.hourForDisplay = this.formattedHour()
  }

  public setHourOfDay(hour: number) {
    if (hour == null || hour == undefined) {
      return
    }
    if (hour < 0 || hour > 24) {
      return
    }
    hour %= 24
    this.period = hour >= 12 ? ClockPeriod.PM : ClockPeriod.AM
    this.hour = hour
    this.hourForDisplay = this.formattedHour()
  }

  public getHourForDisplay() {
    if (this.format == TimeFormat.CLOCK_24H) {
      return this.hour
    }
    if ((this.hour % 12) == 0) {
      return 12
    }
    if (this.period == ClockPeriod.PM) {
      return this.hour - 12
    }
    return this.hour
  }

  public getMinuteForDisplay() {
    return this.minute
  }

  public formattedHour() {
    return String(this.getHourForDisplay()).padStart(2, '0')
  }

  public formattedMinute() {
    return String(this.getMinuteForDisplay()).padStart(2, '0')
  }

  public setMinute(minute: number) {
    if (minute == null || minute == undefined) {
      return
    }
    if (minute >= 0 && minute <= 60) {
      this.minute = minute % 60
    }
    this.minuteForDisplay = this.formattedMinute()
  }

  public getTimeForDisplay() {
    var period: string = this.format == TimeFormat.CLOCK_12H ? " " + this.getPeriod() : ""
    return this.formattedHour() + ":" + this.formattedMinute() + period
  }

  public getPeriod() {
    return this.period == ClockPeriod.AM ? "AM" : "PM"
  }

  public setPeriod(period: ClockPeriod) {
    if (period == null || period == undefined) {
      return
    }
    if (this.format == TimeFormat.CLOCK_12H && this.period != period) {
      this.period = period
      if (this.hour < 12 && period == ClockPeriod.PM) {
        this.hour += 12
      }
      else if (this.hour >= 12 && period == ClockPeriod.AM) {
        this.hour -= 12
      }
    }
  }
}