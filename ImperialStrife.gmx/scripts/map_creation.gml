n_islands = 50
area_min = 15
area_max = 150
width = 160
height = 100
anti_circ = 0.2

randomize();
//display_set_gui_size(800,600);

cells = ds_grid_create(width, height);
//make the whole grid into "WATER"
ds_grid_set_region(cells, 0, 0, width-1, height-1, "WATER");

repeat (n_islands)
{
    var islex = irandom(width - 1);
    var isley = irandom(height - 1);
    ds_grid_set(cells,islex,isley, "LAND"); //starting point set to "LAND"

    var passes = irandom_range(area_min, area_max);
    
    //randomly selects passes number of points close to the center 
    repeat (passes)
    {
        //always start from the center
        var xp = islex;
        var yp = isley;
        
        //randomly walk N/S/E/W seeking water
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
            //we found a point equal to "WATER" so we change it to "LAND"
            ds_grid_set(cells,xp,yp, "LAND");
            
            //occasionally recenter the island, preventing circular blobs
            if (random(1.0) < anti_circ)
            {
                islex = xp;
                isley = yp;
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
        if(ds_grid_get(cells,i,j) == "LAND"){
            instance_create(x_i,y_j,obj_landtile);
        }
        else {
            instance_create(x_i,y_j,obj_watertile);
        }
        
        y_j = y_j + tile_size;
    }
    x_i = x_i + tile_size;
}

instance_create(0,0,obj_unit)
