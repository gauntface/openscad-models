// 4 mm
unit = 10;
materialThickness = 3;

boxWidthUnits = 17;
boxHeightUnits = 26;
boxDepthUnits = 26;

teethLength = unit - 4;

createTeethHoles = true;

echo("-----------------------------");
echo();
echo("Width:");
echo(boxWidthUnits * unit);
echo();
echo("Height:");
echo(boxHeightUnits * unit);
echo();
echo("Depth:");
echo(boxDepthUnits * unit);
echo();
echo("-----------------------------");

module renderHorizontalPiece(widthUnit, depthUnit, positionUnits){
    totalWidth = (widthUnit * unit);
    totalDepth = (depthUnit * unit);
    
    echo(totalWidth);
    
    // Minus half thickness to make everything center on the units
    translate([
        (positionUnits[0] * unit),
        (positionUnits[1] * unit),
        (positionUnits[2] * unit)]) {
        difference() {
            cube([
                totalWidth,
                totalDepth,
                materialThickness
            ]);
            
            if (createTeethHoles) {
                for(j = [1 : 1 : depthUnit - 1]) {
                    translate([0, (unit * j), 0]) {
                        for(i = [1 : 1 : widthUnit - 1]) {
                            translate([(unit * i) - (materialThickness / 2), -(teethLength / 2), -materialThickness]) {
                                color([1, 0, 0]) cube([materialThickness, teethLength, (materialThickness * 3)]);
                            }
                        }
                    }
                }
                
                for(j = [1 : 1 : depthUnit - 1]) {
                    translate([0, (unit * j) - (materialThickness /2), 0]) {
                        for(i = [1 : 1 : widthUnit - 1]) {
                            translate([(unit * i) - (teethLength / 2), 0, -materialThickness]) {
                                color([1, 0, 0]) cube([teethLength, materialThickness, (materialThickness * 3)]);
                            }
                        }
                    }
                }
            }
        }
    }
}

module renderVerticalsPiece(heightUnit, depthUnit, positionUnits){
    // Minus half thickness to make everything center on the units
    translate([
        (positionUnits[0] * unit) - (materialThickness / 2),
        (positionUnits[1] * unit),
        (positionUnits[2] * unit)]) {
        
        difference() {
            // Add 1 thickness to account for half thickness either
            // side of the shape
            cube([
                materialThickness,
                (depthUnit * unit),
                (heightUnit * unit)
            ]);
            
            if (createTeethHoles) {
                // Removal of the middle teeth holes
                for(j = [1 : 1 : depthUnit - 1]) {
                    translate([0, (unit * j) - (materialThickness / 2), 0]) {
                        for(i = [1 : 1 : heightUnit - 1]) {
                            translate([-materialThickness, 0, (unit * i) - (teethLength / 2)]) {
                                color([1, 0, 0]) cube([materialThickness * 3, materialThickness, teethLength]);
                            }
                        }
                    }
                }
                
                for(j = [1 : 1 : depthUnit - 1]) {
                    translate([0, (unit * j) - (teethLength / 2), 0]) {
                        for(i = [1 : 1 : heightUnit - 1]) {
                            translate([-materialThickness, 0, (unit * i) - (materialThickness / 2)]) {
                                color([1, 0, 0]) cube([materialThickness * 3, teethLength, materialThickness]);
                            }
                        }
                    }
                }
                
                // Remove of sections to create teeth
                if (positionUnits[1] == 0) {
                    translate([-materialThickness, 0, -materialThickness]) {
                        color([0, 0, 1]) cube([materialThickness * 3, unit - (teethLength / 2), materialThickness * 2]);
                    }
                    
                    translate([-materialThickness, 0, (heightUnit * unit) - materialThickness]) {
                        color([0, 0, 1]) cube([materialThickness * 3, unit - (teethLength / 2), materialThickness * 2]);
                    }
                }
        
                if(positionUnits[1] + depthUnit == boxDepthUnits) {
                    translate([-materialThickness, (depthUnit * unit) - (unit - (teethLength / 2)), -materialThickness]) {
                        color([0, 0, 1]) cube([materialThickness * 3, unit - (teethLength / 2), materialThickness * 2]);
                    }
                    
                    translate([-materialThickness, (depthUnit * unit) - (unit - (teethLength / 2)), (heightUnit * unit)-materialThickness]) {
                        color([0, 0, 1]) cube([materialThickness * 3, unit - (teethLength / 2), materialThickness * 2]);
                    }
                }
                
                for(i = [0 : 1 : depthUnit - 1]) {
                    translate([-materialThickness, (i * unit) + (teethLength / 2), -materialThickness]) {
                        color([1, 0, 0]) cube([materialThickness * 3, unit - teethLength, materialThickness * 2]);
                    }
                    
                    translate([-materialThickness, (i * unit) + (teethLength / 2), (heightUnit * unit)-materialThickness]) {
                        color([1, 0, 0]) cube([materialThickness * 3, unit - teethLength, materialThickness * 2]);
                    }
                }
            }
        }
    }
}

module renderExternalEdges() {
    // Base
    renderHorizontalPiece(boxWidthUnits, boxDepthUnits, [0, 0, 0]);
    
    // Top
    //renderHorizontalPiece(boxWidthUnits, boxDepthUnits, [0, 0, boxHeightUnits]);
    
    // Left
    //renderVerticalsPiece(boxHeightUnits, boxDepthUnits, [0, 0, 0]);
    
    // Right
    //srenderVerticalsPiece(boxHeightUnits, boxDepthUnits, [boxWidthUnits, 0, 0]);
}



renderExternalEdges();

 
// Two Section Split
color([0, 1, 0]) renderVerticalsPiece(boxHeightUnits, boxDepthUnits, [3, 0, 0]);

// Anker Hub Top
//renderHorizontalPiece(3, boxDepthUnits, [0, 0, 7]);

// Network Switch Top
//renderHorizontalPiece(3, boxDepthUnits, [0, 0, 23]);

// NAS Top
//renderHorizontalPiece(boxWidthUnits - 3, boxDepthUnits, [3, 0, 17]);

// HDMI Top
//renderHorizontalPiece(boxWidthUnits - 3, boxDepthUnits, [3, 0, 20]);