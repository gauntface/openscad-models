include <../../libs/flat-ui-colors.scad>;
include <../../libs/teeth.scad>;
include <../../libs/t-joint.scad>;

thickness = 3;

caseInset = 4;

pieceDepth = 40;
pieceHeight = 60;
pieceWidth = 260;

speakerHeight = 31;
speakerWidth = 69.5;
speakerDepth = 18;

pcbHeight = 47;
pcbWidth = 113;

mountPlateInset = 21;
mountPlateWidth = 100;

ultrasonicHeight = 18;
ultrasonicPadding = 3;

controlPanelZ = pieceHeight - ultrasonicHeight - (ultrasonicPadding * 2);

powerSwitchWidth = 23;
powerSwitchHeight = 7.5;
powerSwitchBodyWidth=15.7;

magnetD = 10;
magnetDepth = 3;
magnetInset = 1;

powerPortD = 20.75;
powerPortNutD = 30;
powerPortExtD = 28;
powerPortHeight = 31;
powerCutoutW = powerPortNutD + 4;

pieceWTeethWidth = pieceWidth/20;
pieceWTeethCount = 8;

module topBackTeeth(z, nothing = 0) {
    translate([-(thickness/2), (pieceWidth/2), thickness/2])
        verticalTeeth(z, pieceWidth, thickness+nothing, 0, pieceWTeethCount, pieceWTeethWidth, thickness);
}

module topFrontTeeth(z, nothing = 0) {
    translate([pieceDepth+(thickness/2), (pieceWidth/2), thickness/2]) verticalTeeth(z, pieceWidth, thickness+nothing, 0, pieceWTeethCount, pieceWTeethWidth, thickness, nothing=0);
}

module topPiece() {
    difference() {
        union() {
            translate([0, 0, pieceHeight]) cube([pieceDepth, pieceWidth, thickness]);
            
            topBackTeeth(z=pieceHeight);
            topFrontTeeth(z=pieceHeight);
        }
        topMountPlateTeeth(z=pieceHeight, nothing=0.1);
        sides(nothing=10);
        backScrews();
        frontScrews();
        mountPlateScrews();
    }
}

module bottomPiece() {
    difference() {
        union() {
            translate([0, 0, -thickness]) cube([pieceDepth, pieceWidth, thickness]);
            
            topBackTeeth(z=-thickness);
            topFrontTeeth(z=-thickness);
            
        }
        topMountPlateTeeth(z=-thickness, nothing=0.1);
        sides(nothing=10);
        powerPort();
        backScrews();
        frontScrews();
        mountPlateScrews();
    }
}

module backPiece() {
    difference() {
        translate([-thickness, -caseInset, -thickness-caseInset]) cube([thickness, pieceWidth+(caseInset*2), pieceHeight+(thickness*2)+(caseInset*2)]);
        topBackTeeth(z=pieceHeight, nothing=10);
        topBackTeeth(z=-thickness, nothing=10);
        pcb(cutout=true);
        sides(nothing=10);
        
        backScrews();
    }
}

module frontPiece(projection=false) {
    difference() {
        translate([pieceDepth, -caseInset, -thickness-caseInset]) cube([thickness, pieceWidth+(caseInset*2), pieceHeight+(thickness*2)+(caseInset*2)]);
        
        topFrontTeeth(z=pieceHeight, nothing=10);
        topFrontTeeth(z=-thickness, nothing=10);
        
        speakers(cutout=true, includeScrews=true);
        ultrasonicSensor(cutout=true);
        controlPanel(depth=50);
        magnets(projection=projection);
        sides(nothing=10);
        frontScrews();
    }
    
}

module speakerMountingHoles() {
    translate([speakerDepth, (2.5/2) + 1, (2.5/2) + 1]) rotate([0, 90, 0]) cylinder(h=50, d=2.5, center = true);
    translate([speakerDepth, (2.5/2) + 1, speakerHeight - (2.5/2) - 1]) rotate([0, 90, 0]) cylinder(h=50, d=2.5, center = true);
    translate([speakerDepth, speakerWidth - (2.5/2) - 1, (2.5/2) + 1]) rotate([0, 90, 0]) cylinder(h=50, d=2.5, center = true);
    translate([speakerDepth, speakerWidth - (2.5/2) - 1, speakerHeight - (2.5/2) - 1]) rotate([0, 90, 0]) cylinder(h=50, d=2.5, center = true);
}

module speakerCone(left, coneDepth = 50) {
    coneWidth = 38;
    coneHeight = 27;
    coneOffset = 18;
    z = (speakerHeight - coneHeight) / 2;
    if (left) {
        y = coneOffset;
        translate([speakerDepth-2, y, z]) cube([coneDepth, coneWidth, coneHeight]);
    } else {
        y = speakerWidth - coneWidth - coneOffset;
        translate([speakerDepth-2, y, z]) cube([coneDepth, coneWidth, coneHeight]);
    }
}

module speaker(left, cutout, includeScrews) {
    translate([pieceDepth-speakerDepth, 0, (pieceHeight-speakerHeight)/2]) {
        difference() {
            cube([speakerDepth, speakerWidth, speakerHeight]);
            speakerMountingHoles();
            speakerCone(left=left);
        }
        
        if (cutout) {
            if(includeScrews) {
                speakerMountingHoles();
            }
            speakerCone(left=left);
        }
    }
}

module speakers(cutout=false, includeScrews=false) {
    inset = thickness * 2;
    translate([0, inset, 0]) speaker(left=true, cutout=cutout, includeScrews=includeScrews);
    translate([0, pieceWidth-speakerWidth-inset, 0]) speaker(left=false, cutout=cutout, includeScrews=includeScrews);
}

module ultrasonicMountingHoles() {
    d2 = (1.6/2);
    translate([0, d2 + 0.8, d2 + 0.8]) rotate([0, 90, 0]) cylinder(h=50, d=1.6, center = true);
    translate([0, d2 + 0.8, 18 - (d2 + 0.8)]) rotate([0, 90, 0]) cylinder(h=50, d=1.6, center = true);
    translate([0, 40 - (d2 + 0.8), d2 + 0.8]) rotate([0, 90, 0]) cylinder(h=50, d=1.6, center = true);
    translate([0, 40 - (d2 + 0.8), 18 - (d2 + 0.8)]) rotate([0, 90, 0]) cylinder(h=50, d=1.6, center = true);
}

module ultrasonicCones(codeDepth) {
    cylinderWidth = 38;
    translate([(codeDepth/2) + 1.57, 8+1, 8+1]) rotate([0, 90, 0]) cylinder(h=codeDepth, d=16, center = true);
    translate([(codeDepth/2) + 1.57, 8+40-16-1, 8+1]) rotate([0, 90, 0]) cylinder(h=codeDepth, d=16, center = true);
}

module ultrasonicSensor(cutout=false, includeScrews=true) {
    ultrasonicWidth = 40;
    ultrasonicDepth = 13;
    translate([mountPlateInset+thickness, (pieceWidth - ultrasonicWidth)/2, pieceHeight-ultrasonicHeight-ultrasonicPadding]) {
        difference() {
            cube([1.57, ultrasonicWidth, ultrasonicHeight]);
            
            ultrasonicMountingHoles();
        }
        
        ultrasonicCones(codeDepth=ultrasonicDepth);
        
        if (cutout) {
            if (includeScrews) {
                ultrasonicMountingHoles();
            }
            ultrasonicCones(codeDepth=50);
        }
    }
}

module volumeEncoder(cutout=false) {
    dialZ = 20;
    
    y = (pieceWidth / 2)-24;
    
    if (cutout) {
        encoderD = 6.8;
        translate([20 + mountPlateInset, y, controlPanelZ / 2]) rotate([90, 0, 90]) cylinder(h=50, d=encoderD, center = true);
    } else {
        dialX = 16;
        translate([mountPlateInset, y, controlPanelZ / 2]) {
            rotate([0, 0, 90]) translate([0, -(dialX / 2), 0]) {
                rotate([90, 0, 0]) cylinder(h=dialX, d=dialZ, center = true);
                
                translate([-10, -(-dialX/2), -10]) cube([20, 20, 20]);
            }
        }
    }
}

module powerSwitchMountingHoles() {
    // ((powerSwitchWidth-powerSwitchBodyWidth)/2)/2
    // powerSwitchHeight/2
    holeOffset = (powerSwitchWidth-powerSwitchBodyWidth)/2;
    translate([-10, (-powerSwitchWidth/2) + holeOffset/2, 0]) rotate([0,90, 0]) cylinder(h=50, d=2.6);
    translate([-10, (powerSwitchWidth/2) - holeOffset/2, 0]) rotate([0,90, 0]) cylinder(h=50, d=2.6);
}

module powerSwitch(cutout=false) {
    powerSwitchBodyDepth=11;
    powerSwitchBodyHeight = 7.5;
    trackWidth=10;
    trackHeight=5;
    translate([mountPlateInset-0.6, (pieceWidth / 2) + 12 + powerSwitchWidth/2, controlPanelZ / 2]) {
        rotate([90, 0, 0]) {
            if(cutout) {
                powerSwitchMountingHoles();
                translate([-powerSwitchBodyDepth-50, -powerSwitchBodyWidth/2, -powerSwitchBodyHeight/2])
                            cube([powerSwitchBodyDepth+50, powerSwitchBodyWidth, powerSwitchBodyHeight]);
                translate([0, -trackWidth/2, -trackHeight/2])
                            cube([6+50, trackWidth, trackHeight]);
            } else {
                powerSwitchToggleHeight = 3.75;
                
                difference() {
                    union() {
                        translate([0,-powerSwitchWidth/2,-powerSwitchHeight/2]) cube([0.5, powerSwitchWidth, powerSwitchHeight]);
                        translate([-powerSwitchBodyDepth, -powerSwitchBodyWidth/2, -powerSwitchBodyHeight/2])
                            cube([powerSwitchBodyDepth, powerSwitchBodyWidth, powerSwitchBodyHeight]);
                        translate([0, -trackWidth/2, -trackHeight/2])
                            cube([6, trackWidth, trackHeight]);
                    }
                    powerSwitchMountingHoles();
                }
            } 
        }
    }        
}

module topMountPlateTeeth(z, nothing = 0) {
    teethWidth = (mountPlateWidth/2) - (powerPortNutD/2) - thickness;
    
    // Left Teeth
    translate([mountPlateInset + (thickness/2), (pieceWidth/2) - (mountPlateWidth/2) + (teethWidth/2), thickness/2])
        verticalTeeth(z, teethWidth, thickness, 0, 2, teethWidth/5, thickness, nothing=nothing, spaceBetween = true);
    // Right Teeth
    translate([mountPlateInset + (thickness/2), (pieceWidth/2) + (mountPlateWidth/2) - (teethWidth/2), thickness/2])
        verticalTeeth(z, teethWidth, thickness, 0, 2, teethWidth/5, thickness, nothing=nothing, spaceBetween = true);
}

module mountingPlate() {
    difference() {
        
        union() {
            translate([mountPlateInset, (pieceWidth - mountPlateWidth) / 2, 0]) cube([thickness, mountPlateWidth, pieceHeight]);
            topMountPlateTeeth(z=pieceHeight);
            topMountPlateTeeth(z=-thickness);
        }
     
        translate([mountPlateInset - (pieceDepth/2), (pieceWidth / 2) - (powerCutoutW / 2), -0.1]) cube([pieceDepth, powerCutoutW, powerPortHeight+5+0.1]);
        
        volumeEncoder(cutout=true);
        ultrasonicSensor(cutout=true);
        powerSwitch(cutout=true);
        mountPlateScrews();
    }
}

module controlPanel(depth=thickness) {
    panelWidth = 80;
    panelHeight = 28;
    translate([pieceDepth-((depth-thickness) / 2), (pieceWidth - panelWidth) / 2, (controlPanelZ - panelHeight) / 2]) {
        cube([depth, panelWidth, panelHeight]);
    }
}

module pcbMountingHoles() {
    translate([0, 0, 0]) cylinder(h=50, d=2.5, center = true);
    translate([0, 38, 0]) cylinder(h=50, d=2.5, center = true);
    translate([104, 0, 0]) cylinder(h=50, d=2.5, center = true);
    translate([104, 38, 0]) cylinder(h=50, d=2.5, center = true);
}

module pcb(cutout=false) {
    translate([0, pieceWidth - pcbWidth - 10 + 4.5, 4.5 + (pieceHeight-pcbHeight)/2])
    rotate([90, 0, 90]) {
        if (cutout) {
            pcbMountingHoles();
        } else {
            color(flatui[3]) difference() {
                translate([-4.5, -4.5, 0]) cube([pcbWidth, pcbHeight, 1.57]);
                
                pcbMountingHoles();
            }
        }
    }
}

module powerPort() {
    coverHeight = 3;
    translate([powerPortNutD/2 + 4, pieceWidth / 2, 0]) {
        union() {
            translate([0, 0, (powerPortHeight / 2) - thickness-0.1]) cylinder(h=powerPortHeight, d=powerPortD, center=true);
            translate([0, 0, 2]) cylinder(h=4, d=powerPortNutD, center=true);
            translate([0, 0, -(coverHeight / 2) - thickness]) cylinder(h=coverHeight, d=powerPortExtD, center=true);
        }
    }
}

module magnet(projection) {
    if(projection) {
        rotate([0, 90, 0]) cylinder(h=(thickness * 10), d=magnetD);
    } else {
        rotate([0, 90, 0]) cylinder(h=magnetDepth, d=magnetD);
    }
    
}

module magnetPosition(projection) {
    hPadding = 7;
    vpadding = 2;
    translate([0, magnetD/2 + hPadding, magnetD/2 + vpadding]) magnet(projection=projection);
    translate([0, magnetD/2 + hPadding, pieceHeight - magnetD/2 - vpadding]) magnet(projection=projection);
    translate([0, pieceWidth - magnetD/2 - hPadding, magnetD/2 + vpadding]) magnet(projection=projection);
    translate([0, pieceWidth - magnetD/2 - hPadding, pieceHeight - magnetD/2 - vpadding]) magnet(projection=projection);
}

module magnets(projection=false) {
    if(projection) {
        inset = thickness*5;
        translate([pieceDepth+thickness-inset, 0, 0]) magnetPosition(projection=projection);
        translate([pieceDepth+thickness-inset+magnetDepth, 0, 0]) magnetPosition(projection=projection);
    } else {
        translate([pieceDepth+thickness-magnetInset, 0, 0]) magnetPosition(projection=projection);
        translate([pieceDepth+thickness-magnetInset+magnetDepth, 0, 0]) magnetPosition(projection=projection);
    }
    
}

module cover(projection=false) {
    difference() {
        translate([pieceDepth+thickness-magnetInset+magnetDepth+magnetDepth-magnetInset, -caseInset, -thickness-caseInset]) cube([thickness, pieceWidth+(caseInset * 2), pieceHeight+(caseInset * 2)+(thickness*2)]);
        speakers(cutout=true, includeScrews=false);
        ultrasonicSensor(cutout=true, includeScrews=false);
        magnets(projection=projection);
    }
}

module sideTopTeeth(z, nothing = 0) {
    translate([pieceDepth / 2, (thickness/2), 0]) 
    rotate([0, 0, 90]) verticalTeeth(z, pieceDepth, thickness, 0, 3, pieceDepth/6, thickness+nothing);
}

module sideBackTeeth(x, nothing = 0) {
    translate([x, (thickness/2), pieceHeight/2]) 
    rotate([90, 0, 90]) verticalTeeth(0, pieceHeight, thickness, 0, 4, pieceHeight/10, thickness+nothing);
}

module side(nothing=0) {
    difference() {
        union() {
            cube([pieceDepth, thickness, pieceHeight]);
            
            sideTopTeeth(-thickness/2, nothing=nothing);
            sideTopTeeth(pieceHeight + (thickness/2), nothing=nothing);
            
            sideBackTeeth(-thickness/2, nothing=nothing);
            sideBackTeeth(pieceDepth + (thickness/2), nothing=nothing);
        }
        backScrews();
        frontScrews();
    }
}

module sides(nothing=0) {
    side(nothing=nothing);
    
    translate([0, pieceWidth-thickness, 0]) side(nothing=nothing);
}

module backScrews() {
    // Left/Right
    translate([0, thickness / 2, pieceHeight / 2]) rotate([0, 90, 0]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    translate([0, pieceWidth - thickness / 2, pieceHeight / 2]) rotate([0, 90, 0]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Top
    translate([0, (pieceWidth/2), pieceHeight + thickness / 2]) rotate([90, 0, 90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Bottom
    remainingSpace = (pieceWidth - (pieceWTeethCount * pieceWTeethWidth)) / (pieceWTeethCount + 1);
    translate([0, ((pieceWTeethWidth+remainingSpace)*(pieceWTeethCount/4)) + (remainingSpace / 2), -(thickness / 2)])
        rotate([90, 0, 90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    translate([0, ((pieceWTeethWidth+remainingSpace)*(pieceWTeethCount-(pieceWTeethCount/4))) + (remainingSpace / 2), -(thickness / 2)])
        rotate([90, 0, 90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
}

module frontScrews() {
    // Left/Right
    translate([pieceDepth, thickness / 2, pieceHeight / 2]) rotate([0, -90, 0]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    translate([pieceDepth, pieceWidth - thickness / 2, pieceHeight / 2]) rotate([0, -90, 0]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Top/Bottom
    translate([pieceDepth, (pieceWidth/2), pieceHeight + thickness / 2]) rotate([90, 0, -90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    translate([pieceDepth, (pieceWidth/2), -thickness / 2]) rotate([90, 0, -90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
}

module mountPlateScrews() {
    middleOffset = ((mountPlateWidth-powerCutoutW)/2)/2;
    
    // Top
    translate([mountPlateInset + (thickness/2), ((pieceWidth - mountPlateWidth)/2) + middleOffset, pieceHeight]) rotate([0, 180, 90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    translate([mountPlateInset + (thickness/2), ((pieceWidth - mountPlateWidth)/2) + mountPlateWidth - middleOffset, pieceHeight]) rotate([0, 180, 90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    
    // Bottom
    translate([mountPlateInset + (thickness/2), ((pieceWidth - mountPlateWidth)/2) + middleOffset, 0]) rotate([0, 0, 90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
    translate([mountPlateInset + (thickness/2), ((pieceWidth - mountPlateWidth)/2) + mountPlateWidth - middleOffset, 0]) rotate([0, 0, 90]) createTJoint(th=3, bD=5.5, bH=2.5, sD=3.4, sL=7);
}

module layoutPieces() {
    // Top and bottom
    translate([0, 0, -pieceHeight]) topPiece();
    translate([pieceDepth + (thickness*3), 0, 0]) bottomPiece();
    
    // Back and front
    translate([(caseInset+thickness)*2, pieceWidth + (thickness*3), 0]) rotate([0, 90, 0]) backPiece();
    translate([pieceHeight + (caseInset+thickness)*4 + thickness, pieceWidth + (thickness*3), 0]) rotate([0, 90, 0]) frontPiece(projection=true);
    
    // Left and right
    translate([thickness, ((pieceWidth + (thickness*2)) * 2) + pieceHeight + (thickness * 3), 0]) rotate([90, 0, 0]) side();
    translate([thickness + pieceDepth + (thickness * 3), ((pieceWidth + (thickness*2)) * 2) + pieceHeight + (thickness * 3), 0]) rotate([90, 0, 0]) side();
    
    // Mounting plate
    translate([pieceDepth * 3, 0, 0]) rotate([0, 90, 0]) mountingPlate();
    
    // Cover
    translate([pieceDepth * 5, 0, 0]) rotate([0, 90, 0]) cover(projection=true);
}

module displayProjection() {
    $fn=20;
    projection() {
        layoutPieces();
    }
}

module renderModel() {
    color(flatui[1]) topPiece();
    color(flatui[2]) backPiece();
    color(flatui[3]) frontPiece();
    color(flatui[4]) bottomPiece();
    color(flatui[9]) mountingPlate();
    color(flatui[6]) sides();
    color(flatui[5]) cover();

    // color(flatui[4]) magnets(projection=true);

    /*

    color(flatui[5]) speakers();
    color(flatui[6]) ultrasonicSensor();
    color(flatui[7]) volumeEncoder();
    color(flatui[8]) powerSwitch();
    color(flatui[1]) pcb();
    color(flatui[2]) powerPort();
    */
}

// renderModel();
displayProjection();