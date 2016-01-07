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

// Remember bit.ly/holesize

createTJoint(3, 5.5, 2.5, 3.4, 7);