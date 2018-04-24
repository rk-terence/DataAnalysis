function sheetname = GenSheetname(i, file)
    if i <= 6
        sheetname = "15年" + string(i + 6) + "月";            
    else
        if i <= 18
            sheetname = "16年" + string(i - 6) + "月";
        else
            sheetname = "17年" + string(i - 18) + "月";
        end
    end