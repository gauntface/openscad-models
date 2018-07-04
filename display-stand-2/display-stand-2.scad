/**
Configuration variables
**/
materialThicknessMM = 3;

noOfShelves = 3;
shelfDepthMM = 30;
shelfHeightMM = 40;
shelfWidthMM = 200;
shelfLipHeightMM = 10;

shelfSidePaddingMM = 6;
shelfBackPaddingMM = 30;
shelfFrontPaddingMM = 6;

colorAlpha = 1;

debug = true;
debugColor = [111/255, 30/255, 81/255, 0.4];

module shelfMarker() {
    triangleDepth = shelfDepthMM;
    triangleHeight = shelfHeightMM;
    triangleWidth = shelfWidthMM;
    
    color(debugColor) createTriangle(triangleDepth, triangleWidth, triangleHeight);
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

module printDebug() {
    if (debug) {
        shelfMarkers();
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

module base() {
    color([18/255, 203/255, 196/255]) cube([shelfDepthMM, shelfWidthMM, materialThicknessMM]);
}

module bases() {
    for (i = [1 : noOfShelves]) {
        xOffset = (noOfShelves - i) * shelfDepthMM;
        zOffset = (i - 1) * shelfHeightMM;
        translate([xOffset, 0, zOffset]) {
            base();
        }
    }
}


module lip() {
    color([6/255, 82/255, 221/255]) cube([materialThicknessMM, shelfWidthMM, shelfLipHeightMM]);
}

module lips() {
    for (i = [1 : noOfShelves]) {
        xOffset = ((noOfShelves - i + 1) * shelfDepthMM) - materialThicknessMM;
        zOffset = (i - 1) * shelfHeightMM;
        translate([xOffset, 0, zOffset]) {
            lip();
        }
    }
}



module sideMarker() {
    translate([10, shelfWidthMM / 2, 0]) {
    createTriangle(shelfDepthMM * noOfShelves, 1, shelfHeightMM * noOfShelves);
    }
}

printDebug();

bases();
lips();
sideMarker();