/**
 * @preserve jQuery PeriodPicker plugin v5.4.2
 * @homepage http://xdsoft.net/jqplugins/periodpicker/
 * @copyright (c) 2016 xdsoft.net Chupurnov Valeriy
 * @license OEM http://xdsoft.net/jqplugins/periodpicker/license/
 */
(function ($, window, document) {
    'use strict';
    var uniqueid = 0,
        timer,
        toggle = function (items, show) {
            if ((show || show === undefined) && items.is(':hidden')) {
                items.each(function () {
                    this.style.display = '';
                });
            } else if (!show) {
                items.hide();
            }
        };

    function TimeWrapper(str, format, date) {
        var that = date || new Date(), value;
        that.isTW = true;
        that.weekdays = function (start) {
            var weekdays = moment.weekdaysShort(), ret, i;
            ret = weekdays.splice(1);
            ret[6] = weekdays[0];
            weekdays = ret; // [m,t,w,th,f,s,sn]
            ret = weekdays.splice(start - 1);
            for (i = 0; i < start - 1; i += 1) {
                ret.push(weekdays[i]);
            }
            return ret;
        };
        that.clone = function (y, m, d, h, i, s) {
            var tmp = new TimeWrapper(false, false, new Date(that.getTime()));
            if (h) {
                tmp.setHours(h);
            }

            if (i) {
                tmp.setMinutes(i);
            }

            if (s) {
                tmp.setSeconds(s);
            }

            if (y) {
                tmp.setFullYear(y);
            }

            if (m) {
                tmp.setMonth(m);
            }

            if (d) {
                tmp.setDate(d);
            }

            return tmp;
        };
        that.inRange = function (value, range) {
            return moment(value).isBetween(range[0], range[1], 'day') || moment(value).isSame(range[0], 'day') || moment(value).isSame(range[1], 'day');
        };
        that.isValid = function () {
            if (Object.prototype.toString.call(that) !== "[object Date]") {
                return false;
            }
            return !isNaN(that.getTime());
        };
        that.parseStr = function (str, format) {
            var time;

            if (typeof str === 'string') {
                time = moment(str, format);
            } else {
                if ($.type(str) === 'date') {
                    time = new TimeWrapper(0, 0, new Date(str.getTime()));
                } else {
                    time = str;
                }
            }

            if (time && time.isValid()) {
                that = !time.isTW ? new TimeWrapper(0, 0, time.toDate()) : time;
                return that;
            }

            return null;
        };
        that.isEqualDate = function (date1, date2) {
            if (!date1 || !date1.isValid() || !date2 || !date2.isValid()) {
                return false;
            }
            return (date1.getDate() === date2.getDate() && date1.getMonth() === date2.getMonth() && date1.getMonth() === date2.getMonth());
        };
        that.format = function (format) {
            value = moment(that).format(format);
            return new RegExp('^[0-9]+$').test(value) ? parseInt(value, 10) : value;
        };
        that.countDaysInMonth = function () {
            return new Date(that.getFullYear(), that.getMonth() + 1, 0).getDate();
        };
        if (str && format) {
            that.parseStr(str, format);
        }
        return that;
    }

    function PeriodPicker(startinput, options) {
        var that = this, date, values = [];
        that.options = options;
        that.picker = $('<div unselectable="on" class="period_picker_box xdsoft_noselect" style="">' +
            '<div class="period_picker_resizer"></div>' +
            '<div class="period_picker_head">' +
                '<span class="period_picker_head_title"></span>' +
                '<span class="period_picker_max_min" title="' + this.i18n('Open fullscreen') + '"></span>' +
                '<span class="period_picker_close" title="' + this.i18n('Close') + '"></span>' +
            '</div>' +
            '<div class="period_picker_years">' +
                '<div class="period_picker_years_inner">' +
                    '<div class="period_picker_years_selector">' +
                        '<div class="period_picker_years_selector_container" style="width: 5960px; left: 0px;">' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>' +
            '<div class="period_picker_work">' +
                '<a href="" class="xdsoft_navigate xdsoft_navigate_prev"></a>' +
                '<div class="period_picker_timepicker_box"><input data-index="0" class="timepicker" type="hidden"></div>' +
                '<div class="period_picker_days">' +
                    '<table>' +
                        '<tbody>' +
                        '</tbody>' +
                    '</table>' +
                '</div>' +
                '<div class="period_picker_timepicker_box"><input  data-index="1"  class="timepicker" type="hidden"></div>' +
                '<a href="" class="xdsoft_navigate xdsoft_navigate_next"></a>' +
            '</div>' +
            '<div class="period_picker_submit_shadow"></div>' +
            '<div class="period_picker_submit_dates">' +
                '<span class="period_picker_from_time_block period_picker_time">' +
                    '<span class="input_box"><input data-index="0"  class="input_control period_picker_from_time"></span>' +
                '</span>' +
                '<span class="period_picker_from_block period_picker_date">' +
                    '<span class="input_box"><input class="input_control period_picker_from" maxlength="10"></span>' +
                '</span>' +
                '<span class="period_picker_date_separator">&#8212;</span>' +
                '<span class="period_picker_to_block period_picker_date">' +
                    '<span class="input_box"><input class="input_control period_picker_to" maxlength="10"></span>' +
                '</span>' +
                '<span class="period_picker_to_time_block period_picker_time">' +
                    '<span class="input_box"><input data-index="1" class="input_control period_picker_to_time"></span>' +
                '</span>' +
                '<button class="period_picker_show period_picker_ok" role="button" type="button">' +
                    '<span class="button_text">' + this.i18n('OK') + '</span>' +
                '</button>' +
                '<button class="period_picker_show period_picker_today" role="button" type="button">' +
                    '<span class="button_text">' + this.i18n('Today') + '</span>' +
                '</button>' +
                '<button class="period_picker_show period_picker_clear" role="button" type="button">' +
                    '<span class="button_text">' + this.i18n('Clear') + '</span>' +
                '</button>' +
            '</div>' +
            '</div>');

        that.pickerdays = that.picker.find('.period_picker_days');
        that.calendarbox = that.pickerdays.find('> table > tbody');
        that.yearsline = that.picker.find('.period_picker_years_selector_container');
        that.yearslineparent = that.picker.find('.period_picker_years_selector');
        that.timepicker = that.picker.find('.period_picker_timepicker_box');

        that.button = $('<div class="period_picker_input" type="button">' +
            '<span class="period_button_text">' +
                '<span class="period_button_content_wrapper">' +
                    '<span class="period_button_content">' +
                        '<span class="icon_calendar"></span>' +
                        '<span class="period_button_content_body">' + this.i18n(options.norange ? 'Choose date' : 'Choose period') + '</span>' +
                        '<span class="icon_clear"></span>' +
                    '</span>' +
                '</span>' +
            '</span>' +
            '</div>');

        that.startinput = options.start ? $(options.start) : $(startinput);
        that.endinput = $(options.end);

        that.startinput.attr('autocomplete', 'off');
        that.endinput.attr('autocomplete', 'off');

        that.periodtime = [[]];
        that.period = [];
        that.director = 0;

        date = new TimeWrapper();

        values[0] = that.startinput.val();
        values[1] = that.endinput.val();

        that.addRange([
            date.parseStr(values[0], !options.timepicker ? options.formatDate : options.formatDateTime) || date.parseStr(values[0], options.formatDate),
            date.parseStr(values[1], !options.timepicker ? options.formatDate : options.formatDateTime) || date.parseStr(values[1], options.formatDate)
        ]);

        that.onAfterShow = [];
        that.onAfterHide = [];
        that.onAfterRegenerate = [];

        that.uniqueid = uniqueid;
        that.currentTimepickerIndex = 0;
        that.timepickerSetLimits = false;

        that.timer1 = 0;
        that.timer2 = 0;
        that.timer3 = 0;
        uniqueid += 1;

        that.applyOptions();

        that.init();

        if (options.timepicker && $.fn.TimePicker !== undefined) {
            that.addRangeTime(
                date.parseStr(values[0], options.formatDateTime) || date.parseStr(values[0], options.formatDate),
                date.parseStr(values[1], options.formatDateTime) || date.parseStr(values[1], options.formatDate)
            );
        }

    }

    PeriodPicker.prototype.applyOptions = function () {
        var options = this.options,
            that = this,
            addHandler;

        that.picker.toggleClass('period_picker_maximize', options.fullsize);

        toggle(that.picker.find('.period_picker_resizer'), options.resizeButton);
        toggle(that.picker.find('.period_picker_head_title').html(that.i18n(options.norange ? 'Select date' : 'Select period')), options.title);
        toggle(that.picker.find('.period_picker_max_min'), options.fullsizeButton);
        toggle(that.picker.find('.period_picker_close'), options.closeButton && !options.inline);
        toggle(that.picker.find('.period_picker_years'), options.yearsLine);
        toggle(that.picker.find('.xdsoft_navigate'), options.navigate);
        toggle(that.picker.find('.period_picker_timepicker_box').eq(0), options.timepicker && $.fn.TimePicker !== undefined);
        toggle(that.picker.find('.period_picker_timepicker_box').eq(1), options.timepicker && $.fn.TimePicker !== undefined && !options.norange);

        that.picker.find('.period_picker_date,.period_picker_date_separator').css('visibility', options.showDatepickerInputs ? '' : 'hidden');

        toggle(that.picker.find('.period_picker_from_time_block'), options.timepicker && $.fn.TimePicker !== undefined);
        that.picker.find('.period_picker_from_time_block').css('visibility', options.showTimepickerInputs ? '' : 'hidden');

        toggle(that.picker.find('.period_picker_to_time_block'), options.timepicker && $.fn.TimePicker !== undefined && !that.options.norange);
        that.picker.find('.period_picker_to_time_block').css('visibility', options.showTimepickerInputs ? '' : 'hidden');

        toggle(that.picker.find('.period_picker_ok'), options.okButton && !options.inline);
        toggle(that.picker.find('.period_picker_today'), options.todayButton);
        toggle(that.picker.find('.period_picker_clear'), options.clearButton);

        toggle(that.button.find('.period_button_content .icon_clear'), options.clearButtonInButton);

        if (options.tabIndex !== false) {
            that.button.attr('tabindex', options.tabIndex);
        }

        if (options.withoutBottomPanel || (!options.todayButton && !options.clearButton && (!options.okButton || options.inline) && !options.showDatepickerInputs && (!options.showTimepickerInputs || !options.timepicker || $.fn.TimePicker === undefined))) {
            that.picker.addClass('without_bottom_panel');
            options.withoutBottomPanel = true;
            options.someYOffset = 0;
        }

        if (!options.yearsLine) {
            that.picker.addClass('without_yearsline');
        }

        if (!options.title && !options.fullsizeButton && !(options.closeButton && !options.inline)) {
            that.picker.addClass('without_header');
        }

        if (options.timepicker && $.fn.TimePicker !== undefined) {
            that.picker.addClass('with_first_timepicker');
        }

        if (options.timepicker && $.fn.TimePicker !== undefined && !options.norange) {
            that.picker.addClass('with_second_timepicker');
        }

        if (options.animation) {
            that.picker.addClass('animation');
        }

        if (options.norange) {
            that.picker.addClass('xdsoft_norange');
        }

        if (options.inline) {
            that.picker.addClass('xdsoft_inline');
        }

        addHandler = function (name) {
            var i, finded = false;
            if (options[name] !== undefined && $.isFunction(options[name])) {
                for (i = 0; i < that[name].length; i += 1) {
                    if (options[name] === that[name][i]) {
                        finded = true;
                        break;
                    }
                }
                if (!finded) {
                    that[name].push(options[name]);
                }
            }
        };

        addHandler('onAfterShow');
        addHandler('onAfterHide');
        addHandler('onAfterRegenerate');

        that.maxdate = options.maxDate ? new TimeWrapper(options.maxDate, options.formatDate) : false;
        that.mindate = options.minDate ? new TimeWrapper(options.minDate, options.formatDate) : false;
        that.monthcount = options.cells[0] * options.cells[1];

        that.picker.css({
            width: options.cells[1] * options.monthWidthInPixels + ((options.timepicker && $.fn.TimePicker) ? 87 * (!options.norange ? 2 : 1) : 0) + 50,
            height: (options.cells[0] * options.monthHeightInPixels) + options.someYOffset
        });
    };

    PeriodPicker.prototype.returnPeriod = function () {
        this.picker.find('input.period_picker_from').val(this.period !== undefined ? this.period : '');
        this.picker.find('input.period_picker_to').val(this.period[1] !== undefined ? this.period[1] : this.picker.find('input.period_picker_from').val());
    };
    PeriodPicker.prototype.moveTimeToDate = function () {
        if (this.options.timepicker && this.periodtime.length && this.periodtime[0].length) {
            if (this.period[0] !== null && this.period[0].format  && this.periodtime[0][0].format) {
                this.period[0].setSeconds(this.periodtime[0][0].getSeconds());
                this.period[0].setMinutes(this.periodtime[0][0].getMinutes());
                this.period[0].setHours(this.periodtime[0][0].getHours());
            }
            if (this.periodtime[0][1] !== null && this.period[1] !== null && this.period[1].format && this.periodtime[0][1].format) {
                this.period[1].setSeconds(this.periodtime[0][1].getSeconds());
                this.period[1].setMinutes(this.periodtime[0][1].getMinutes());
                this.period[1].setHours(this.periodtime[0][1].getHours());
            }
        }
    };

    PeriodPicker.prototype.syncTimesInputs = function () {
        if (this.options.timepicker && $.fn.TimePicker !== undefined) {
            var tw = new TimeWrapper(),
                tinputs = this.timepicker.find('input.timepicker'),
                nativeinputs = this.picker.find('.period_picker_submit_dates .period_picker_time input');

            if (this.periodtime[0][0]) {
                if ($.fn.TimePicker) {
                    tinputs.eq(0).TimePicker('setValue', this.periodtime[0][0], true);
                }
                if (!nativeinputs.eq(0).is(':focus')) {
                    nativeinputs.eq(0).val(this.periodtime[0][0].format(this.options.timepickerOptions.inputFormat));
                }
            }

            if (!this.options.norange && this.periodtime[0][1]) {
                if ($.fn.TimePicker) {
                    tinputs.eq(1).TimePicker('setValue', this.periodtime[0][1], true);
                }
                if (!nativeinputs.eq(1).is(':focus')) {
                    nativeinputs.eq(1).val(this.periodtime[0][1].format(this.options.timepickerOptions.inputFormat));
                }
            }

            if (!this.options.norange && this.options.useTimepickerLimits && tw.isEqualDate(this.period[0], this.period[1])) {
                if (this.currentTimepickerIndex === 0) {
                    tinputs.eq(1).TimePicker('setMin', tinputs.eq(0).val()).TimePicker('setMin', false);
                } else {
                    tinputs.eq(0).TimePicker('setMax', tinputs.eq(1).val()).TimePicker('setMax', false);
                }
            }
        }
        /*var tw = new TimeWrapper(), tinputs = this.timepicker.find('input.timepicker');
        if (this.options.timepicker && $.fn.TimePicker !== undefined && this.options.useTimepickerLimits) {
            tinputs.eq(0).TimePicker('setValue', this.periodtime[0][0], true);
            tinputs.eq(1).TimePicker('setValue', this.periodtime[0][1], true);
            if (tw.isEqualDate(this.period[0], this.period[1])) {
                if (!this.currentTimepickerIndex) {
                    tinputs.eq(1).TimePicker('setMin', tinputs.eq(0).val()).TimePicker('setMin', false);
                    this.periodtime[0][1] = tinputs.eq(1).TimePicker('getValue');
                } else {
                    tinputs.eq(0).TimePicker('setMax', tinputs.eq(1).val()).TimePicker('setMax', false);              
                    this.periodtime[0][0] = tinputs.eq(0).TimePicker('getValue');
                }
            }
        }*/
    };

    PeriodPicker.prototype.getInputsValue = function () {
        var result = [], format;
        this.syncTimesInputs();
        if (this.startinput.length && this.period && this.period.length) {
            this.moveTimeToDate();
            format = this.options.timepicker ? this.options.formatDateTime : this.options.formatDate;
            if (this.period[0] && this.period[0].format) {
                result.push(this.period[0].format(format));
            }
            if (this.period[1] && this.period[1].format) {
                result.push(this.period[1].format(format));
            }
        }
        return result;
    };

    PeriodPicker.prototype.setInputsValue = function () {
        var result = this.getInputsValue();
        if (result.length) {
            if (result[0] && this.startinput.val() !== result[0]) {
                this.startinput.val(result[0]);
            }
            if (result[1] && this.endinput.val() !== result[1]) {
                this.endinput.val(result[1]);
            }
        } else {
            this.startinput.val('');
            this.endinput.val('');
        }

        if (this.oldStringRange !== result.join('-')) {
            this.oldStringRange = result.join('-');
            this.startinput.trigger('change');
            this.endinput.trigger('change');
        }
    };

    PeriodPicker.prototype.getLabel = function () {
        var result = [], formats;
        if (this.period.length) {
            this.moveTimeToDate();

            formats = !this.options.timepicker ? [
                this.options.formatDecoreDateWithYear || this.options.formatDecoreDate || this.options.formatDate,
                this.options.formatDecoreDateWithoutMonth || this.options.formatDecoreDate || this.options.formatDate,
                this.options.formatDecoreDate || this.options.formatDate,
                this.options.formatDate
            ] : [
                this.options.formatDecoreDateTimeWithYear || this.options.formatDecoreDateTime || this.options.formatDateTime,
                this.options.formatDecoreDateTimeWithoutMonth || this.options.formatDecoreDateTime || this.options.formatDateTime,
                this.options.formatDecoreDateTime || this.options.formatDateTime,
                this.options.formatDateTime
            ];

            if (this.period[1] === undefined || !this.period[1] || this.period[1].format === undefined || !this.period[1].format || this.period[0].format(formats[3]) === this.period[1].format(formats[3])) {
                result.push(this.period[0].format(formats[0]));
            } else {
                result.push(this.period[0].format(this.period[0].format('YYYY') !== this.period[1].format('YYYY') ? formats[0] : (this.period[0].format('M') !== this.period[1].format('M') ? formats[2] : formats[1])));
                result.push(this.period[1].format(formats[0]));
            }
        }
        return result;
    };
    PeriodPicker.prototype.setLabel = function () {
        var result = this.getLabel();
        if (result.length) {
            if (result.length === 1) {
                this.button.find('.period_button_content_body').html(result[0]);
            } else {
                this.button.find('.period_button_content_body').html('<span>' +
                    result[0] +
                    '</span>' +
                    '<span class="period_button_dash">&#8212;</span>' +
                    '<span>' + result[1] + '</span>');
            }
            if (this.options.clearButtonInButton) {
                toggle(this.button.find('.period_button_content .icon_clear'), true);
            }
        } else {
            this.button.find('.period_button_content_body').html(this.i18n(this.options.norange ? 'Choose date' : 'Choose period'));
            toggle(this.button.find('.period_button_content .icon_clear'), false);
        }
    };

    PeriodPicker.prototype.highlightPeriod = function () {
        var that = this,
            date = new TimeWrapper();

        moment.locale(that.options.lang);

        if (!that.picker.is(':hidden')) {
            that.picker.find('.period_picker_cell.period_picker_selected').removeClass('period_picker_selected');
            if (that.period.length) {
                that.picker.find('.period_picker_cell').each(function () {
                    var current = date.parseStr($(this).data('date'), that.options.formatDate);
                    if (date.inRange(current, that.period)) {
                        $(this).addClass('period_picker_selected');
                    }
                });
                that.picker.find('.period_picker_years_period').css({
                    width: Math.floor((that.options.yearSizeInPixels / 365) * Math.abs(moment(that.period[1]).diff(that.period[0], 'day'))) + 'px',
                    left: Math.floor((that.options.yearSizeInPixels / 365) * -(moment([that.options.yearsPeriod[0], 1, 1]).diff(that.period[0], 'day')))
                });
                that.picker.find('input.period_picker_from:not(:focus)').val((that.period[0] !== undefined && that.period[0]) ? that.period[0].format(that.options.formatDate) : '');
                that.picker.find('input.period_picker_to:not(:focus)').val((that.period[1] !== undefined && that.period[1]) ? that.period[1].format(that.options.formatDate) : that.picker.find('input.period_picker_from').val());

                that.picker.find('input.period_picker_from:not(:focus),input.period_picker_to:not(:focus)').trigger('change');
            } else {
                that.picker.find('input.period_picker_from:not(:focus),input.period_picker_to:not(:focus)').val('');
            }
        }

        that.setLabel();
        that.setInputsValue();
    };
    PeriodPicker.prototype.addRangeTime = function (value1, value2) {
        var date = new TimeWrapper();

        this.periodtime[0][0] = date.parseStr(value1, this.options.timepickerOptions.inputFormat);
        if (!this.options.norange) {
            this.periodtime[0][1] = date.parseStr(value2, this.options.timepickerOptions.inputFormat);
            if (this.periodtime[0][0] === null && this.periodtime[0][1]) {
                this.periodtime[0][0] = this.periodtime[0][1];
            }
        } else {
            this.periodtime[0][1] = this.periodtime[0][0];
        }

        if (this.periodtime[0][0] === null) {
            this.periodtime[0] = [];
        }
        this.setLabel();
        this.setInputsValue();
    };
    PeriodPicker.prototype.addRange = function (value) {
        this.oldStringRange = this.getInputsValue().join('-');

        this.currentTimepickerIndex = 0;
        var date = new TimeWrapper(), buff;
        if (this.options.norange) {
            this.director = 0;
        }
        if ($.isArray(value)) {
            this.period = [date.parseStr(value[0], this.options.formatDate), date.parseStr(value[1], this.options.formatDate)];
            if (this.period[0] === null) {
                this.period = [];
            }
            this.director = 0;
        } else {
            if (this.period === undefined) {
                this.period = [];
            }
            this.period[this.options.norange ? 0 : this.director] = date.parseStr(value, this.options.formatDate);
            if (this.period[this.director] === null) {
                this.period = [];
                this.highlightPeriod();
                return;
            }
            if (!this.director) {
                this.period[1] = this.period[this.director].clone();
            }
            if (this.period[0] > this.period[1]) {
                buff = this.period[0];
                this.period[0] = this.period[1];
                this.period[1] = buff;
            }
            this.director = this.director ? 0 : 1;
        }
        if (this.options.norange && this.period[0] && this.period[1] && this.period[1] !== this.period[0]) {
            this.period[1] = this.period[0].clone();
        }
        this.highlightPeriod();
        if (this.options.hideAfterSelect && this.period[0] && this.period[1] && this.period[0] !== this.period[1]) {
            this.hide();
        }

        this.month = this.period.length ? this.period[0].getMonth() + 1 : this.options.startMonth;
        this.year = this.period.length ? this.period[0].getFullYear() : this.options.startYear;
    };

    PeriodPicker.prototype.recalcDraggerPosition = function () {
        var that = this;
        clearTimeout(this.timer2);
        this.timer2 = setTimeout(function () {
            var parentLeft = Math.abs(parseInt(that.yearsline.css('left'), 10)),
                perioddragger = that.picker.find('.period_picker_years_dragger'),
                left = parseInt(perioddragger.css('left'), 10);
            if (left < parentLeft) {
                that.yearsline.css('left', -left + 'px');
            } else if (left + perioddragger.width()  > parentLeft + that.yearslineparent.width()) {
                that.yearsline.css('left', -(left + perioddragger.width() - that.yearslineparent.width()) + 'px');
            }
        }, 100);
    };

    PeriodPicker.prototype.calcDate = function (date, year, month, day) {
        date.setFullYear(year);
        date.setMonth(month); // set month after year, because month can be more then 12 when work mousewheel 
        date.setDate(day);
    };

    PeriodPicker.prototype.getRealDateTime = function () {
        var date = new Date();
        this.calcDate(date, this.year, this.month - 1, 1);
        return [date.getMonth(), date.getFullYear()];
    };
    PeriodPicker.prototype.regenerate = function (cells) {
        if (!this.picker.is(':visible')) {
            return;
        }

        var that = this,
            width = parseInt(that.pickerdays.width(), 10),
            height = parseInt(that.picker[0].offsetHeight, 10),
            i;

        moment.locale(that.options.lang);

        if (cells === undefined) {
            this.options.cells = [Math.floor((height - that.options.someYOffset) / that.options.monthHeightInPixels) || 1, Math.floor(width / that.options.monthWidthInPixels) || 1];
        } else {
            this.options.cells = cells;
            that.picker.css({
                width: this.options.cells[1] * that.options.monthWidthInPixels + ((that.options.timepicker && $.fn.TimePicker) ? 87 * (!that.options.norange ? 2 : 1) : 0) + 50,
                height: (this.options.cells[0] * that.options.monthHeightInPixels) + that.options.someYOffset
            });
        }
        if (this.options.cells[0] < 0) {
            this.options.cells[0] = 1;
        }
        that.monthcount = this.options.cells[0] * this.options.cells[1];
        that.generateCalendars(that.month, that.year);
        that.generateYearsLine();
        that.recalcDraggerPosition();
        that.highlightPeriod();
        for (i = 0; i < this.onAfterRegenerate.length; i += 1) {
            this.onAfterRegenerate[i].call(this);
        }
    };
    PeriodPicker.prototype.init = function () {
        var that = this, offset, start, diff, drag, perioddrag, perioddragger, left, headdrag, period_picker_years_selector, period_picker_years_selector_container, period_picker_time_inputs, timepickerCallback;
        that.button.on('click keydown', function (e) {
            if (e.type === 'keydown') {
                switch (e.which) {
                case 9:
                    if (!that.options.inline) {
                        that.hide();
                    }
                    return;
                case 38:
                case 13:
                    break;
                default:
                    return;
                }
            }
            if (that.button.is('[disabled]')) {
                e.preventDefault();
                return false;
            }
            that.toggle();
        });

        if (!that.options.inline) {
            that.startinput.after(that.button);
        }

        offset = that.startinput.offset();
        that.picker.find('.period_picker_submit_dates input')
            .on('focus', function () {
                $(this).parent().parent().addClass('input_focused_yes');
            })
            .on('blur', function () {
                $(this).parent().parent().removeClass('input_focused_yes');
            });

        // enter date in center fields
        that.picker.find('.period_picker_submit_dates .period_picker_date input')
            .on('keydown', function () {
                var input = this;
                clearTimeout(that.timer3);
                that.timer3 = setTimeout(function () {
                    if ($(input).val()) {
                        var time = moment($(input).val(), that.options.formatDate);
                        if (!time.isValid()) {
                            $(input).parent().parent().addClass('period_picker_error');
                            return;
                        }
                        that.addRange([that.picker.find('.period_picker_submit_dates .period_picker_date input').eq(0).val(), that.picker.find('.period_picker_submit_dates .period_picker_date input').eq(1).val()]);
                    }
                    $(input).parent().parent().removeClass('period_picker_error');
                }, 200);
            });

        if (that.options.timepicker && $.fn.TimePicker) {
            // enter time in center inputs
            timepickerCallback = function () {
                var input = this, time, tw = new TimeWrapper();
                that.currentTimepickerIndex = parseInt($(this).data('index'), 10);

                if ($(input).val()) {
                    time = moment($(input).val(), that.options.timepickerOptions.inputFormat);
                    if (!time.isValid()) {
                        $(input).parent().parent().addClass('period_picker_error');
                        return;
                    }
                    if (this.period && this.period.length && tw.isEqualDate(this.period[0], this.period[1]) && moment(period_picker_time_inputs.eq(0).val(), that.options.timepickerOptions.inputFormat).getDate().getTime() > moment(period_picker_time_inputs.eq(1).val(), that.options.timepickerOptions.inputFormat).getDate().getTime()) {
                        $(input).parent().parent().addClass('period_picker_error');
                        return;
                    }
                    that.addRangeTime(that.picker.find('.period_picker_submit_dates .period_picker_time input').eq(0).val(), that.picker.find('.period_picker_submit_dates .period_picker_time input').eq(1).val());
                }

                $(input).parent().parent().removeClass('period_picker_error');
            };
            period_picker_time_inputs = that.picker.find('.period_picker_submit_dates .period_picker_time input')
                .on('keydown change', function (e) {
                    if (e.type === 'keydown') {
                        clearTimeout(that.timer3);
                        that.timer3 = setTimeout(timepickerCallback.bind(this), 300);
                    } else {
                        timepickerCallback.call(this);
                    }
                });
        }
        that.picker.find('.period_picker_max_min').on('click', function () {
            that.picker.toggleClass('period_picker_maximize');
            that.regenerate();
        });
        if (that.options.fullsizeOnDblClick) {
            that.picker.find('.period_picker_head').on('dblclick', function () {
                that.picker.toggleClass('period_picker_maximize');
                that.regenerate();
            });
        }
        that.picker.find('.period_picker_close').on('click', function () {
            that.hide();
        });
        if (that.options.mousewheel) {
            that.picker.on('mousewheel', function (e) {
                that.month += (that.options.reverseMouseWheel ? -1 : 1) * e.deltaY;
                that.regenerate();
                return false;
            });
            if (that.options.mousewheelYearsLine) {
                that.picker.find('.period_picker_years_selector').on('mousewheel', function (e) {
                    that.year += (that.options.reverseMouseWheel ? -1 : 1) * e.deltaY;
                    that.month = 1;
                    that.regenerate();
                    e.preventDefault();
                    e.stopPropagation();
                    return false;
                });
            }
        }
        if (that.options.navigate) {
            that.picker.find('.xdsoft_navigate').on('click', function () {
                that.month += $(this).hasClass('xdsoft_navigate_prev') ? -1 : 1;
                that.regenerate();
                return false;
            });
        }

        that.picker.on('click', '.period_picker_show.period_picker_today', function () {
            if (that.options.onTodayButtonClick && $.isFunction(that.options.onTodayButtonClick)) {
                if (that.options.onTodayButtonClick.call(that) === false) {
                    return;
                }
            }
            var now = new Date();
            that.year = now.getFullYear();
            that.month = now.getMonth() + 1;
            that.regenerate();
        });

        that.picker.on('click', '.period_picker_show.period_picker_ok', function () {
            if (that.options.onOkButtonClick && $.isFunction(that.options.onOkButtonClick)) {
                if (that.options.onOkButtonClick.call(that) === false) {
                    return;
                }
            }
            that.hide();
        });

        if (that.options.clearButtonInButton) {
            that.button.find('.icon_clear').on('mousedown', function (e) {
                that.clear();
                e.preventDefault();
                e.stopPropagation();
                return false;
            });
        }

        if (that.options.clearButton) {
            that.picker.on('click', '.period_picker_show.period_picker_clear', function () {
                that.clear();
            });
        }

        that.picker.on('click', '.period_picker_years_selector .period_picker_year', function () {
            that.year = parseInt($(this).text(), 10);
            that.month = -Math.floor(that.monthcount / 2) + 1;
            that.regenerate();
        });
        that.picker.on('mousedown', '.period_picker_days td td,.period_picker_month', function () {
            if ($(this).hasClass('period_picker_month')) {
                that.addRange([$(this).data('datestart'), $(this).data('dateend')]);
            } else {
                if (!$(this).hasClass('period_picker_gray_period') && !$(this).hasClass('period_picker_empty')) {
                    if ($(this).hasClass('period_picker_selector_week')) {
                        var week = parseInt($(this).parent().data('week'), 10),
                            days = that.picker.find('tr[data-week=' + week + '] > td.period_picker_cell:not(.period_picker_gray_period)'),
                            last = days.eq(-1),
                            first = days.eq(0);
                        if (last.length) {
                            that.addRange([first.data('date'), last.data('date')]);
                        }
                    } else {
                        if (that.picker.find('.period_picker_selected').length !== 1) {
                            that.picker.find('.period_picker_selected').removeClass('period_picker_selected');
                            $(this).addClass('period_picker_selected');
                        } else {
                            $(this).addClass('period_picker_selected');
                        }
                        that.addRange($(this).data('date'));
                    }
                }
            }
        });

        that.picker.on('mousedown', '.period_picker_years_selector_container', function (e) {
            period_picker_years_selector = $(this);
            period_picker_years_selector_container = true;
            start = [e.clientX, e.clientY, parseInt(period_picker_years_selector.css('left') || 0, 10)];
            e.preventDefault();
        });

        that.picker.on('mousedown', '.period_picker_years_dragger', function (e) {
            perioddragger = $(this);
            perioddrag = true;
            start = [e.clientX, e.clientY, parseInt(perioddragger.css('left'), 10)];
            e.stopPropagation();
            e.preventDefault();
        });

        if (that.options.draggable) {
            that.picker.on('mousedown', '.period_picker_head', function (e) {
                headdrag = true;
                start = [e.clientX, e.clientY, parseInt(that.picker.css('left'), 10), parseInt(that.picker.css('top'), 10)];
                e.preventDefault();
            });
        }

        that.picker.on('mouseup', function (e) {
            drag = false;
            perioddrag = false;
            headdrag = false;
            period_picker_years_selector_container = false;
            if (that.options.timepicker && $.fn.TimePicker) {
                that.timepicker.find('input.timepicker').TimePicker('stopDrag');
            }
            e.stopPropagation();
        });
        that.picker.find('.period_picker_resizer').on('mousedown', function (e) {
            drag = true;
            start = [e.clientX, e.clientY, parseInt(that.picker.css('width'), 10), parseInt(that.picker.css('height'), 10)];
            e.preventDefault();
        });

        that.picker.css({
            left: !that.options.inline ? offset.left : 'auto',
            top: !that.options.inline ? offset.top + that.button.height() : 'auto',
            width: this.options.cells[1] * that.options.monthWidthInPixels + ((that.options.timepicker && $.fn.TimePicker) ? 87 * (!that.options.norange ? 2 : 1) : 0) + 50,
            height: (this.options.cells[0] * that.options.monthHeightInPixels) + that.options.someYOffset
        });

        if (!that.options.noHideSourceInputs && !that.options.likeXDSoftDateTimePicker) {
            that.startinput.hide();
            that.endinput.hide();
        } else {
            that
                .startinput
                .add(that.endinput)
                .on('keydown.xdsoftpp mousedown.xdsoftpp', function () {
                    clearTimeout(timer);
                    timer = setTimeout(function () {
                        var value = that.getInputsValue(),
                            date,
                            format = that.options.timepicker ? that.options.formatDateTime : that.options.formatDate;
                        if ((value[0] !== undefined && value[0] !== that.startinput.val()) || (value[1] !== undefined && that.endinput.length && value[1] !== that.endinput.val())) {
                            date = new TimeWrapper();
                            that.addRange([date.parseStr(that.startinput.val(), format), date.parseStr(that.endinput.val(), format)]);
                            if (that.period[0]) {
                                that.year = that.period[0].getFullYear();
                                that.month = that.period[0].getMonth() + 1;
                                that.regenerate();
                            }
                        }
                    }, 300);
                });

            if (that.options.likeXDSoftDateTimePicker) {
                that.button.remove();
                that
                    .startinput
                    .add(that.endinput)
                    .on('open.xdsoftpp focusin.xdsoftpp mousedown.xdsoftpp touchstart.xdsoftpp', function () {
                        var input = this;
                        if ($(input).is(':disabled') || that.picker.hasClass('visible')) {
                            return;
                        }
                        clearTimeout(timer);
                        timer = setTimeout(function () {
                            that.show(input);
                        }, 100);
                    });
                if (that.options.hideOnBlur) {
                    that.startinput
                        .add(that.endinput)
                        .on('blur.xdsoftpp', function () {
                            setTimeout(function () {
                                if (!that.picker.find('*:focus').length) {
                                    that.hide();
                                }
                            }, 200);
                        });
                }
            }
        }

        if (!that.options.inline) {
            $(document.body).append(that.picker);
        } else {
            that.startinput.after(that.picker);
            that.show();
        }

        $(window)
            .on('resize.xdsoftpp' + that.uniqueid, function () {
                that.regenerate();
            })
            .on('keydown.xdsoftpp' + that.uniqueid, function (e) {
                if (that.picker.hasClass('visible')) {
                    switch (e.which) {
                    case 40:
                    case 27:
                        if (!that.options.inline) {
                            that.hide();
                        }
                        break;
                    case 37:
                    case 39:
                        that.picker.find('.xdsoft_navigate').eq(e.which === 37 ? 0 : 1).trigger('click');
                        break;
                    }
                }
            })
            .on('mouseup.xdsoftpp' + that.uniqueid, function (e) {
                if (drag || perioddrag || headdrag || period_picker_years_selector_container) {
                    drag = false;
                    perioddrag = false;
                    headdrag = false;
                    period_picker_years_selector_container = false;
                } else {
                    if (!that.options.inline) {
                        that.hide();
                        if (that.options.likeXDSoftDateTimePicker && (that.startinput.is(e.target) || that.endinput.is(e.target))) {
                            that.show(e.target);
                        }
                    }
                }
            })
            .on('mousemove.xdsoftpp' + that.uniqueid, function (e) {
                if (headdrag && !that.options.inline) {
                    diff = [e.clientX - start[0], e.clientY - start[1]];
                    if (!that.picker.hasClass('xdsoft_i_moved')) {
                        that.picker.addClass('xdsoft_i_moved');
                    }
                    that.picker.css({
                        left: start[2] + diff[0],
                        top: start[3] + diff[1]
                    });
                }
                if (drag) {
                    diff = [e.clientX - start[0], e.clientY - start[1]];
                    that.picker.css({
                        width: start[2] + diff[0],
                        height: start[3] + diff[1]
                    });
                    that.regenerate();
                }
                if (perioddrag) {
                    diff = [e.clientX - start[0], e.clientY - start[1]];
                    left = start[2] + diff[0];
                    perioddragger.css('left', left);
                    that.calcMonthOffsetFromPeriodDragger(left);
                    that.generateCalendars(that.month, that.year);
                    that.recalcDraggerPosition();
                }
                if (period_picker_years_selector_container) {
                    diff = [e.clientX - start[0], e.clientY - start[1]];
                    left = start[2] + diff[0];
                    period_picker_years_selector.css('left', left);
                }
            });
        that.generateTimePicker();
    };
    PeriodPicker.prototype.generateTimePicker = function () {
        var that = this;
        if (that.options.timepicker && $.fn.TimePicker !== undefined) {
            that.timepicker.each(function () {
                var $this = $(this).find('input.timepicker'), index = parseInt($this.data('index') || 0, 10);
                if ($this.length && !$this.data('timepicker') && $.fn.TimePicker !== undefined) {
                    // init timepicker
                    if (index && that.options.defaultEndTime) {
                        that.options.timepickerOptions.defaultTime = that.options.defaultEndTime;
                    }
                    $this.TimePicker(that.options.timepickerOptions, $(this));
                    that.onAfterRegenerate.push(function () {
                        $this.TimePicker('regenerate');
                    });
                    $this
                        .on('change', function () {
                            var input = that.picker.find('.period_picker_submit_dates .period_picker_time input').eq(index);
                            if (!input.is(':focus') && input.val() !== this.value) {
                                input.val(this.value)
                                    .trigger('change');
                            }
                        })
                        .trigger('change');
                }
            });
        }
    };
    PeriodPicker.prototype.generateCalendars = function (month, year) {
        moment.locale(this.options.lang);
        var that = this, i, out = [], date = that.getRealDateTime(), weekdays = (new TimeWrapper()).weekdays(that.options.dayOfWeekStart);
        if (date[1] > that.options.yearsPeriod[1]) {
            that.year = that.options.yearsPeriod[1];
            year = that.year;
            that.month = 12 - that.monthcount;
            month = that.month;
        }
        if (date[1] < that.options.yearsPeriod[0]) {
            that.year = that.options.yearsPeriod[0];
            year = that.year;
            that.month = 1;
            month = that.month;
        }
        out.push('<tr class="period_picker_first_letters_tr">');
        function generateWeek() {
            var k, out2 = [];
            for (k = 0; k < weekdays.length; k += 1) {
                out2.push('<th class="' + (that.options.weekEnds.indexOf(k + that.options.dayOfWeekStart > 7 ? (k + that.options.dayOfWeekStart) % 7 : k + that.options.dayOfWeekStart) !== -1 ? 'period_picker_holiday' : '') + '">' + weekdays[k] + '</th>');
            }
            return out2.join('');
        }
        for (i = 0; i < that.options.cells[1]; i += 1) {
            out.push('<td class="period_picker_first_letters_td">' +
                '<table class="period_picker_first_letters_table">' +
                    '<tbody>' +
                        '<tr>' +
                            '<th class="period_picker_selector_week_cap">' +
                                '<span class="period_picker_selector_week_cap"></span>' +
                            '</th>' +
                            generateWeek() +
                        '</tr>' +
                    '</tbody>' +
                '</table>' +
                '</td>');
        }
        out.push('</tr>');
        for (i = 0; i < that.options.cells[0]; i += 1) {
            out.push('<tr>');
            out.push(that.generateCalendarLine(month + i * that.options.cells[1], year, that.options.cells[1]));
            out.push('</tr>');
        }
        that.calendarbox.html(out.join(''));
        that.highlightPeriod();
    };
    PeriodPicker.prototype.i18n = function (key) {
        return (this.options.i18n[this.options.lang] !== undefined &&
                    this.options.i18n[this.options.lang][key] !== undefined) ? this.options.i18n[this.options.lang][key] : key;
    };
    PeriodPicker.prototype.calcPixelOffsetForPeriodDragger = function () {
        var date = this.getRealDateTime();
        return (date[1] - this.options.yearsPeriod[0]) * this.options.yearSizeInPixels + date[0] * Math.floor(this.options.yearSizeInPixels / 12);
    };
    PeriodPicker.prototype.calcMonthOffsetFromPeriodDragger = function (left) {
        this.year = Math.floor(left / this.options.yearSizeInPixels) + this.options.yearsPeriod[0];
        this.month = Math.floor((left % this.options.yearSizeInPixels) / Math.floor(this.options.yearSizeInPixels / 12)) + 1;
    };
    PeriodPicker.prototype.generateYearsLine = function () {
        if (!this.options.yearsLine) {
            return;
        }
        var y, out = [], i = 0;
        out.push('<div class="period_picker_years_dragger" title="' + this.i18n('Move to select the desired period') + '" style="left: ' + this.calcPixelOffsetForPeriodDragger() + 'px; width: ' + (Math.floor(this.options.yearSizeInPixels / 12) * this.monthcount) + 'px;"></div>');
        out.push('<div class="period_picker_years_period" style="display: block; width: 0px; left: 300px;"></div>');
        if (this.options.yearsPeriod && $.isArray(this.options.yearsPeriod)) {
            for (y = this.options.yearsPeriod[0]; y <= this.options.yearsPeriod[1]; y += 1) {
                out.push('<div class="period_picker_year" style="left:' + (i * this.options.yearSizeInPixels) + 'px">' + y + '</div>');
                i += 1;
            }
        }
        this.yearsline.css('width', (i * this.options.yearSizeInPixels) + 'px');
        this.yearsline.html(out.join(''));
    };
    PeriodPicker.prototype.generateCalendarLine = function (month, year, count) {
        var i, j, k, out = [], date = new TimeWrapper(), countDaysInMonth, currentMonth, ticker, now = (new TimeWrapper()).format('DD.MM.YYYY');

        date.setDate(1);
        date.setFullYear(year); // change because not changed year
        date.setMonth(month - 1);

        for (i = 0; i < count; i = i + 1) {
            currentMonth = date.getMonth() + 1;
            countDaysInMonth = date.countDaysInMonth();

            out.push('<td class="period_picker_month' + date.format('M') + '">' + '<table>' + '<tbody>');
            out.push(
                '<tr>' +
                    '<th class="period_picker_month" data-datestart="' + date.format(this.options.formatDate) + '"  data-dateend="' + date.clone(0, 0, countDaysInMonth).format(this.options.formatDate) + '" colspan="8" title="' + date.format(this.options.formatMonth) + '">' + date.format(this.options.formatMonth) + '<b>' + date.format('M.YYYY') + '</b></th>' +
                    '</tr>'
            );

            ticker = 0;
            while (date.format('E') !== this.options.dayOfWeekStart && ticker < 7) {
                date.setDate(date.getDate() - 1);
                ticker += 1;
            }

            j = 1;
            ticker = 0;

            while (j <= countDaysInMonth && ticker < 100) {
                out.push('<tr data-week="' + date.format('W') + '">');
                out.push(
                    '<td class="period_picker_selector_week" title="' + this.i18n('Select week #') + ' ' + date.format('W') + '">' +
                        '<span class="period_picker_selector_week"></span>' +
                        '</td>'
                );

                for (k = 1; k <= 7; k += 1) {
                    if (date.format('M') !== currentMonth) {
                        out.push('<td class="period_picker_empty">&nbsp;</td>');
                    } else {
                        if ((!this.maxdate || date < this.maxdate) && (!this.mindate || date > this.mindate) && this.options.disableDays.indexOf(date.format(this.options.formatDate)) === -1) {
                            out.push('<td data-date="' + date.format(this.options.formatDate) + '"');
                            out.push('    class="period_picker_cell ');
                            out.push((this.options.weekEnds.indexOf(date.format('E')) !== -1 || this.options.holidays.indexOf(date.format(this.options.formatDate)) !== -1) ? ' period_picker_holiday' : ' period_picker_weekday');
                            if (date.format('DD.MM.YYYY') === now) {
                                out.push(' period_picker_cell_today ');
                            }
                            out.push(((k === 7 || date.format('D') === countDaysInMonth) ? ' period_picker_last_cell' : '') + '">' + date.format('D') + '</td>');
                        } else {
                            out.push('<td class="period_picker_gray_period">' + date.format('D') + '</td>');
                        }
                        j += 1;
                    }
                    date.setDate(date.getDate() + 1);
                }

                ticker += 1;
                out.push('</tr>');
            }

            month += 1;

            date.setDate(1);
            date.setFullYear(year);
            date.setMonth(month - 1); // for the same reason

            out.push('</tbody>' + '</table>' + '</td>');
        }
        return out.join('');
    };

    PeriodPicker.prototype.toggle = function () {
        if (this.picker.hasClass('active')) {
            this.hide();
        } else {
            this.show();
        }
    };
    PeriodPicker.prototype.clear = function () {
        this.addRange();
        if (this.options.onClearButtonClick && $.isFunction(this.options.onClearButtonClick)) {
            this.options.onClearButtonClick.call(this);
        }
        if (this.options.closeAfterClear && !this.options.inline) {
            this.hide();
        }
    };
    PeriodPicker.prototype.getPosition = function (target) {
        var offset = !this.options.likeXDSoftDateTimePicker ? this.button.offset() : $(target).offset(),
            top = offset.top + (!this.options.likeXDSoftDateTimePicker ? this.button.outerHeight() : $(target).outerHeight()) - 1,
            left = offset.left;

        if (top + this.picker.outerHeight() > $(window).height() + $(window).scrollTop()) {
            top = offset.top - this.picker.outerHeight() - 1;
        }

        if (top < 0) {
            top = 0;
        }
        if (left + this.picker.outerWidth() > $(window).width()) {
            left = $(window).width() - this.picker.outerWidth();
        }

        return {
            left: left,
            top: top
        };
    };

    PeriodPicker.prototype.show = function (target) {
        var i, self = this;
        if (!self.options.inline) {
            self.picker
                .addClass('visible');

            setTimeout(function () {
                self.picker.addClass('active');
            }, 100);

            if (self.options.fullsize) {
                self.picker.addClass('period_picker_maximize');
            } else if (!self.picker.hasClass('xdsoft_i_moved')) {
                self.picker.css(self.getPosition(target));
            }
        }
        this.regenerate();
        for (i = 0; i < this.onAfterShow.length; i += 1) {
            this.onAfterShow[i].call(this);
        }
    };
    PeriodPicker.prototype.hide = function () {
        var that = this, i;
        if (that.picker.hasClass('visible')) {
            that.picker.removeClass('active');
            if (that.picker.hasClass('animation')) {
                setTimeout(function () {
                    if (!that.picker.hasClass('active')) {
                        that.picker.removeClass('visible');
                    }
                }, 300);
            } else {
                that.picker.removeClass('visible');
            }
            if (this.onAfterHide !== undefined && this.onAfterHide.length) {
                for (i = 0; i < this.onAfterHide.length; i += 1) {
                    this.onAfterHide[i].call(this);
                }
            }
        }
    };

    PeriodPicker.prototype.destroy = function () {
        this.picker.remove();
        this.button.remove();
        this.startinput.off('.xdsoftpp').show().removeData('periodpicker');
        this.endinput.off('.xdsoftpp').show();
        $(window).off('.xdsoftpp' + this.uniqueid);
    };

    $.fn.periodpicker = function (opt, opt2, opt3) {
        if (window.moment === undefined) {
            throw new Error('PeriodPicker\'s JavaScript requires MomentJS');
        }
        var returnValue = this;
        this.each(function () {
            var options,
                times = [],
                date,
                $this = $(this),
                periodpicker = $this.data('periodpicker');
            if (!periodpicker) {
                options = $.extend(true, {}, $.fn.periodpicker.defaultOptions, opt);
                periodpicker = new PeriodPicker(this, options);
                $this.data('periodpicker', periodpicker);
            } else {
                options = periodpicker.options;
                switch (opt) {
                case 'picker':
                    returnValue = periodpicker;
                    break;
                case 'regenerate':
                    periodpicker.regenerate(opt2);
                    break;
                case 'setOption':
                    periodpicker.options[opt2] = opt3;
                    periodpicker.applyOptions();
                    break;
                case 'setOptions':
                    periodpicker.options = $.extend(true, {}, periodpicker.options, opt2);
                    periodpicker.applyOptions();
                    break;
                case 'clear':
                    periodpicker.addRange();
                    break;
                case 'change':
                    date = new TimeWrapper();
                    times[0] = date.parseStr(periodpicker.startinput.val(), !options.timepicker ? options.formatDate : options.formatDateTime) || date.parseStr(periodpicker.startinput.val(), options.formatDate);
                    if (periodpicker.endinput.length) {
                        times[1] = date.parseStr(periodpicker.endinput.val(), !options.timepicker ? options.formatDate : options.formatDateTime) || date.parseStr(periodpicker.endinput.val(), options.formatDate);
                    }
                    periodpicker.addRange(times);
                    break;
                case 'destroy':
                    periodpicker.destroy();
                    break;
                case 'hide':
                    periodpicker.hide();
                    break;
                case 'show':
                    periodpicker.show();
                    break;
                case 'value':
                    if (opt2 !== undefined) {
                        date = new TimeWrapper();
                        if ($.isArray(opt2)) {
                            times[0] = date.parseStr(opt2[0], !options.timepicker ? options.formatDate : options.formatDateTime) || date.parseStr(opt2[0], options.formatDate);
                            if (opt2[1] !== undefined) {
                                times[1] = date.parseStr(opt2[1], !options.timepicker ? options.formatDate : options.formatDateTime) || date.parseStr(opt2[1], options.formatDate);
                            }
                        } else {
                            times[0] = date.parseStr(opt2, !options.timepicker ? options.formatDate : options.formatDateTime) || date.parseStr(opt2, options.formatDate);
                        }
                        periodpicker.addRange(times);
                        if (options.timepicker && $.fn.TimePicker !== undefined) {
                            periodpicker.addRangeTime(times[0], times[1] || times[0]);
                        }
                    } else {
                        returnValue = periodpicker.period;
                    }
                    break;
                case 'valueStringStrong':
                    returnValue =  periodpicker.getInputsValue().join('-');
                    break;
                case 'valueString':
                    returnValue =  periodpicker.getLabel().join('-');
                    break;
                case 'disable':
                    periodpicker.button.attr('disabled', true);
                    periodpicker.startinput
                        .add(periodpicker.endinput)
                        .attr('disabled', true)
                        .attr('readonly', true);
                    break;
                case 'enable':
                    periodpicker.button.removeAttr('disabled');
                    periodpicker.startinput
                        .add(periodpicker.endinput)
                        .removeAttr('disabled')
                        .removeAttr('readonly');
                    break;
                }
            }
        });
        return returnValue;
    };
    $.fn.periodpicker.defaultOptions = {
        /**
         * @property {boolean|int} tabIndex=0 Tabindex
         */
        tabIndex: 0,

        /**
         * @property {boolean} animation=true Enable animation when periodpicker is shown
         */
        animation: true,
        lang: 'en',
        i18n: {
            'en' : {
                'Select week #' : 'Select week #',
                'Select period' : 'Select period',
                'Select date' : 'Select date',
                'Choose period' : 'Select period',
                'Choose date' : 'Select date',
                'Clear' : 'Clear'
            },
            'ru' : {
                'Move to select the desired period' : 'Переместите, чтобы выбрать нужный период',
                'Select week #' : 'Выбрать неделю №',
                'Select period' : 'Выбрать период',
                'Select date' : 'Выбрать дату',
                'Open fullscreen' : 'Открыть на весь экран',
                'Close' : 'Закрыть',
                'OK' : 'OK',
                'Choose period' : 'Выбрать период',
                'Choose date' : 'Выбрать дату',
                'Clear' : 'Отчистить'
            },
            'fr' : {
                'Move to select the desired period' : 'Déplacer pour sélectionner la période désirée',
                'Select week #' : 'Sélectionner la semaine #',
                'Select period' : 'Choisissez une date',
                'Select date' : 'Sélectionner la date',
                'Open fullscreen' : 'Ouvrir en plein écran',
                'Close' : 'Fermer',
                'OK' : 'OK',
                'Choose period' : 'Choisir la période',
                'Choose date' : 'Choisir une date',
                'Clear' : 'Propre'
            }
        },
        /**
         * @property {boolean} withoutBottomPanel=false Do not show the bottom panel with buttons and input elements
         */
        withoutBottomPanel: false,
        /**
         * @property {boolean} showTimepickerInputs=true Show inputs for enterind times
         */
        showTimepickerInputs: true,
        /**
         * @property {boolean} showDatepickerInputs=true Show inputs for enterind dates
         */
        showDatepickerInputs: true,
        timepicker: false,

        /**
         *  @property {boolean} useTimepickerLimits=true Don't allow set time2 less than time1 and time1 more than time2 in timepickers when was selected range  
         */
        useTimepickerLimits: true,

        timepickerOptions: {
            inputFormat: 'HH:mm'
        },

        /**
         *  @property {boolean} defaultEndTime=false If you need different defaultTime for start and for end use this option for END, and timepickerOptions.defaultTime for START 
         */
        defaultEndTime: false,

        /**
         * @property {boolean} yearsLine=true Show years selector
         */
        yearsLine: true,
        title: true,

        /**
         * @property {boolean} inline=false Show picker on the spot of the original element. Button is not shown
         */
        inline: false,

        /**
         * @property {boolean} clearButtonInButton=false Show clear value button in main button
         */
        clearButtonInButton: false,

        /**
         * @property {boolean} clearButton=false Show clear value button in periodpicker
         */
        clearButton: false,

        /**
         * @property {boolean} closeAfterClear=false Hide periodpicker after clear operation
         */
        closeAfterClear: true,

        okButton: true,

        /**
         * @property {boolean} todayButton=false Go to today
         */
        todayButton: false,

        closeButton: true,
        fullsizeButton: true,
        resizeButton: true,
        navigate: true,

        //buttons
        fullsizeOnDblClick: true,
        fullsize: false,
        draggable: true,


        mousewheel: true,
        /**
         * @property {boolean} mousewheelYearsLine=true If true, then when scrolling the mouse wheel over lightYears, it will not be constantly changing the month and year will
         */
        mousewheelYearsLine: true,
        reverseMouseWheel: true,
        hideAfterSelect: false,

        /**
         * @property {boolean} hideOnBlur=true When enabled likeXDSoftDateTimePicker mode, and form has more 1 elements, source input lose focus
         */
        hideOnBlur: true,

        norange: false,

        //formats
        formatMonth: 'MMMM YYYY',

        formatDecoreDate: 'D MMMM',
        formatDecoreDateWithYear: 'D MMMM YYYY',
        formatDecoreDateWithoutMonth: 'D',

        formatDecoreDateTimeWithoutMonth: 'HH:mm D',
        formatDecoreDateTime: 'HH:mm D MMMM',
        formatDecoreDateTimeWithYear: 'HH:mm D MMMM YYYY',
        formatDateTime: 'HH:mm YYYY/MM/D',
        formatDate: 'YYYY/MM/D',

        //end period input identificator
        end: '',

        /**
         * @property {boolean} noHideSourceInputs=false Don't hide source inputs
         */
        noHideSourceInputs: false,

        /**
         * @property {boolean} likeXDSoftDateTimePicker=false Hide Picker button, not hide the source input fields. If the input field gets the focus it displays periodpiker. Behavior similar to datetimepicker http://xdsoft.net/jqplugins/datetimepicker/
         */
        likeXDSoftDateTimePicker: false,

        startMonth: (new Date()).getMonth() + 1,
        startYear: (new Date()).getFullYear(),
        dayOfWeekStart: 1, //Mon - 1,t,Wen - 3,th,f,s,Sun - 7
        yearSizeInPixels: 120,
        timepickerWidthInPixels: 50,
        monthWidthInPixels: 184,
        monthHeightInPixels: 174,
        someYOffset: 150,
        yearsPeriod: [2000, (new Date()).getFullYear() + 20],
        weekEnds: [6, 7],   // 1 - is Mon, 7 - is Sun
        holidays: [],       // in formatDate format
        disableDays: [],    // in formatDate format
        minDate: false,     // in formatDate format
        maxDate: false,
        cells: [1, 3],

        /**
         * @property {string|int|null} utcOffset=null Setting the utc offset by supplying minutes http://momentjs.com/docs/#/manipulating/utc-offset/
         */
        utcOffset: null,

        // events
        onTodayButtonClick: false,
        onOkButtonClick: false,
        onAfterShow: false,
        onAfterHide: false,
        onAfterRegenerate: false,
    };
    if (Array.prototype.indexOf === undefined) {
        Array.prototype.indexOf = function (obj, start) {
            var i, j;
            j = this.length;
            for (i = (start || 0); i < j; i += 1) {
                if (this[i] === obj) { return i; }
            }
            return -1;
        };
    }
}(jQuery, window, document));