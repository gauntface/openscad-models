/**
Configuration variables
**/
materialThicknessMM = 3;

noOfShelf = 3;
shelfDepthMM = 30;
shelfHeightMM = 40;
shelfWidthMM = 200;
shelfLipHeightMM = 10;

shelfSidePaddingMM = 6;
shelfBackPaddingMM = 30;
shelfFrontPaddingMM = 6;

colorAlpha = 1;

/**
Generate variables (DO NOT TOUCH)
**/
fullShelfDepth = (shelfDepthMM * noOfShelf) + shelfBackPaddingMM;
fullShelfWidth = shelfWidthMM + (shelfSidePaddingMM * 2);
leftSideY = -(fullShelfWidth / 2) + shelfSidePaddingMM;
rightSideY = (fullShelfWidth / 2) - shelfSidePaddingMM;

module sidePiece() {
  translate([0, -(materialThicknessMM / 2), 0]) {
  color([10 / 255, 189 / 255, 227 / 255, colorAlpha]) polyhedron (
    points = [
        [0, 0, 0],
        [fullShelfDepth + materialThicknessMM + shelfFrontPaddingMM, 0, 0],
        [fullShelfDepth + materialThicknessMM + shelfFrontPaddingMM, 0, materialThicknessMM + shelfLipHeightMM],
        [materialThicknessMM + shelfFrontPaddingMM + shelfBackPaddingMM, 0, (shelfHeightMM * noOfShelf) + shelfLipHeightMM + materialThicknessMM],
        [0, 0, (shelfHeightMM * noOfShelf) + shelfLipHeightMM + materialThicknessMM],
    
        [0, materialThicknessMM, 0],
        [fullShelfDepth + materialThicknessMM + shelfFrontPaddingMM, materialThicknessMM, 0],
        [fullShelfDepth + materialThicknessMM + shelfFrontPaddingMM, materialThicknessMM, materialThicknessMM + shelfLipHeightMM],
        [materialThicknessMM + shelfFrontPaddingMM + shelfBackPaddingMM, materialThicknessMM, (shelfHeightMM * noOfShelf) + shelfLipHeightMM + materialThicknessMM],
        [0, materialThicknessMM, (shelfHeightMM * noOfShelf) + shelfLipHeightMM + materialThicknessMM],
    ],
    faces = [
        [0, 4, 3, 2, 1], // Left side
        [5, 9, 4, 0], // Back face
        [0, 1, 6, 5], // Bottom face
        [1, 2, 7, 6], // Front face
        [2, 3, 8, 7], // Angle front face
        [3, 4, 9, 8], // Top face
        [5, 6, 7, 8, 9], // Right side
    ]
  );
  }
}

module positionSides() {
    translate([0, leftSideY, 0]) {
        sidePiece();
    }

    translate([0, rightSideY, 0]) {
        sidePiece();
    }
}

module shelfBaseTrackAtLevel(level) {
    cutoutX = fullShelfDepth - (shelfDepthMM / 2) - (level * shelfDepthMM);
    cutoutZ = (level * shelfHeightMM);
    
    cutoutWidth = materialThicknessMM * 3;
    translate([cutoutX, leftSideY - (cutoutWidth / 2), cutoutZ]) {
        color([1, 0, 0, 0]) cube([fullShelfDepth, cutoutWidth, materialThicknessMM]);
    }
    
    translate([cutoutX, rightSideY - (cutoutWidth / 2), cutoutZ]) {
        color([1, 0, 0, 0]) cube([fullShelfDepth, cutoutWidth, materialThicknessMM]);
    }
}

module shelfBackTrackAtLevel(level) {
    cutoutX = fullShelfDepth - (level * shelfDepthMM);
    cutoutZ = materialThicknessMM + shelfLipHeightMM + ((level + 1) * shelfHeightMM) - ((shelfHeightMM + shelfLipHeightMM) / 2);
    cutoutZ = level * shelfHeightMM;
    
    cutoutWidth = materialThicknessMM * 3;
    translate([cutoutX, leftSideY - (cutoutWidth / 2), cutoutZ]) {
        color([1, 0, 0, 1]) cube([materialThicknessMM, cutoutWidth, fullShelfDepth]);
    }
    
    translate([cutoutX, rightSideY - (cutoutWidth / 2), cutoutZ]) {
        color([1, 0, 0, 1]) cube([materialThicknessMM, cutoutWidth, fullShelfDepth]);
    }
}

module sides() {
    difference() {
      positionSides();
       
       for (i = [0 : noOfShelf - 1]) {
            shelfBaseTrackAtLevel(i);
            shelfBackTrackAtLevel(i);
       }
   } 
}
 
module shelfBase() {
    difference() {
        color([95 / 255, 39 / 255, 205 / 255, colorAlpha]) cube([shelfDepthMM + materialThicknessMM, fullShelfWidth, materialThicknessMM]);
        
        translate([-materialThicknessMM ,shelfSidePaddingMM - (materialThicknessMM / 2), -materialThicknessMM]) {
            color([255 / 255, 159 / 255, 243 / 255, 0]) cube([(shelfDepthMM / 2) + materialThicknessMM, materialThicknessMM, materialThicknessMM * 3]);
        }
        
        translate([- materialThicknessMM, fullShelfWidth - shelfSidePaddingMM - (materialThicknessMM / 2), -materialThicknessMM]) {
            color([255 / 255, 159 / 255, 243 / 255, 0]) cube([(shelfDepthMM / 2) + materialThicknessMM, materialThicknessMM, materialThicknessMM * 3]);
        }
    }
}

module shelfBaseAtLevel(level) {
    shelfX = fullShelfDepth - shelfDepthMM - (level * shelfDepthMM);
    shelfY = -(fullShelfWidth / 2);
    shelfZ = (level * shelfHeightMM);
    
    translate([shelfX, shelfY, shelfZ]) {
        shelfBase();
    }
}

module shelfBases() {
    for (i = [0 : noOfShelf - 1]) {
        shelfBaseAtLevel(i);
    }
}

module shelfBack(shelfHeight) {
    difference() {
        color([255 / 255, 159 / 255, 67 / 255, colorAlpha]) cube([materialThicknessMM, fullShelfWidth, shelfHeight]);
        
        translate([-materialThicknessMM ,shelfSidePaddingMM - (materialThicknessMM / 2), -materialThicknessMM]) {
                color([255 / 255, 159 / 255, 243 / 255, 0]) cube([materialThicknessMM * 3, materialThicknessMM, (shelfHeight / 2) + materialThicknessMM]);
            }
            
        translate([- materialThicknessMM, fullShelfWidth - shelfSidePaddingMM - (materialThicknessMM / 2), -materialThicknessMM]) {
                color([255 / 255, 159 / 255, 243 / 255, 0]) cube([materialThicknessMM * 3, materialThicknessMM, (shelfHeight / 2) + materialThicknessMM]);
            }
        }
}

module shelfBackAtLevel(level) {
    shelfX = fullShelfDepth - (level * shelfDepthMM);
    if (level > 0) {
        shelfZ = ((level - 1) * shelfHeightMM);
        translate([shelfX, -(fullShelfWidth / 2), shelfZ + materialThicknessMM]) {
            shelfBack(shelfLipHeightMM + shelfHeightMM);
        }
    } else {
        shelfZ = 0;
        translate([shelfX, -(fullShelfWidth / 2), shelfZ + materialThicknessMM]) {
            shelfBack(shelfLipHeightMM);
        }
    }
}

module shelfBacks() {
    for (i = [0 : noOfShelf]) {
        shelfBackAtLevel(i);
    }
}

sides();
shelfBases();
// shelfBacks();

// Shelf front
/* translate([fullShelfDepth, -(fullShelfWidth / 2), 0]) {
    color([255 / 255, 159 / 255, 67 / 255, colorAlpha]) cube([materialThicknessMM, fullShelfWidth, materialThicknessMM + shelfLipHeightMM]);
}*/
