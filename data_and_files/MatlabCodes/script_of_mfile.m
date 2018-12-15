% Delete other production lines in raw_data
po_array_raw = char(raw_data.Productionorder);
po_array_raw = po_array_raw(9, :);
raw_data(po_array_raw ~= prod_line, :) = [];

% Delete other categories in raw_data
if output_kind == 2
    raw_data(logical((string(raw_data.Category) ~= category_ex(1)) .* ...
        (string(raw_data.Category) ~= category_ex(2)))) = [];
else
    raw_data(string(raw_data.Category) ~= category_ex, :) = [];
end