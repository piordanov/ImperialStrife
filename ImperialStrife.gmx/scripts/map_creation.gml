n_islands = 5
area_min = 20
area_max = 200
width = 100
height = 160

while (n_islands-- > 0)
{
var x = floor(random(width));
var y = floor(random(height));

int passes = area_min + floor(random(area_max - area_min));

while (passes-- > 0)
{
//growIsland(x, y, (int)(CCRANDOM_0_1() * 8));
}
}


for (int y = 0; y < 60; y++)
    {
    for (int x = 0; x < 100; x++)
    {
        int gid;

        switch (this->getCellTypeAt(x, y))
        {
            case MapModel::CellType::COAST:
                gid = 1;
                break;
            case MapModel::CellType::LAND:
                gid = 8;
                break;
            default:
                gid = 11;
                break;
        }

        layer->setTileGID(gid, cocos2d::Vec2(x, y));
    }
    }
}

growIsland(int x, int y, int diag)
{
if (!inBounds(x, y)) return;

if (cells[y][x] == CellType::LAND)
{
int dir = (diag + 6 + (int)(CCRANDOM_0_1() * 5)) % 8;
int xp = x + cellAdj[dir][0];
int yp = y + cellAdj[dir][1];
growIsland(xp, yp, diag);
}
else
{
cells[y][x] = CellType::LAND;
}
}


