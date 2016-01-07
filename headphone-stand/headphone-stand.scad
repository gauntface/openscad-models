baseHeight = 6;
baseDiameter = 160;

pillarArcylicThickness = 6;
pillarWidth = 30;
pillarHeight = 240;
pillarBottomTriableHeight = 40;
pillarBottomTriableLength = 30;

hookHeight = 24;
hookLength = 40;
hookHeadphoneDent = 40;
hookEndLength = 20;
hookDentInsetHeight = 10;

module createTJoint(materialThickness, boltWidth, boltHeight, nutWidth, nutHeight, endspacing = 2) {
    translate([-(boltWidth / 2), 0, 0]) {
        translate([(boltWidth / 2) - (nutWidth / 2), 0, 0]) {
            color([0,0,1]) cube([nutWidth, materialThickness, nutHeight]);
        }
        
        translate([0, 0, nutHeight - endspacing - boltHeight]) {
            color([0,0,1]) cube([boltWidth, materialThickness, boltHeight]);
        }
    }
    
    translate([0, (materialThickness / 2), -materialThickness]) {
        color([0,1,0]) cylinder(materialThickness, d=nutWidth, true);
    }
}

module pillarTopTriangle() {
    translate([0, pillarArcylicThickness, 0]) {
        rotate([180, 0, 0]) {
            polyhedron (	
                points = [
                    [0, 0, pillarBottomTriableHeight],
                    [0, pillarArcylicThickness, pillarBottomTriableHeight],
                    [0, pillarArcylicThickness, 0],
                    [0, 0, 0],
                    [pillarBottomTriableLength, 0, 0],
                    [pillarBottomTriableLength, pillarArcylicThickness, 0]
                ],
                faces = [
                    [0,3,2],
                    [0,2,1],
                    [3,0,4],
                    [1,2,5],
                    [0,5,4],
                    [0,1,5],
                    [5,2,4],
                    [4,2,3]
                ]
            );
        }
    }
}

module pillarBottomTriangle(triangleThickness = pillarArcylicThickness) {
    color([1,0,0]) polyhedron (	
        points = [
            [0, 0, pillarBottomTriableHeight],
            [0, triangleThickness, pillarBottomTriableHeight],
            [0, triangleThickness, 0],
            [0, 0, 0],
            [pillarBottomTriableLength, 0, 0],
            [pillarBottomTriableLength, triangleThickness, 0]
        ],
		faces = [
            [0,3,2],
            [0,2,1],
            [3,0,4],
            [1,2,5],
            [0,5,4],
            [0,1,5],
            [5,2,4],
            [4,2,3]
        ]
    );
}

module singlePillar() {
    translate([-(pillarWidth / 2), -(pillarArcylicThickness / 2), baseHeight]) {
        union() {
            cube([pillarWidth, pillarArcylicThickness, pillarHeight]);
            
            translate([pillarWidth, 0, 0]) {
                pillarBottomTriangle();
            }
            
            translate([0, pillarArcylicThickness, 0]) {
                rotate([0, 0, 180]) {
                    pillarBottomTriangle();
                }
            }
            
            translate([(-pillarBottomTriableLength / 4), 0, -baseHeight]) {
                cube([(pillarWidth / 2) - (pillarArcylicThickness / 2), pillarArcylicThickness, baseHeight]);
            }
            
            translate([-pillarBottomTriableLength, 0, -baseHeight]) {
                cube([(pillarBottomTriableLength / 4), pillarArcylicThickness, baseHeight]);
            }
            
            translate([(pillarWidth / 2) + (pillarArcylicThickness / 2) + (pillarBottomTriableLength / 4), 0, -baseHeight]) {
                cube([(pillarWidth / 2) - (pillarArcylicThickness / 2), pillarArcylicThickness, baseHeight]);
            }
            
            translate([pillarWidth + pillarBottomTriableLength - (pillarBottomTriableLength / 4), 0, -baseHeight]) {
                cube([(pillarBottomTriableLength / 4), pillarArcylicThickness, baseHeight]);
            }
        }
    }
}

module standHook() {
    translate([pillarWidth / 2, -(pillarArcylicThickness / 2), pillarHeight + baseHeight - hookHeight]) {
        union() {
            cube([hookLength, pillarArcylicThickness, hookHeight]);
            
            translate([hookLength, 0, 0]) {
                cube([hookHeadphoneDent, pillarArcylicThickness, hookHeight - hookDentInsetHeight]);
            }
            
            translate([hookLength + hookHeadphoneDent, 0, 0]) {
                cube([hookEndLength, pillarArcylicThickness, hookHeight]);
            }
            
            translate([0, 0, 0]) {
                pillarTopTriangle();
            }
        }
    }
}

module standSupport() {
    rotate([0, 0, 90]) {
        difference() {
            singlePillar();
            translate([-(pillarArcylicThickness / 2), -(pillarArcylicThickness / 2), baseHeight + (pillarHeight / 2)]) {
                cube([pillarArcylicThickness, pillarArcylicThickness, (pillarHeight / 2)]);
            }
            
            translate([-pillarBottomTriableLength - (pillarArcylicThickness / 2), pillarArcylicThickness, baseHeight + pillarHeight]) {
                rotate([180, 0, 0]) {
                    pillarBottomTriangle(pillarArcylicThickness * 2);
                }
            }
    
            mirror([1, 0, 0]) {
             translate([-pillarBottomTriableLength - (pillarArcylicThickness / 2), pillarArcylicThickness, baseHeight + pillarHeight]) {
                rotate([180, 0, 0]) {
                    pillarBottomTriangle(pillarArcylicThickness * 2);
                }
            }
         }
      }
    }
}

module standPillar(withTjoints = true) {
    difference() {
        singlePillar();
        translate([-(pillarArcylicThickness / 2), -(pillarArcylicThickness / 2), baseHeight]) {
            cube([pillarArcylicThickness, pillarArcylicThickness, (pillarHeight / 2)]);
        }
        
        translate([(pillarWidth / 2) + (pillarBottomTriableLength / 2), -(pillarArcylicThickness / 2), 0]) {
            createTJoint(pillarArcylicThickness, 5.5, 2.5, 3.4, baseHeight + 2.5 + 1, 1);
        }
        
        translate([-(pillarWidth / 2) - (pillarBottomTriableLength / 2), -(pillarArcylicThickness / 2), 0]) {
            createTJoint(pillarArcylicThickness, 5.5, 2.5, 3.4, baseHeight + 2.5 + 1, 1);
        }
    }
    
    standHook();
    
    rotate([0, 0, 180]) {
        standHook();
    }
}

module base() {
    difference() {
        cylinder(h=baseHeight, d1=baseDiameter, d2=baseDiameter);
        
        standPillar();
        standSupport();
        
        translate([(pillarWidth / 2) + (pillarBottomTriableLength / 2), -(pillarArcylicThickness / 2), pillarArcylicThickness]) {
            createTJoint(pillarArcylicThickness, 5.5, 2.5, 3.4, 2.5 + 1, 1);
        }
        
        translate([-(pillarWidth / 2) - (pillarBottomTriableLength / 2), -(pillarArcylicThickness / 2), pillarArcylicThickness]) {
            createTJoint(pillarArcylicThickness, 5.5, 2.5, 3.4, 2.5 + 1, 1);
        }
    }
}

module render(projectionMode) {
    if (!projectionMode) {
        standPillar();
        standSupport();
        base();
    } else {
        projection(cut = false) {
            translate([0,0, (pillarArcylicThickness / 2)]) {
                rotate([-90, 0, 0]) {
                    standPillar();
                }
            }
            
            translate([(baseDiameter / 2) + (pillarWidth / 2) + 3, (baseDiameter / 2), 0]) {
                base();
            }
            
            translate([-(pillarBottomTriableLength * 2) - pillarWidth - 3, pillarHeight - hookHeight, 0]) {
                rotate([90, 0, 0]) {
                    rotate([0, 0, 90]) {
                        standSupport();
                    }
                }
            }
        }
    }
}

render(true);