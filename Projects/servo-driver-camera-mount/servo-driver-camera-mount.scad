/**
       Copyright 2016 Matthew Gaunt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/

servoWidth = 62.23;
servoHeight = 25.4;
servoDepth = 15;

m3ClearanceHole = 3.4;
m25ClearanceHole = 2.9;
m2ClearanceDiameter = 2.4;

tjointInset = 3;
teethWidth = 10;

// Pan Tilt
panTiltBaseWidth = 33;
panTiltBaseDepth = 37;
panTiltBaseHeight = 3;
panTiltHoleWidth = 30 - m2ClearanceDiameter;
panTiltHoleDepth = 34 - m2ClearanceDiameter;

caseWidth = 76;
caseDepth = 56;
caseHeight = 32;
acrylicThickness = 3;

dcBarrelDiameter = 7.8;
dcBarrelDepth = 13 + acrylicThickness;
dcBarrelOuterDiameter = 10;
dcBarrelExtraSpace = (dcBarrelOuterDiameter - dcBarrelDiameter) + 2;

module servoDriverScrewHoles(holeDepth = 15) {
    translate([3.175, 3.175, 0]) {
        cylinder(h = holeDepth, d=m25ClearanceHole);
    }
    
    translate([59.055, 3.175, 0]) {
        cylinder(h = holeDepth, d=m25ClearanceHole);
    }
    
    translate([59.055, 22.225, 0]) {
        cylinder(h = holeDepth, d=m25ClearanceHole);
    }
    
    translate([3.175, 22.225, 0]) {
        cylinder(h = holeDepth, d=m25ClearanceHole);
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
                
                /**translate([
                    ((caseWidth - panTiltBaseWidth) / 4),
                    (caseDepth / 3) * 2,
                    0]) {
                    cube([2, (caseDepth / 3), acrylicThickness + 4]);
                }**/
            }
        }
        
        allTopTJoints(true);
        shortSides();
        longSideFront();
        longSideBack();
        
        cableHole = 9;
        translate([
        (cableHole / 2) + (m25ClearanceHole / 2) + ((caseWidth - servoWidth) / 2) + m25ClearanceHole, 
        m25ClearanceHole + ((caseDepth - servoHeight) / 2),
        caseHeight]) {
            cylinder(h=acrylicThickness * 3, d=cableHole);
        }
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
        
        allBaseTJoints(true);
        shortSides();
        longSideFront();
        longSideBack();
    }
}

module shortSide() {
    cube([acrylicThickness, caseDepth - (tjointInset * 2), caseHeight]);
    
    shortTeethWidth = teethWidth / 2;
    
    // Top Teeth
    translate([0, ((caseDepth - (tjointInset * 2)) / 4) - (shortTeethWidth / 2), caseHeight]) {
        cube([acrylicThickness, shortTeethWidth, acrylicThickness]);
    }
    
    translate([0, ((3 * (caseDepth - (tjointInset * 2)) / 4)) - (shortTeethWidth / 2), caseHeight]) {
        cube([acrylicThickness, shortTeethWidth, acrylicThickness]);
    }
    
    // Bottom Teeth
    translate([0, ((caseDepth - (tjointInset * 2)) / 4) - (shortTeethWidth / 2), -acrylicThickness]) {
        cube([acrylicThickness, shortTeethWidth, acrylicThickness]);
    }
    
    translate([0, ((3 * (caseDepth - (tjointInset * 2)) / 4)) - (shortTeethWidth / 2), -acrylicThickness]) {
        cube([acrylicThickness, shortTeethWidth, acrylicThickness]);
    }
}

module shortSideFront() {
    difference() {
        translate([tjointInset, tjointInset, acrylicThickness]) {
            shortSide();        
        }
        allBaseTJoints(true);
        allTopTJoints(true);
        
        longSideFront();
        longSideBack();
    }
}

module shortSideBack() {
    difference() {
        translate([caseWidth - acrylicThickness - tjointInset, tjointInset, acrylicThickness]) {
            shortSide();
        }
        allBaseTJoints(true);
        allTopTJoints(true);
        
        longSideFront();
        longSideBack();
    }
}

module shortSides() {
    shortSideFront();
    shortSideBack();
}

module longSide(isBackSide = false) {
    cube([caseWidth - (tjointInset * 2), acrylicThickness, caseHeight]);
            
    // Top Teeth
    if (isBackSide) {
        shortToothWidth = teethWidth / 2;
        translate([((caseWidth - (tjointInset * 2)) / 4), 0, caseHeight]) {
            cube([shortToothWidth, acrylicThickness, acrylicThickness]);
        }
    } else {
        translate([((caseWidth - (tjointInset * 2)) / 4) - (teethWidth / 2), 0, caseHeight]) {
            cube([teethWidth, acrylicThickness, acrylicThickness]);
        }
    }
    
    translate([((3 * (caseWidth - (tjointInset * 2)) / 4)) - (teethWidth / 2), 0, caseHeight]) {
        cube([teethWidth, acrylicThickness, acrylicThickness]);
    }
            
    // Bottom Teeth
    translate([((caseWidth - (tjointInset * 2)) / 4) - (teethWidth / 2), 0, -acrylicThickness]) {
        cube([teethWidth, acrylicThickness, acrylicThickness]);
    }
    
    translate([((3 * (caseWidth - (tjointInset * 2)) / 4)) - (teethWidth / 2), 0, -acrylicThickness]) {
        cube([teethWidth, acrylicThickness, acrylicThickness]);
    }
}

module longSideFront() {
    difference() {
        translate([tjointInset, tjointInset, acrylicThickness]) {
            longSide();
        }
        
        allBaseTJoints(true);
        allTopTJoints(true);
        
        // Side Teeth
        translate([tjointInset,tjointInset, ((caseHeight - teethWidth) / 2) + acrylicThickness])    {
            cube([acrylicThickness, acrylicThickness, teethWidth]);
        }
        
        translate([caseWidth - tjointInset - tjointInset,tjointInset, ((caseHeight - teethWidth) / 2) + acrylicThickness])    {
            cube([acrylicThickness, acrylicThickness, teethWidth]);
        }
    }
}

module longSideBack() {
    difference() {
        translate([tjointInset, caseDepth - acrylicThickness - tjointInset, acrylicThickness]) {
            longSide(false);
        }
        allBaseTJoints(true);
        allTopTJoints(true);
        
        // Side Teeth
        translate([tjointInset, caseDepth - tjointInset * 2, ((caseHeight - teethWidth) / 2) + acrylicThickness])    {
            cube([acrylicThickness, acrylicThickness, teethWidth]);
        }
        
        translate([caseWidth - tjointInset - tjointInset,caseDepth - tjointInset * 2, ((caseHeight - teethWidth) / 2) + acrylicThickness])    {
            cube([acrylicThickness, acrylicThickness, teethWidth]);
        }
        
        // DC Barrel
        translate([(3 * ((caseWidth - (tjointInset * 2)) / 4)) + tjointInset, caseDepth - tjointInset, caseHeight - acrylicThickness - dcBarrelExtraSpace]) {
        rotate([90, 0, 0]) {
            cylinder(h=dcBarrelDepth, d=dcBarrelDiameter);
        }
    }
    }
}

module createTJoint(materialThickness, boltWidth, boltHeight, nutWidth, nutHeight, isCutOut = false, endspacing = 2) {
    cutOutThickness = isCutOut ? (materialThickness * 2) : materialThickness;
    paddingDiscount = isCutOut ? (materialThickness / 2) : 0;
    translate([-(boltWidth / 2), 0, 0]) {
        translate([(boltWidth / 2) - (nutWidth / 2), -paddingDiscount, 0]) {
            cube([nutWidth, cutOutThickness, nutHeight]);
        }
        
        translate([0, -paddingDiscount, nutHeight - endspacing - boltHeight]) {
            cube([boltWidth, cutOutThickness, boltHeight]);
        }
    }
    
    translate([0, (materialThickness / 2), -materialThickness]) {
        cylinder(materialThickness, d=nutWidth, true);
    }
}

module allBaseTJoints(isCutOut = false) {
    translate([acrylicThickness + tjointInset, caseDepth / 2, acrylicThickness]) {
        rotate([0, 0, 90]) {
            createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7, isCutOut);
        }
    }
    
    translate([caseWidth - tjointInset, caseDepth / 2, acrylicThickness]) {
        rotate([0, 0, 90]) {
            createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7, isCutOut);
        }
    }
    
    translate([caseWidth / 2, tjointInset, acrylicThickness]) {
        createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7, isCutOut);
    }
    
    translate([caseWidth / 2, caseDepth-acrylicThickness - tjointInset, acrylicThickness]) {
        createTJoint(acrylicThickness, 5.5, 2.5, m3ClearanceHole, 7, isCutOut);
    }
}

module allTopTJoints(isCutOut = false) {
    translate([0, 0, acrylicThickness + caseHeight + acrylicThickness]) {
        mirror([0, 0, 1]) {
            allBaseTJoints(isCutOut);
        }
    }
}

module printProjection() {
    currentY = 0;
    padding = 5;
    projection(cut = false) {
        baseLayer();
        translate([0,caseDepth + padding,0]) {
            topLayer();
        }
        
        translate([0,caseDepth + padding + caseDepth + padding,0]) {
            rotate([-90, 0, 0]) {
                longSideFront();
            }
        }
        
        translate([0,caseDepth + padding + caseDepth + padding + caseHeight + acrylicThickness * 2 + padding,0]) {
            rotate([-90, 0, 0]) {
                longSideBack();
            }
        }
        
        translate([0, caseDepth + padding + caseDepth + padding + caseHeight + acrylicThickness * 2 + padding + caseHeight + acrylicThickness * 2 + padding ]) {
            rotate([0, 90, 0]) {
                shortSideFront();
            }
        }
        
        translate([caseHeight + padding + acrylicThickness * 2, caseDepth + padding + caseDepth + padding + caseHeight + acrylicThickness * 2 + padding + caseHeight + acrylicThickness * 2 + padding ]) {
            rotate([0, 90, 0]) {
                shortSideBack();
            }
        }
    }
}

module printModel() {
    baseLayer();
    topLayer();

    //shortSides();
    //longSideFront();
    //longSideBack();
}

printProjection();
//printModel();
