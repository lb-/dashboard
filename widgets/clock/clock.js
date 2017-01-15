import React from 'react';
import Widget from '../../assets/javascripts/widget';

import './clock.scss';

Widget.mount(class Clock extends Widget {
  constructor(props) {
    super(props);
    this.state = Clock.dateTime()
    setInterval(this.update.bind(this), 500);
  }
  update() { this.setState(Clock.dateTime()); }
  render() {

    return (
      <div className={this.props.className}>
        <h1 className="date">{this.state.date}</h1>
        <h2 className="time">{this.state.time}</h2>
        <p className="more-info">{this.state.moreinfo || this.props.moreinfo}</p>
      </div>
    );
  }
  static formatTime(i) { return i < 10 ? "0" + i : i; }
  static dateTime() {
    var offset = '+7.0';
    var today = new Date(),//moment().tz("America/Toronto").toDate(),
        h = today.getHours(),
        m = today.getMinutes(),
        s = today.getSeconds(),
        m = Clock.formatTime(m),
        s = Clock.formatTime(s);
    var utc = today.getTime() + (today.getTimezoneOffset() * 60000);
    var today_in_tz = new Date(utc + (3600000 * offset));
    return {
      time: (h + ":" + m + ":" + s),
      date: today.toDateString(),
    }
  }
});
