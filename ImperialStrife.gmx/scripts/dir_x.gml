// indices of relative directions:
//
// 7  0  1
//
// 6  .  2
//
// 5  4  3

switch (argument0)
{
case 7:
case 6:
case 5:
    return -1;
case 0:
case 4:
    return 0;
case 1:
case 2:
case 3:
    return 1;
}
