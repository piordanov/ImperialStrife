n_islands = 50
area_min = 15
area_max = 150
width = 160
height = 100
anti_circ = 0.2

dir_x[0] = 0
dir_x[1] = 1
dir_x[2] = 1
dir_x[3] = 1
dir_x[4] = 0
dir_x[5] = -1
dir_x[6] = -1
dir_x[7] = -1

dir_y[0] = -1
dir_y[1] = -1
dir_y[2] = 0
dir_y[3] = 1
dir_y[4] = 1
dir_y[5] = 1
dir_y[6] = 0
dir_y[7] = -1

randomize();
//display_set_gui_size(800,600);

cells = ds_grid_create(width, height);
//make the whole grid into "WATER"
ds_grid_set_region(cells, 0, 0, width-1, height-1, "WATER");

repeat (n_islands)
{
    var islex = irandom(width - 1);
    var isley = irandom(height - 1);
    
    var i;
    
    ds_grid_set(cells,islex,isley, "LAND"); //starting point set to "LAND"
    for (i = 0; i < 8; i += 1)
    {
        var xpp = islex + dir_x[i];
        var ypp = isley + dir_y[i];
        if (ds_grid_get(cells, xpp, ypp) == "WATER")
        {
            ds_grid_set(cells, xpp, ypp, "COAST");
        }
    }

    var passes = irandom_range(area_min, area_max);
    
    //randomly selects passes number of points close to the center 
    repeat (passes)
    {
        //always start from the center
        var xp = islex;
        var yp = isley;
        
        //randomly walk N/S/E/W seeking coast
        while (ds_grid_get(cells,xp,yp) == "LAND")
        {
            if (irandom(1) == 0)
            {
                xp += choose(-1, 1);
            }
            else
            {
                yp += choose(-1, 1);
            }
        }
        
        if (xp < width and yp < height and xp >= 0 and yp >= 0)
        {
            //we found a point equal to "COAST" so we change it to "LAND"
            ds_grid_set(cells,xp,yp, "LAND");
            
            for (i = 0; i < 8; i += 1)
            {
                var xpp = xp + dir_x[i];
                var ypp = yp + dir_y[i];
                if (ds_grid_get(cells, xpp, ypp) == "WATER")
                {
                    ds_grid_set(cells, xpp, ypp, "COAST");
                }
            }
            
            //occasionally recenter the island, preventing circular blobs
            if (random(1.0) < anti_circ)
            {
                islex = xp;
                isley = yp;
            }
        }
    }

    var i_x;
    var i_y;
    
    for (i_x = 0; i_x < width; i_x += 1)
    {
        for (i_y = 0; i_y < height; i_y += 1)
        {
            if (ds_grid_get(cells, i_x, i_y) == "COAST")
            {
                var no_water = true;
                for (i = 0; i < 8; i++)
                {
                    var xp = i_x + dir_x[i];
                    var yp = i_y + dir_y[i];
                    if (ds_grid_get(cells, xp, yp) == "WATER")
                    {
                        no_water = false;
                        break;
                    }
                }
                
                if (no_water == true)
                {
                    ds_grid_set(cells, i_x, i_y, "LAND");
                }
            }
        }
    }
}

global.logfile = file_text_open_write(working_directory + "temp1.txt")
{
var i;
for (i = 0; i < width; i += 1)
{
    var j;
    for (j = 0; j < height; j += 1)
    {
        file_text_write_string(global.logfile, string(ds_grid_get(cells,i,j)) + string(":"));
    }
}
}
file_text_close(global.logfile)

//place tiles in the room
tile_size = 32;
x_i = 0;
for(i = 0; i < width; i += 1)
{
    y_j = 0;
    for(j = 0; j < height; j += 1)
    {
        if (ds_grid_get(cells,i,j) == "LAND")
        {
            instance_create(x_i,y_j,obj_landtile);
        }
        else
        {
            var seatile = instance_create(x_i,y_j,obj_watertile);
            seatile.image_speed = 0;
            if (ds_grid_get(cells,i,j) == "COAST")
            {
                seatile.image_index = 1;
            }
        }
        
        y_j = y_j + tile_size;
    }
    x_i = x_i + tile_size;
}

instance_create(0,0,obj_unit)
