// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  number,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.grey,
  _Element.number: Colors.black54,
  _Element.text: Colors.black54,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.number: Colors.white,
  _Element.text: Colors.white,
};

final _weatherIcon = {
  WeatherCondition.cloudy: 0xe624,
  WeatherCondition.foggy: 0xe67d,
  WeatherCondition.rainy: 0xe674,
  WeatherCondition.snowy: 0xe67e,
  WeatherCondition.sunny: 0xe67c,
  WeatherCondition.thunderstorm: 0xe67b,
  WeatherCondition.windy: 0xe671
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    return Container(
        color: colors[_Element.background],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: <Widget>[
              /// time
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.75,
                  heightFactor: 0.6,
                  child: _getTimeWidget(colors),
                ),
              ),

              /// AM/PM
              Positioned.fill(
                  child: FractionallySizedBox(
                      alignment: Alignment.bottomLeft,
                      heightFactor: 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _getAMPMWidget(colors),
                      ))),

              /// location
              Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomRight,
                    heightFactor: 0.2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _getLocationWidget(colors),
                    ),
                  )),

              /// temperature
              Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerRight,
                    heightFactor: 0.6,
                    widthFactor: 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        _getWeatherIcon(colors),
                        _getTemperatureWidget(colors),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  /// time display widget
  Widget _getTimeWidget(Map colors) {
    final hour =
    DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: NumberWidget(
            number: int.parse(hour.substring(0, 1)),
            size: Size.infinite,
            color: colors[_Element.number],
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: NumberWidget(
            number: int.parse(hour.substring(1, 2)),
            size: Size.infinite,
            color: colors[_Element.number],
          ),
        ),
        SizedBox(width: 7),
        DotWidget(
          size: Size(30, 200),
          color: colors[_Element.number],
        ),
        SizedBox(width: 7),
        Expanded(
          flex: 1,
          child: NumberWidget(
            number: int.parse(minute.substring(0, 1)),
            size: Size.infinite,
            color: colors[_Element.number],
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: NumberWidget(
            number: int.parse(minute.substring(1, 2)),
            size: Size.infinite,
            color: colors[_Element.number],
          ),
        ),
      ],
    );
  }

  /// am / pm
  Widget _getAMPMWidget(Map colors) {
    var text;
    if (_dateTime.hour >= 11) {
      text = 'PM';
    } else {
      text = 'AM';
    }
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors[_Element.number]),
    );
  }

  /// temperature widget
  Widget _getTemperatureWidget(Map colors) {
    return Text(
      widget.model.temperatureString,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colors[_Element.text],
      ),
    );
  }

  /// location widget
  Widget _getLocationWidget(Map colors) {
    return Text(
      widget.model.location,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colors[_Element.text],
      ),
    );
  }

  /// weather icon widget
  Widget _getWeatherIcon(Map colors) {
    return Icon(
      IconData(_weatherIcon[widget.model.weatherCondition],
          fontFamily: 'weather_icon', matchTextDirection: true),
      color: colors[_Element.text],
      size: 60,
    );
  }
}
