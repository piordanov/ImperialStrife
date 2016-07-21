var cells = argument0;
var xt = argument1;
var yt = argument2;

var width = ds_grid_width(cells);
var height = ds_grid_height(cells);

while (true)
{
    var xp;
    var yp;
    do
    {
        var d = irandom(7);
        xp = xt + dir_x(d);
        yp = yt + dir_y(d);
    } until (xp >= 0 and xp < width and yp >= 0 and yp < height)
    xt = xp;
    yt = yp;
    
    if (ds_grid_get(cells, xt, yt) == "LAND")
    {
        var d;
        var no_city = true;
        for (d = 0; d < 8; d++)
        {
            if (ds_grid_get(cells, xt + dir_x(d), yt + dir_y(d)) == "CITY")
            {
                no_city = false;
                break;
            }

        }
        
        if (no_city)
        {
            ds_grid_set(cells, xt, yt, "CITY");
            return 0;
        }
    }
}

