/**
Configuration variables
**/
materialThicknessMM = 3;

noOfShelves = 3;
shelfDepthMM = 30;
shelfHeightMM = 40;
shelfWidthMM = 200;

shelfLipHeightMM = 12;
lipTrackThicknessMM = 5;

slideEdgeSizeMM = 6;
noOfShelfTeeth = 7;

backPlateHeightMM = 24;

unitBaseHeightMM = 6;
unitBackDepthMM = 12;

colorAlpha = 1;

debug = true;
debugColor = [111/255, 30/255, 81/255, 0.4];

/**
DO NOT EDIT THESE VALUES
**/
shelfAngle = atan(shelfHeightMM / shelfDepthMM);
sideIndentX = shelfLipHeightMM / tan(shelfAngle);
frontExtensionMM = (shelfLipHeightMM-materialThicknessMM) / tan(shelfAngle);

module shelfMarker() {
    triangleDepth = shelfDepthMM;
    triangleHeight = shelfHeightMM;
    triangleWidth = shelfWidthMM;
    
    createTriangle(triangleDepth, triangleWidth, triangleHeight);
}

module shelfMarkers() {
    for (i = [1 : noOfShelves]) {
        xOffset = (noOfShelves - i) * shelfDepthMM;
        zOffset = (i - 1) * shelfHeightMM;
        translate([xOffset, 0, zOffset]) {
            shelfMarker();
        }
    }
}

module sideMarker() {
    translate([sideIndentX, shelfWidthMM / 2, 0]) {
    createTriangle(shelfDepthMM * noOfShelves, 1, shelfHeightMM * noOfShelves);
    }
}

module printDebug() {
    if (debug) {
        color(debugColor) shelfMarkers();
        color(debugColor) sideMarker();
    }
}


module createTriangle(triangleDepth, triangleWidth, triangleHeight) {
    polyhedron(
        points = [
            /* Top Left    0 */ [0, 0, triangleHeight],
            /* Front Left  1 */ [triangleDepth, 0, 0], 
            /* Back Left   2 */ [0, 0, 0],
            /* Top Right   3 */ [0, triangleWidth, triangleHeight],
            /* Front Right 4 */ [triangleDepth, triangleWidth, 0],
            /* Back Right  5 */ [0, triangleWidth, 0],
        ],
        faces = [
            /* Left Face   */ [0, 1, 2],
            /* Right Face  */ [5, 4, 3],
            /* Bottom Face */ [2, 1, 4, 5],
            /* Back Face   */ [3, 0, 2, 5],
            /* Front Face  */ [0, 3, 4, 1],
        ]
    );
}

module createTeeth(on, width, noOfTeeth, flatPiece) {
    toothWidth = width / noOfTeeth;
    for (i = [0 : noOfTeeth - 1]) {
        if (on && i % 2 == 0) {
        translate([-materialThicknessMM, toothWidth * i, -materialThicknessMM]) {
        if (flatPiece) {
            cube([materialThicknessMM * 2, toothWidth, materialThicknessMM * 3]);
        } else {
            cube([materialThicknessMM * 3, toothWidth, materialThicknessMM * 2]);
        }
        }
        } else if (on == false && i % 2 == 1) {
        translate([-materialThicknessMM, toothWidth * i, -materialThicknessMM]) {
        if (flatPiece) {
            cube([materialThicknessMM * 2, toothWidth, materialThicknessMM * 3]);
        } else {
            cube([materialThicknessMM * 3, toothWidth, materialThicknessMM * 2]);
        }
        }
        }
    }
}

module base() {
    halfShelfDepth = shelfDepthMM / 2;
    
    difference() {
    
    union() {
    cube([shelfDepthMM + frontExtensionMM, shelfWidthMM, materialThicknessMM]);
    
    // Left slide path
    translate([halfShelfDepth, -materialThicknessMM, 0]) {
    cube([halfShelfDepth + frontExtensionMM, materialThicknessMM, materialThicknessMM]);
    }
    
    // Right slide path
    translate([halfShelfDepth, shelfWidthMM, 0]) {
    cube([halfShelfDepth + frontExtensionMM, materialThicknessMM, materialThicknessMM]);
    }
    
    // Left slide edge
    translate([0, -materialThicknessMM-slideEdgeSizeMM, 0]) {
    cube([shelfDepthMM + frontExtensionMM, slideEdgeSizeMM, materialThicknessMM]);
    }
    
    // Right slide edge
    translate([0, shelfWidthMM+materialThicknessMM, 0]) {
    cube([shelfDepthMM + frontExtensionMM, slideEdgeSizeMM, materialThicknessMM]);
    }
    }
    
    // Create teeth in middle of shelf
    translate([shelfDepthMM, 0, 0]) {
    toothWidth = shelfWidthMM / noOfShelfTeeth;
    for (i = [0 : noOfShelfTeeth - 1]) {
        if (i % 2 == 1) {
        translate([-materialThicknessMM, toothWidth * i, -materialThicknessMM]) {
            cube([materialThicknessMM, toothWidth, materialThicknessMM * 3]);
        }
        }
    }
    }
    
    // Create left hole for lip
    translate([shelfDepthMM-materialThicknessMM, -materialThicknessMM-slideEdgeSizeMM/2, -materialThicknessMM]) {
    cube([materialThicknessMM, slideEdgeSizeMM/2, materialThicknessMM * 3]);
    }
    
    // Create right hole for lip
    translate([shelfDepthMM-materialThicknessMM, shelfWidthMM+materialThicknessMM, -materialThicknessMM]) {
    cube([materialThicknessMM, slideEdgeSizeMM/2, materialThicknessMM * 3]);
    }
    
    }
}

module bases() {    
    for (i = [1 : noOfShelves]) {
        xOffset = (noOfShelves - i) * shelfDepthMM;
        zOffset = (i - 1) * shelfHeightMM;
        translate([xOffset, 0, zOffset]) {
            color([18/255, 203/255, 196/255]) base();
        }
    }
}


module lip() {
    difference() {
    
    union() {
    cube([materialThicknessMM, shelfWidthMM, shelfLipHeightMM]);
    
    // Left slide path
    translate([0, -materialThicknessMM, shelfLipHeightMM - lipTrackThicknessMM]) {
    cube([materialThicknessMM, materialThicknessMM, lipTrackThicknessMM]);
    }
    
    // Right slide path
    translate([0, shelfWidthMM, shelfLipHeightMM - lipTrackThicknessMM]) {
    cube([materialThicknessMM, materialThicknessMM, lipTrackThicknessMM]);
    }
    
    // Left slide edge
    translate([0, -materialThicknessMM-slideEdgeSizeMM, 0]) {
    cube([materialThicknessMM, slideEdgeSizeMM, shelfLipHeightMM]);
    }
    
    // Right slide edge
    translate([0, shelfWidthMM + materialThicknessMM, 0]) {
    cube([materialThicknessMM, slideEdgeSizeMM, shelfLipHeightMM]);
    }
    }
    
    translate([0, 0, 0]) {
    createTeeth(true, shelfWidthMM, noOfShelfTeeth, false);
    }
    
    // Remove left indent
    translate([-materialThicknessMM, -materialThicknessMM-slideEdgeSizeMM-materialThicknessMM, -materialThicknessMM]) {
    cube([materialThicknessMM * 3, (slideEdgeSizeMM / 2) + materialThicknessMM, materialThicknessMM * 2]);
    }
    
    // Remove right indent
    translate([-materialThicknessMM, shelfWidthMM+materialThicknessMM+slideEdgeSizeMM-materialThicknessMM, -materialThicknessMM]) {
    cube([materialThicknessMM * 3, (slideEdgeSizeMM / 2) + materialThicknessMM, materialThicknessMM * 2]);
    }
    
    }
}

module lips() {
    for (i = [1 : noOfShelves]) {
        xOffset = ((noOfShelves - i + 1) * shelfDepthMM) - materialThicknessMM;
        zOffset = (i - 1) * shelfHeightMM;
        translate([xOffset, 0, zOffset]) {
            color([6/255, 82/255, 221/255]) lip();
        }
    }
}

module backPlate() {
    backPlateWidth = shelfWidthMM + (materialThicknessMM * 2) + (slideEdgeSizeMM * 2);
    fullHeight = shelfHeightMM * noOfShelves;
    
    difference() {
    
    translate([0, -materialThicknessMM-slideEdgeSizeMM, fullHeight - backPlateHeightMM]) {
    color([237/255, 76/255, 103/255]) cube([materialThicknessMM, backPlateWidth, backPlateHeightMM]);
    }
    
    // Left track to remove
    translate([-materialThicknessMM, -materialThicknessMM, fullHeight - (backPlateHeightMM * 1.5)]) {
    cube([materialThicknessMM*3, materialThicknessMM, backPlateHeightMM]);
    }
    
    // Right track to remove
    translate([-materialThicknessMM, shelfWidthMM, fullHeight - (backPlateHeightMM * 1.5)]) {
    cube([materialThicknessMM*3, materialThicknessMM, backPlateHeightMM]);
    }
    
    }
}

module side() {
    fullHeight = shelfHeightMM * noOfShelves;
    fullDepth = shelfDepthMM * noOfShelves;
    width = materialThicknessMM;
    
    difference() {
    
    union() {
    translate([sideIndentX, 0, 0]) {
    polyhedron(
        points = [
            /* Top Left    0 */ [0, 0, fullHeight],
            /* Front Left  1 */ [fullDepth, 0, 0], 
            /* Back Left   2 */ [0, 0, 0],
            /* Top Right   3 */ [0, width, fullHeight],
            /* Front Right 4 */ [fullDepth, width, 0],
            /* Back Right  5 */ [0, width, 0],
        ],
        faces = [
            /* Left Face   */ [0, 1, 2],
            /* Right Face  */ [5, 4, 3],
            /* Bottom Face */ [2, 1, 4, 5],
            /* Back Face   */ [3, 0, 2, 5],
            /* Front Face  */ [0, 3, 4, 1],
        ]
    );
    }
    
    cube([sideIndentX, materialThicknessMM, fullHeight]);
    
    // Base of the unit
    translate([0, 0, -unitBaseHeightMM]) {
    cube([fullDepth + frontExtensionMM, materialThicknessMM, unitBaseHeightMM]);
    }
    
    // Back of unit
    translate([-unitBackDepthMM, 0, -unitBaseHeightMM]) {
    cube([unitBackDepthMM, materialThicknessMM, fullHeight + unitBaseHeightMM]);
    }
    }
    
    // Cuts out the track for the base
    trackDepth = shelfDepthMM / 2;
    for (i = [1 : noOfShelves]) {
        trackZ = shelfHeightMM * (noOfShelves - i);
        translate([(shelfDepthMM * i) - trackDepth, -materialThicknessMM, trackZ]) {
        cube([trackDepth + sideIndentX, materialThicknessMM*3, materialThicknessMM]);
        }
    }
    
    // Cuts out the track for the lip
    trackHeight = lipTrackThicknessMM + sideIndentX;
    for (i = [1 : noOfShelves]) {
        trackZ = (shelfHeightMM * (noOfShelves - i)) + (shelfLipHeightMM - lipTrackThicknessMM);
        translate([(shelfDepthMM * i) - materialThicknessMM, -materialThicknessMM, trackZ]) {
        cube([materialThicknessMM, materialThicknessMM * 3, trackHeight]);
        }
    }
    
    translate([0, -materialThicknessMM, fullHeight - (backPlateHeightMM / 2)]) {
    cube([materialThicknessMM, materialThicknessMM * 3, backPlateHeightMM / 2]);
    }
    
    // Remove the tip of the front triangle
    translate([fullDepth + frontExtensionMM, -materialThicknessMM, 0]) {
    cube([fullDepth, materialThicknessMM * 3, fullHeight]);
    }
    
    }
}

module sides() {
    translate([0, -materialThicknessMM, 0]) {
    color([163/255, 203/255, 56/255]) side();
    }
    
    translate([0, shelfWidthMM, 0]) {
    color([163/255, 203/255, 56/255, 1]) side();
    }
}

// printDebug();

bases();
lips();
backPlate();
sides();