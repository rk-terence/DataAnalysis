function [Header, row_vector_default] = getHeader(output_kind, n_vars)
switch output_kind
    case 0
        Header = cell(1, n_vars + 7);
        row_vector_default = cell(1, n_vars + 7);
        for i = 1:n_vars
            Header{i} = char("Var" + string(i));
        end
        Header{n_vars+1} = 'Bigleaf';
        Header{n_vars+2} = 'Bmleaf';
        Header{n_vars+3} = 'Midleaf';
        Header{n_vars+4} = 'Brokenleaf';
        Header{n_vars+5} = 'Workorder';
        Header{n_vars+6} = 'Productionorder';
        Header{n_vars+7} = 'Category';
    case 1
        Header = cell(1, n_vars+9);
        row_vector_default = cell(1, n_vars + 9);
        for i=1:n_vars
            Header{i} = char("Var" + string(i));
        end
        Header{n_vars+1} = 'Fillsi';
        Header{n_vars+2} = 'Longsi';
        Header{n_vars+3} = 'Midsi';
        Header{n_vars+4} = 'Shortsi';
        Header{n_vars+5} = 'Brokensi';
        Header{n_vars+6} = 'Completesi';
        Header{n_vars+7} = 'Workorder';
        Header{n_vars+8} = 'Productionorder';
        Header{n_vars+9} = 'Category';
    case 2
        Header = cell(1, n_vars + 13);
        row_vector_default = cell(1, n_vars + 13);
        Header{n_vars+1} = 'Bigleaf';
        Header{n_vars+2} = 'Bmleaf';
        Header{n_vars+3} = 'Midleaf';
        Header{n_vars+4} = 'Brokenleaf';
        Header{n_vars+5} = 'Fillsi';
        Header{n_vars+6} = 'Longsi';
        Header{n_vars+7} = 'Midsi';
        Header{n_vars+8} = 'Shortsi';
        Header{n_vars+9} = 'Brokensi';
        Header{n_vars+10} = 'Completesi';
        Header{n_vars+11} = 'Workorder';
        Header{n_vars+12} = 'Productionorder';
        Header{n_vars+13} = 'Category';
end