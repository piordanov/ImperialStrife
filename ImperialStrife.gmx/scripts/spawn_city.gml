var cells = argument0;
var xt = argument1;
var yt = argument2;

var width = ds_grid_width(cells);
var height = ds_grid_height(cells);

while (ds_grid_get(cells, xt, yt) != "LAND")
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
}

ds_grid_set(cells, xt, yt, "CITY");
