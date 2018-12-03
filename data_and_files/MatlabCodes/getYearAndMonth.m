function [start_year, start_month, end_year, end_month] = getYearAndMonth ...
    (monthyear)

start_monthyear = char(monthyear(1));
if start_monthyear(5) == '0'
    start_month = start_monthyear(6) - '0';
else
    start_month = start_monthyear(6) - '0' + 10;
end
start_year = 15 + start_monthyear(4) - '5';

end_monthyear = char(monthyear(2));
if end_monthyear(5) == '0'
    end_month = end_monthyear(6) - '0';
else
    end_month = end_monthyear(6) - '0' + 10;
end
end_year = 15 + end_monthyear(4) - '5';