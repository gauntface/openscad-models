# SVG Cleanup

1. Path > Split Path
1. Make a copy of 2 element
1. Change color of the copy so it stands out
1. Overlay the color copy and first element do you have the engraving
1. Group the copy and the first element
1. Overlay the new group with the second element so they are positioned correctly
1. Diff the color copy and the first element so you are just left with the
   engraving part
1. In the colors engraving part, remove the holes
1. Set all of the outer elements to have no fill and a stroke
1. Path > Break Apart each piece
1. Swap out all ear holes with a 2.8 circle by chaging align to Last Selected
1. Swap out all over holes with 3.4 circle
1. Swap the LED square with a 5.6 circle with a unique color
1. Add header values with size 8 + bold using Noto Sans Mono
1. Flip header values horizontally
1. Replace header cut out with rectanges with 0.4 radius
1. Replace the screen sections with a rectangle with 0.4 radius
1. Now round corners of each layer with:
    1. Path > Path Effects
    1. Add at the bottom of the panel
    1. Add Corners (Fillet / Chamfer)
    1. Add 4mm radius to all outside nodes
1. On the pcb layer, remove radius on internal points
1. Add a "Clear" message above the section for the screen (This get auto removed by glowforga as its text)
1. Add a logo if you want