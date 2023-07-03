# advanced-bend-modifier-maxscript
A tool to bend 3d mesh on a snappable grid in Autodesk 3ds Max

This maxscript gives you more control over the bend modifier  
It lets you  input a width and the script will move the center to get the correct width

### how to use

- have 1 bend modifier applied on the mesh, or click on the `new bend modifier` button to create one
- enter the start height in height (used to calculate the correct offset)
- choose an angle  
![image](https://github.com/hannesdelbeke/advanced-bend-modifier-maxscript/blob/main/docs/angle.gif?raw=true)
- choose the direction  
![image](https://github.com/hannesdelbeke/advanced-bend-modifier-maxscript/blob/main/docs/direction.gif?raw=true)
- manual mode: lets the user manually control the width  
![image](https://github.com/hannesdelbeke/advanced-bend-modifier-maxscript/blob/main/docs/manual.gif?raw=true)
- grid size: choose the grid size to snap to  
- snap grid: if on it will snap to the grid  
![image](https://github.com/hannesdelbeke/advanced-bend-modifier-maxscript/blob/main/docs/gridsnap.gif?raw=true)

feedback is always welcome!
if any links are down contact me


### features:

- uses smart snap to snap to a custom grid
- easily choose angle and direction
- apply new bend modifier with correct offset
- auto update current bendmodifier with selected settings
- realtime update of all settings!
- support for all 4 directions and 4 angles (90 180 270 360)
- choose your final width
- modify multiple selections at same time
- snap position to grid

### dev
- (2014): developped in max 2014, released on [scriptspot](https://www.scriptspot.com/3ds-max/scripts/advanced-bend-modifier)
- (2023): tested in 3ds Max 2024, released on [github](https://github.com/hannesdelbeke/advanced-bend-modifier-maxscript)
