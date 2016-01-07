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

module pillarBottomTriangle() {
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
        }
    }
}

module standPillar() {
    singlePillar();
    rotate([0, 0, 90]) {
        singlePillar();
    }
    
    standHook();
    
    rotate([0, 0, 180]) {
        standHook();
    }
}

module base() {
    cylinder(h=baseHeight, d1=baseDiameter, d2=baseDiameter);
}

standPillar();
base();