n_islands = 5
area_min = 20
area_max = 200
width = 100
height = 160

randomize();
//display_set_gui_size(800,600);

cells = ds_grid_create(width, height);
//make the whole grid into "WATER"
ds_grid_set_region(cells, 0, 0, width-1, height-1, "WATER");

repeat(n_islands)
{
    var islex = floor(random(width));
    var isley = floor(random(height));
    ds_grid_set(cells,islex,isley, "LAND"); //starting point set to "LAND"

    var passes = area_min + floor(random(area_max - area_min));
    
    
    //randomly selects passes number of points close to the center 
    repeat(passes)
    {
        //always start from the center
        var xp = islex;
        var yp = isley;
        
        while(ds_grid_get(cells,xp,yp) == "LAND")
        {
           if (xp >= width or yp >= height or xp < 0 or yp < 0)
                break;
           var randx = floor(random_range(-1,2));
           var randy = floor(random_range(-1,2));
           
           xp += randx;
           yp += randy;
           
        }
        //we found a point equal to "WATER" so we change it to "LAND"
        ds_grid_set(cells,xp,yp, "LAND");
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

x_i = 0;
for(i = 0; i < width; i += 1)
{
    y_j = 0;
    for(j = 0; j < height; j += 1)
    {
        if(ds_grid_get(cells,i,j) == "LAND"){
            instance_create(x_i,y_j,obj_landtile);
        }
        if(ds_grid_get(cells,i,j) == "WATER"){
            instance_create(x_i,y_j,obj_watertile);
        }
        
        y_j = y_j + 30;
    }
    x_i = x_i + 30;
}

