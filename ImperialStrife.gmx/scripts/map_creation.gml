n_islands = 50
area_min = 15
area_max = 150
width = 160
height = 100
anti_circ = 0.2

// indices of relative directions:
//
// 7  0  1
//
// 6  .  2
//
// 5  4  3

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

var coast_prio;
coast_prio[0] = coast_e0
coast_prio[1] = coast_d0
coast_prio[2] = coast_d1
coast_prio[3] = coast_d2
coast_prio[4] = coast_d3
coast_prio[5] = coast_c0
coast_prio[6] = coast_c1
coast_prio[7] = coast_c2
coast_prio[8] = coast_c3
coast_prio[9] = coast_b0
coast_prio[10] = coast_b1
coast_prio[11] = coast_b2
coast_prio[12] = coast_b3

var coast_mask;
coast_mask[0] = "01234567"
coast_mask[1] = "0123457"
coast_mask[2] = "1234567"
coast_mask[3] = "0134567"
coast_mask[4] = "0123567"
coast_mask[5] = "01237"
coast_mask[6] = "12345"
coast_mask[7] = "34567"
coast_mask[8] = "01567"
coast_mask[9] = "017"
coast_mask[10] = "123"
coast_mask[11] = "345"
coast_mask[12] = "567"

var coast_corner;
coast_corner[1] = coast_a1;
coast_corner[3] = coast_a2;
coast_corner[5] = coast_a3;
coast_corner[7] = coast_a0;

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
tile_size = 128;
x_i = 0;
for(i = 0; i < width; i += 1)
{
    y_j = 0;
    for(j = 0; j < height; j += 1)
    {
        switch (ds_grid_get(cells,i,j))
        {
        case "LAND":
            instance_create(x_i,y_j,obj_landtile);
            break;
        case "COAST":
            var land_adj;
            var k;
            for (k = 0; k < 8; k++)
            {
                land_adj[k] = (ds_grid_get(cells, i + dir_x[k], j + dir_y[k]) == "LAND");
            }
            
            var m;
            for (m = 0; m < array_length_1d(coast_mask); m++)
            {
                var excess = false;
                for (k = 0; k < 8; k += 2)
                {
                    var contains = (string_pos(string(k), coast_mask[m]) != 0)
                    if ((land_adj[k] == false) and (contains == true))
                    {
                        excess = true;
                        break;
                    }
                }
                
                if (excess == false)
                {
                    with (instance_create(x_i, y_j, obj_coastoverlay))
                    {
                        sprite_index = coast_prio[m];
                    }
                    
                    var i_c;
                    for (i_c = 1; i_c <= string_length(coast_mask[m]); i_c++)
                    {
                        land_adj[floor(real(string_char_at(coast_mask[m], i_c)))] = false;
                    }
                }
            }
            
            for (k = 1; k < 8; k += 2)
            {
                if (land_adj[k] == true)
                {
                    with (instance_create(x_i, y_j, obj_coastoverlay))
                    {
                        sprite_index = coast_corner[k];
                    }
                }
            }
        case "WATER":
            instance_create(x_i,y_j,obj_watertile);
            break;
        }
        
        y_j = y_j + tile_size;
    }
    x_i = x_i + tile_size;
}

instance_create(0,0,obj_unit)
