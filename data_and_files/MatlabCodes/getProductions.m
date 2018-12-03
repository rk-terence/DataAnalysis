function [productions, category] = getProductions(relationship_charlie, monthyear, ...
    category, prod_line, output_kind)

% To get the production orders in the month year range:
monthyear_array = char(relationship_charlie.Productionorder);
monthyear_array = string(monthyear_array(:,1:6));
startrow = find(monthyear(1) == monthyear_array, 1, 'first');
endrow = find(monthyear(2) == monthyear_array, 1, 'last');
productions = relationship_charlie(startrow:endrow, :);
% Delete other production lines
prod_line_array = char(productions.Productionorder);
prod_line_array = prod_line_array(:, 9);
productions(prod_line_array ~= prod_line, :) = []; 
% Delete other categories
switch output_kind
    case 0
        category = "��Ⱥ(" + category + ")ҶƬ";
        productions(string(productions.Category) ~= category,:) = [];
    case 1
        category = "��Ⱥ��" + category + "��Ҷ˿";
        productions(string(productions.Category) ~= category,:) = [];
    case 2
        category = ["��Ⱥ(" + category + ")ҶƬ"; "��Ⱥ��" + category + "��Ҷ˿"];
        productions = productions(string(productions.Category)==category(1) ... 
            + string(productions.Category) == category(2), :);
    otherwise
        error("Wrong input of output_kind");
end