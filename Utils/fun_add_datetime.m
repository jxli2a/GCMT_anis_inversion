function evts = fun_add_datetime(evts, format)
% for evts with date in format: 'yyyy/MM/dd' and time in format: 'HH:mm:ss.SS' 
% add datenum (in UTC time zone) to the evts
switch format
    case 'jst'
        tshift = -9/24;
    case 'utc'
        tshift = 0;
    otherwise
        fprintf('Time zone not valid\n');
        return;
end
dates = datetime({evts(:).date}, 'format', 'yyyy/MM/dd');
times = datetime({evts(:).time}, 'format', 'HH:mm:ss.SS');
[year, month, day] = ymd(dates);
[hour, minute, second] = hms(times);
mydatenum = datenum(year, month, day, hour, minute, second)+tshift;
datenumcell = num2cell(mydatenum);
[evts.datenum] = datenumcell{:};
end