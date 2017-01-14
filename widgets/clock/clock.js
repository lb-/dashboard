import React from 'react';
import moment from 'moment';
// import 'moment-timezone';
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
      </div>
    );
  }
  static formatTime(i) { return i < 10 ? "0" + i : i; }
  static dateTime() {
    var today = new Date(),//moment().tz("America/Toronto").toDate(),
        h = today.getHours(),
        m = today.getMinutes(),
        s = today.getSeconds(),
        m = Clock.formatTime(m),
        s = Clock.formatTime(s);
    console.log(moment()); //next step - make this use timezone
    return {
      time: (h + ":" + m + ":" + s),
      date: today.toDateString(),
    }
  }
});
