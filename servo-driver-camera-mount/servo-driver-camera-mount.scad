servoWidth = 62.23;
servoHeight = 25.4;
servoDepth = 15;

m3ClearanceHole = 3.4;
m2ClearanceDiameter = 2.4;

tjointInset = 3;

// Pan Tilt
panTiltBaseWidth = 33;
panTiltBaseDepth = 37;
panTiltBaseHeight = 3;
panTiltHoleWidth = 26;
panTiltHoleDepth = 30;

caseWidth = 76;
caseDepth = 49;
caseHeight = 20;
acrylicThickness = 3;

module servoDriverScrewHoles(holeDepth = 15) {
    translate([3.175, 3.175, 0]) {
        cylinder(h = holeDepth, d1=m3ClearanceHole, d2=m3ClearanceHole);
    }
    
    translate([59.055, 3.175, 0]) {
        cylinder(h = holeDepth, d1=m3ClearanceHole, d2=m3ClearanceHole);
    }
    
    translate([59.055, 22.225, 0]) {
        cylinder(h = holeDepth, d1=m3ClearanceHole, d2=m3ClearanceHole);
    }
    
    translate([3.175, 22.225, 0]) {
        cylinder(h = holeDepth, d1=m3ClearanceHole, d2=m3ClearanceHole);
    }
}

module servoDriver() {
    cube([servoWidth, servoHeight, servoDepth]);
    
    servoDriverScrewHoles();
}

module squareHoles(cylinderHeight, holeWidth, holeDepth) {
    translate([0, 0, 0]) {
        cylinder(h=cylinderHeight, d1=m2ClearanceDiameter, d2=m2ClearanceDiameter);
    }
    
    translate([holeWidth, 0, 0]) {
        cylinder(h=cylinderHeight, d1=m2ClearanceDiameter, d2=m2ClearanceDiameter);
    }
    
    translate([0, holeDepth, 0]) {
        cylinder(h=cylinderHeight, d1=m2ClearanceDiameter, d2=m2ClearanceDiameter);
    }
    
    translate([holeWidth, holeDepth, 0]) {
        cylinder(h=cylinderHeight, d1=m2ClearanceDiameter, d2=m2ClearanceDiameter);
    }
}

module panTiltHoles(holeDepth = panTiltBaseHeight) {
    translate([(panTiltBaseWidth - panTiltHoleWidth) / 2, (panTiltBaseDepth - panTiltHoleDepth) / 2, 0]) {
        squareHoles(holeDepth, panTiltHoleWidth, panTiltHoleDepth);
    }
}

module panTiltBase() {
    difference() {
        cube([panTiltBaseWidth, panTiltBaseDepth, panTiltBaseHeight]);
        panTileHoles();
    }
}

module topLayer() {
    difference() {
        translate([0, 0, caseHeight + acrylicThickness]) {
            difference() {
                cube([caseWidth, caseDepth, acrylicThickness]);
                
                translate([
                    (caseWidth - panTiltBaseWidth) / 2,
                    (caseDepth - panTiltBaseDepth) / 2,
                    -2]) {
                    panTiltHoles(acrylicThickness + 4);
                }
                
                translate([
                    ((caseWidth - panTiltBaseWidth) / 4),
                    (caseDepth / 3) * 2,
                    0]) {
                    cube([2, (caseDepth / 3), acrylicThickness + 4]);
                }
            }
        }
        
        allTopTJoints();
    }
}

module baseLayer() {
    difference() {
        cube([caseWidth, caseDepth, acrylicThickness]);
        
        translate([
            (caseWidth - servoWidth) / 2,
            (caseDepth - servoHeight) / 2,
            -2]) {
            servoDriverScrewHoles(acrylicThickness + 4);
        }
        
        allBaseTJoints();
    }
}

module shortSides() {
    difference() {
        translate([tjointInset, tjointInset, acrylicThickness]) {
            cube([acrylicThickness, caseDepth - (tjointInset * 2), caseHeight]);        
        }
        allBaseTJoints();
        allTopTJoints();
    }
    
    difference() {
        translate([caseWidth - acrylicThickness - tjointInset, tjointInset, acrylicThickness]) {
            cube([acrylicThickness, caseDepth - (tjointInset * 2), caseHeight]);
        }
        allBaseTJoints();
        allTopTJoints();
    }
}

module longSides() {
    difference() {
        translate([tjointInset, tjointInset, acrylicThickness]) {
            cube([caseWidth - (tjointInset * 2), acrylicThickness, caseHeight]);
        }
        allBaseTJoints();
        allTopTJoints();
    }
    
    difference() {
        translate([tjointInset, caseDepth - acrylicThickness - tjointInset, acrylicThickness]) {
            cube([caseWidth - (tjointInset * 2), acrylicThickness, caseHeight]);
        }
        allBaseTJoints();
        allTopTJoints();
    }
}

module createTJoint(materialThickness, boltWidth, boltHeight, nutWidth, nutHeight, endspacing = 2) {
    translate([-(boltWidth / 2), 0, 0]) {
        translate([(boltWidth / 2) - (nutWidth / 2), 0, 0]) {
            cube([nutWidth, materialThickness, nutHeight]);
        }
        
        translate([0, 0, nutHeight - endspacing - boltHeight]) {
            cube([boltWidth, materialThickness, boltHeight]);
        }
    }
    
    translate([0, (materialThickness / 2), -materialThickness]) {
        cylinder(materialThickness, d=nutWidth, true);
    }
}

module allBaseTJoints() {
    translate([acrylicThickness + tjointInset, caseDepth / 2, acrylicThickness]) {
        rotate([0, 0, 90]) {
            createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7);
        }
    }
    
    translate([caseWidth - tjointInset, caseDepth / 2, acrylicThickness]) {
        rotate([0, 0, 90]) {
            createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7);
        }
    }
    
    translate([caseWidth / 2, tjointInset, acrylicThickness]) {
        createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7);
    }
    
    translate([caseWidth / 2, caseDepth-acrylicThickness - tjointInset, acrylicThickness]) {
        createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7);
    }
}

module allTopTJoints() {
    translate([0, 0, acrylicThickness + caseHeight + acrylicThickness]) {
        mirror([0, 0, 1]) {
            allBaseTJoints();
        }
    }
}

baseLayer();
topLayer();

shortSides();
longSides();