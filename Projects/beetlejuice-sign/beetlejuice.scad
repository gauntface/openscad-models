include <../../libs/flat-ui-colors.scad>;
include <../../libs/t-joint.scad>;

/* Board size 20.5"w x 12"h */
/* 520mm w x 304mm H
/* Divide sizes by 2.4 */

pieceThickness = 3.3;
cornerCutW = 45; // To support a ping pong ball in the corner
backPieceW = 448; // 20" in mm
backPieceH = 254; // 10" in mm
lightDiameter = 40;
lightRadius = lightDiameter / 2;
lightEdgeSpacing = 5;
wallHeight = 45;
innerWallY = 164;
innerWallX = 358;
insetSize = lightEdgeSpacing + lightDiameter;
cornerInsets = 18;
topBottomWallX = innerWallX - (cornerInsets * 2);
topBottomInsetX = cornerInsets + ((backPieceW - innerWallX) / 2);
leftRightY = innerWallY - (cornerInsets * 2);
leftRightInsetY = cornerInsets + ((backPieceH - innerWallY) / 2);

lightYCount=3;
lightYPadding = 85;
lightYAvailableSpace = backPieceH - (lightYPadding * 2) + lightDiameter;
lightYTotalSpace = lightYAvailableSpace - (lightYCount * lightDiameter);
lightYSpacing = lightYTotalSpace / (lightYCount - 1);

lightXPadding = 90;
lightXAvailableSpace = backPieceW - (lightXPadding * 2) + lightDiameter;
lightXCount = 7;
lightXTotalSpace = lightXAvailableSpace - (lightXCount * lightDiameter);
lightXSpacing = lightXTotalSpace / (lightXCount - 1);
    
module backPieceCornerCut() {
    CubePoints = [
      [-1,  -1,  -1],  // (0) Bottom left
      [ cornerCutW + 1,  -1,  -1],  // (1) Bottom right
      [ -1,  cornerCutW + 1,  -1 ],  // (2) Bottom top
    
      [-1,  -1,  pieceThickness + 1],  // (3) Top left
      [ cornerCutW + 1,  -1,  pieceThickness + 1],  // (4) Top right
      [ -1,  cornerCutW + 1,  pieceThickness + 1 ],  // (5) Top top
      
      [  0,  0,  0 ],  //0
      [ cornerCutW,  0,  0 ],  //1
      [ 0,  cornerCutW,  0 ]  //2
   ];
  
    CubeFaces = [
        [0,1,2],  // bottom
        [3,5, 4],  // top

        [0,3,4,1],  // front
        [2,5,3,0],  // left

        [1,4,5, 2],  // Hypotenuse  
    ];
  
    color(flatui[1])
    polyhedron( CubePoints, CubeFaces );
}

module backPiece() {
    difference() {
        color(flatui[0])
        cube([backPieceW, backPieceH, pieceThickness]);
        
        backPieceCornerCut(); // Bottom left
        
        translate([0, backPieceH, 0]) {
            rotate([0, 0, -90]) {
              backPieceCornerCut(); // Top left
            }
        }
        
        translate([backPieceW, 0, 0]) {
            rotate([0, 0, 90]) {
                backPieceCornerCut(); // Bottom right
            }
        }
        
        translate([backPieceW, backPieceH, 0]) {
            rotate([0, 0, 180]) {
                backPieceCornerCut(); // Top right
            }
        }
        
        innerWall(forTeethRemoval=true);
    }
}

module leftRightWall(forTeethRemoval = false) {
    teethHeight = forTeethRemoval ? 20 : pieceThickness;
    teethZAdjustment = forTeethRemoval ? 5 : 0;
    wallHeightWithTeeth = wallHeight+teethHeight;
    
    teethSize = 24;
    insetTeeth = 15;
    

    difference() {
        union() {
            if (!forTeethRemoval) {
                translate([0, 0, pieceThickness]) {
                    cube([pieceThickness, leftRightY, wallHeight]);
                }
            }
            
            translate([0, insetTeeth, pieceThickness-teethHeight+teethZAdjustment]) {
                cube([pieceThickness, teethSize, teethHeight]);
            }
            
            translate([0, leftRightY - teethSize - insetTeeth, pieceThickness-teethHeight+teethZAdjustment]) {
                cube([pieceThickness, teethSize, teethHeight]);
            }
        }
        translate([pieceThickness/2, leftRightY/2, pieceThickness]) {
            rotate([0,0,90]) {
                createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
            }
        }
        
        lightYPadding = 4;
        lightYTotalSpace = leftRightY - (lightDiameter * lightYCount) - lightYPadding;
        lightYSpacing = lightYTotalSpace / (lightYCount - 1); 
        for (i=[1:lightYCount]) {
            lightY = (lightYPadding/2) + (lightDiameter/2) + ((lightYSpacing + lightDiameter)*(i-1));
            translate([0, lightY, 0]) {
                lightBulb(bulb=false, cutout=true);
            }
        }
    }
   
    
    if (forTeethRemoval) {
        leftRightShelvePieces(cutout=forTeethRemoval);
        
        translate([pieceThickness/2, leftRightY/2, pieceThickness + 0.2]) {
            rotate([0,0,90]) {
                createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
            }
        }
    }
}

module topBottomWall(forTeethRemoval = true) {
    teethHeight = forTeethRemoval ? 20 : pieceThickness;
    teethZAdjustment = forTeethRemoval ? 5 : 0;
    wallHeightWithTeeth = wallHeight+teethHeight;
    
    insetTeeth = 15;
    teethSize = 24;
    innerSpace = 64;
    
    difference() {
        union() {
            if (!forTeethRemoval) {
                translate([0, 0, pieceThickness]) {
                    cube([topBottomWallX, pieceThickness, wallHeight]);
                }
            }
            
            translate([insetTeeth, 0, pieceThickness-teethHeight+teethZAdjustment]) {
                cube([teethSize, pieceThickness, teethHeight]);
            }
            
            
            translate([insetTeeth + teethSize + innerSpace, 0, pieceThickness-teethHeight+teethZAdjustment]) {
                cube([teethSize, pieceThickness, teethHeight]);
            }
            
            translate([topBottomWallX - teethSize - insetTeeth, 0, pieceThickness-teethHeight+teethZAdjustment]) {
                cube([teethSize, pieceThickness, teethHeight]);
            }
            
            translate([topBottomWallX - teethSize - insetTeeth - innerSpace - teethSize, 0, pieceThickness-teethHeight+teethZAdjustment]) {
                cube([teethSize, pieceThickness, teethHeight]);
            }
        }
        
        // Screw holes
        translate([insetTeeth + teethSize + (innerSpace/2),pieceThickness/2, pieceThickness]) {
            createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
        }
        
        translate([topBottomWallX /2,pieceThickness/2, pieceThickness]) {
            createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
        }
        
        translate([topBottomWallX - insetTeeth - teethSize - (innerSpace/2),pieceThickness/2, pieceThickness]) {
            createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
        }
        
        lightXPadding = 10;
        lightXTotalSpace = topBottomWallX - (lightDiameter * lightXCount) - lightXPadding;
        lightXSpacing = lightXTotalSpace / (lightXCount - 1); 
        for (i=[1:lightXCount]) {
            lightX = (lightXPadding / 2) + lightRadius + ((lightXSpacing + lightDiameter)*(i-1));
            translate([lightX, 0, 0]) {
                rotate([0, 0, 90]) {
                    lightBulb(bulb=false, cutout=true);
                }
            }
        }
    }
    
    if (forTeethRemoval) {
        topBottomShelvePieces(cutout=true);
        
        translate([insetTeeth + teethSize + (innerSpace/2),pieceThickness/2, pieceThickness + 0.2]) {
            createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
        }
        
        translate([topBottomWallX /2,pieceThickness/2, pieceThickness + 0.2]) {
            createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
        }
        
        translate([topBottomWallX - insetTeeth - teethSize - (innerSpace/2),pieceThickness/2, pieceThickness + 0.2]) {
            createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
        }
    }
}

module cornerWall(forTeethRemoval=false) {
    teethHeight = forTeethRemoval ? 20 : pieceThickness;
    wallHeightWithTeeth = wallHeight+pieceThickness;
    
    cornerWidth = 21;
    teethSize = 5;
    
    difference() {
        translate([0, 0, wallHeightWithTeeth/2]) {
            difference() {
                union() {
                    translate([0, 0, (pieceThickness / 2)]) {
                        cube([cornerWidth, pieceThickness, wallHeight], center=true);
                    }
                    
                    translate([-((cornerWidth - teethSize)/2), 0, -(wallHeight / 2)]) {
                        cube([teethSize, pieceThickness, teethHeight], center=true);
                    }
                    translate([((cornerWidth - teethSize)/2), 0, -(wallHeight / 2)]) {
                        cube([teethSize, pieceThickness, teethHeight], center=true);
                    }
                }
                
                translate([0,0,-(wallHeight/2) +(pieceThickness / 2)]) {
                    createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
                }
            }
        }
        
        rotate([0, 0, 90]) {
            lightBulb(bulb=false, cutout=true);
        }
    }
    
    if (forTeethRemoval) {
        translate([0,0,pieceThickness]) {
            createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
        }
    }
}

module innerWall(forTeethRemoval=false) {
    wallHeightWithTeeth = wallHeight+pieceThickness;
    
    // Left wall
    color(flatui[4])
    translate([insetSize, cornerInsets + ((backPieceH - innerWallY) / 2), 0]) {
        leftRightWall(forTeethRemoval);
    }
    
    // Right wall
    color(flatui[5])
    translate([backPieceW - insetSize - pieceThickness, cornerInsets + ((backPieceH - innerWallY) / 2), 0]) {
        translate([pieceThickness, leftRightY, 0]) {
            rotate([0, 0, 180]) {
                leftRightWall(forTeethRemoval);
            }
        }
    }
    
    // Bottom wall
    color(flatui[6])
    translate([topBottomInsetX, insetSize, 0]) {
        topBottomWall(forTeethRemoval);
    }
    
    // Top wall
    color(flatui[7])
    translate([(cornerInsets + (backPieceW - innerWallX) / 2), backPieceH - insetSize - pieceThickness, 0]) {
        translate([topBottomWallX, pieceThickness, 0]) {
            rotate([0, 0, 180]) {
                topBottomWall(forTeethRemoval);
            }
        }
    }
    
    cornerInset = (cornerCutW/2) + lightEdgeSpacing + 28;
    // Bottom left corner
        translate([cornerInset, cornerInset, 0]) {
            rotate([0, 0, -45]) {
                translate([0, -(pieceThickness/2), 0]) {
                    cornerWall(forTeethRemoval);
                }
            }
        }
    
    // Top left corner
    difference() {
        translate([cornerInset, backPieceH - cornerInset, 0]) {
            rotate([0, 0, 45]) {
                translate([0, pieceThickness/2, 0]) {
                    cornerWall(forTeethRemoval);
                }
            }
        }
        lights(showBulbs=false, showCutouts=true);
    }
    
    // Top right corner
    // difference() {
        translate([backPieceW - cornerInset, backPieceH - cornerInset, 0]) {
            rotate([0, 0, -45]) {
                translate([0, pieceThickness/2, 0]) {
                    cornerWall(forTeethRemoval);
                }
            }
        }
        // lights(showBulbs=false, showCutouts=true);
    // }
    
    // Bottom right corner
    difference() {
        translate([backPieceW - cornerInset, cornerInset, 0]) {
            rotate([0, 0, 45]) {
                translate([0, -(pieceThickness/2), 0]) {
                    cornerWall(forTeethRemoval);
                }
            }
        }
        lights(showBulbs=false, showCutouts=true);
    }
}

module lightBulb(cutout=true, bulb=true) {
    translate([0, 0, (wallHeight - lightDiameter) / 2]) {
        if (bulb) {
            translate([0, 0, lightRadius + pieceThickness]) {
                sphere(d=lightDiameter);
            }
        }
        
        neopixelCutOutX = lightDiameter * 4;
        neopixelSize = 6;
        neopixelSizeHalf = neopixelSize / 2;
        if (cutout) {
            translate([-(neopixelCutOutX/2), -neopixelSizeHalf, lightRadius + pieceThickness - neopixelSizeHalf]) {
                cube([neopixelCutOutX, neopixelSize, neopixelSize]);
            }
        }
    }
}

module debug_lightCornerMarkers() {
    inset = (cornerCutW/2) + lightEdgeSpacing;
    color(flatui[7]) {
        // Bottom left
        cube([inset, inset, 75]);
        
        // Bottom right
        translate([backPieceW - inset, 0, 0]) {
            cube([inset, inset, 75]);
        }
        
        // Top right
        translate([backPieceW - inset, backPieceH - inset, 0]) {
            cube([inset, inset, 75]);
        }
        
        // Top left
        translate([0, backPieceH - inset, 0]) {
            cube([inset, inset, 75]);
        }
    }
}

module lights(showBulbs = false, showCutouts = true) {
    wallHeightWithTeeth = wallHeight+pieceThickness;
    
    echo ("------------------- X --------------------");
    echo ("backPieceW ",backPieceW);
    echo ("lightXPadding ",lightXPadding);
    echo ("lightXCount ",lightXCount);
    echo ("lightXAvailableSpace ",lightXAvailableSpace);
    echo ("lightXTotalSpace ",lightXTotalSpace);
    echo ("lightXSpacing ",lightXSpacing);
    
    echo ("------------------- Y --------------------");
    echo ("backPieceH ",backPieceH);
    echo ("lightYPadding ",lightYPadding);
    echo ("lightYCount ",lightYCount);
    echo ("lightYAvailableSpace ",lightYAvailableSpace);
    echo ("lightYTotalSpace ",lightYTotalSpace);
    
    color(flatui[3]) {
        // Bottom Row
        for (i=[1:lightXCount]) {
            lightX = lightXPadding + ((lightXSpacing + lightDiameter)*(i-1));
            translate([lightX, lightRadius + lightEdgeSpacing, 0]) {
                rotate([0, 0, 90]) {
                    lightBulb(bulb=showBulbs, cutout=showCutouts);
                }
            }
        }
        
        // Top Row
        for (i=[1:lightXCount]) {
            lightX = lightXPadding + ((lightXSpacing + lightDiameter)*(i-1));
            translate([lightX, backPieceH - (lightRadius + lightXSpacing), 0]) {
                rotate([0, 0, 90]) {
                    lightBulb(bulb=showBulbs, cutout=showCutouts);
                }
            }
        }
        
        // Left Row
        for (i=[1:lightYCount]) {
            lightY = lightYPadding + ((lightYSpacing + lightDiameter)*(i-1));
            translate([lightRadius + lightEdgeSpacing, lightY, 0]) {
                lightBulb(bulb=showBulbs, cutout=showCutouts);
            }
        }
        
        // Right Row
        for (i=[1:lightYCount]) {
            lightY = lightYPadding + ((lightYSpacing + lightDiameter)*(i-1));
            translate([backPieceW - (lightRadius + lightEdgeSpacing), lightY, 0]) {
                lightBulb(bulb=showBulbs, cutout=showCutouts);
            }
        }

        // Bottom Left Corner        
        bottomLeftPosition = ((cornerCutW/2) + 5) + 12;
        translate([bottomLeftPosition, bottomLeftPosition, 0]) {
            rotate([0,0,45]) {
                lightBulb(bulb=showBulbs, cutout=showCutouts);
            }
        }
        
        // Bottom Right Corner
        bottomRightPosition = backPieceW - ((cornerCutW/2) + 5) - 12;
        translate([bottomRightPosition, bottomLeftPosition, 0]) {
            rotate([0,0,-45]) {
                lightBulb(bulb=showBulbs, cutout=showCutouts);
            }
        }
        
        // Top Right Corner
        topRightPosition = backPieceH - ((cornerCutW/2) + 5) - 12;
        translate([bottomRightPosition, topRightPosition, 0]) {
            rotate([0,0,45]) {
                lightBulb(bulb=showBulbs, cutout=showCutouts);
            }
        }
        
        // Top Left Corner
        translate([bottomLeftPosition, topRightPosition, 0]) {
            rotate([0,0,-45]) {
                lightBulb(bulb=showBulbs, cutout=showCutouts);
            }
        }
    }
}

module shelvePiece(cutout=true) {
    shelfDepth = 15;
    shelfTeethDepth = 3;
    teethHeight = cutout ? 20 : pieceThickness;
    
    difference() {
        union() {
            cube([pieceThickness, shelfDepth, wallHeight - 10]);
            
            translate([0, shelfDepth - shelfTeethDepth, -teethHeight]) {
                cube([pieceThickness, shelfTeethDepth, teethHeight+1]);
            }
        }
        
        translate([-pieceThickness, -1, (wallHeight/2) - 4]) {
            cube([pieceThickness * 3, 3 + 1, 8]);
        }
        
        translate([(pieceThickness / 2), (shelfDepth/2)-2, 0]) {
            rotate([0, 0, 90]) {
                createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
            }
        }
    }
    
    if (cutout) {
        translate([(pieceThickness / 2), (shelfDepth/2)-2, 0]) {
            rotate([0, 0, 90]) {
                createTJoint(th=teethHeight, bD=5.5, bH=2.5, sD=3.4, sL=7);
            }
        }
    }
}

module leftRightShelvePieces(cutout = true) {
    steps = leftRightY / 3;
    numberOfShelves = 2;
    for (i=[1:numberOfShelves]) {
        // First piece is half a quarter
        translate([pieceThickness, steps * i, pieceThickness]) {
            rotate([0, 0, -90]) {
                shelvePiece(cutout=cutout);
            }
        }
    }
}

module leftRightShelves(cutout=true) {
    translate([insetSize, leftRightInsetY, 0]) {
        leftRightShelvePieces(cutout=cutout);
    }
}

module topBottomShelvePieces(cutout=true) {
    quarterSteps = topBottomWallX / 4;
    numberOfShelves = 4;
    for (i=[1:numberOfShelves]) {
        // First piece is half a quarter
        translate([(quarterSteps / 2) + (quarterSteps * (i-1)), pieceThickness, pieceThickness]) {
            shelvePiece(cutout=cutout);
        }
    }
}

module topBottomShelves(cutout=true) {
    translate([topBottomInsetX, insetSize, 0]) {
        topBottomShelvePieces(cutout=cutout);
    }
}

module layoutPieces() {
    translate([0, 0, -(pieceThickness/2)]) {
        backPiece();
    }
    rotate([90, 0, 0]) {
        cornerWall();
    }
    
    translate([-30, 20, -(pieceThickness/2)]) {
        rotate([90, 0, 0]) {
            rotate([0, 0, 90]) {
                shelvePiece(cutout=false);
            }
        }
    }
    
    translate([-60, 40, 0]) {
        rotate([0, 90, 0]) {
            leftRightWall(forTeethRemoval=false);
        }
    }
    
    translate([30, -30, 0]) {
        rotate([90, 0, 0]) {
            topBottomWall(forTeethRemoval=false);
        }
    }
}

// debug_lightCornerMarkers();

$fn=20;

module displayProjection() {
    // layoutPieces();
    projection() {
        layoutPieces();
    }
}

module displayModel() {
    backPiece();
    // topBottomShelves(cutout=false);
    // leftRightShelves(cutout=false);
    innerWall();
    lights(showBulbs=true, showCutouts=false);
}

displayModel = false;
if (displayModel == true) {
    // topBottomWall(forTeethRemoval=false);
    displayModel();
} else {
    displayProjection();
}