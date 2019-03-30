xy_data = table2array(xy_table(:, 1:(end-3)));
[~, n_features] = size(xy_data);

variance = var(xy_data);