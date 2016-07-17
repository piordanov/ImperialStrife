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
case 0:
case 1:
    return -1;
case 6:
case 2:
    return 0;
case 5:
case 4:
case 3:
    return 1;
}
