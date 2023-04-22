include <../../libs/flat-ui-colors.scad>;
include <../../libs/teeth.scad>;
include <../../libs/t-joint.scad>;

thickness = 3;
m3D = 3.4;

caseInset = 4;

pcbHeight = 47;
pcbWidth = 113;
pcbDepth = 1.57;

pieceDepth = 48;
pieceHeight = pcbHeight + 4;
pieceWidth = 240;

speakerHeight = 31;
speakerWidth = 69.5;
speakerDepth = 16.9;
speakerInset = 16;

ultrasonicWidth = 40;
ultrasonicDepth = 13;
ultrasonicHeight = 18;

controlPanelDepth = pieceDepth-speakerDepth-1;
dialDepth = 21;
controlPanelY = pieceWidth - 28;
controlPanelZ = pieceHeight - ultrasonicHeight;

powerSwitchWidth = 23;
powerSwitchHeight = 7.5;
powerSwitchBodyWidth=15.7;

largeMagnetD = 10+0.5;
largeMagnetDepth = 3;
magnetInset = 0;
smallMagnetD = 5+0.5;
smallMagnetDepth = 2.66;

pieceWTeethWidth = pieceWidth/20;
pieceWTeethCount = 8;

dialZ = 20;
dialPadding = 2;

mountPlateInset = pieceDepth - ultrasonicDepth + thickness - 1;
mountPlateWidth = ultrasonicWidth+(thickness*2);

module topBackTeeth(z, nothing = 0) {
    translate([-(thickness/2), (pieceWidth/2), thickness/2])
        verticalTeeth(z, pieceWidth, thickness+nothing, 0, pieceWTeethCount, pieceWTeethWidth, thickness);
}

module topFrontTeeth(z, nothing = 0) {
    translate([pieceDepth+(thickness/2), (pieceWidth/2), thickness/2]) verticalTeeth(z, pieceWidth, thickness+nothing, 0, pieceWTeethCount, pieceWTeethWidth, thickness);
}

module topPiece() {
    difference() {
        union() {
            translate([0, 0, pieceHeight]) cube([pieceDepth, pieceWidth, thickness]);
            
            topBackTeeth(z=pieceHeight);
            topFrontTeeth(z=pieceHeight);
        }
        topMountPlateTeeth(z=pieceHeight, nothing=0.1, teethExtension=10);
        backScrews();
        frontScrews();
        mountPlateScrews();
        controlPlate(nothing=0.1, teethExtension=10);
        controlMagnetPlates(nothing=0.1, teethExtension=10);
    }
}

module bottomPiece() {
    difference() {
        union() {
            translate([0, 0, -thickness]) cube([pieceDepth, pieceWidth, thickness]);
            
            topBackTeeth(z=-thickness);
            topFrontTeeth(z=-thickness);
            
        }
        topMountPlateTeeth(z=-thickness, nothing=0.1, teethExtension=10);
        backScrews();
        frontScrews();
        mountPlateScrews();
        controlPlate(nothing=0.1, teethExtension=10);
        controlMagnetPlates(nothing=0.1, teethExtension=10);
        usbHole();
    }
}

module usbHole() {
    translate([16.5,(pieceWidth-pcbWidth)/2 + 12.5,-40]) cylinder(h=50, d=14);
}

module backPiece() {
    difference() {
        translate([-thickness, -caseInset, -thickness-caseInset])
            cube([thickness, pieceWidth+(caseInset*2), pieceHeight+(thickness*2)+(caseInset*2)]);
        
        topBackTeeth(z=pieceHeight, nothing=10);
        topBackTeeth(z=-thickness, nothing=10);
        
        pcb(cutout=true);
        controlPlate(nothing=0.1, teethExtension=10);
        backScrews();
    }
}

module frontPiece(projection=false) {
    difference() {
        translate([pieceDepth, -caseInset, -thickness-caseInset]) cube([thickness, pieceWidth+(caseInset*2), pieceHeight+(thickness*2)+(caseInset*2)]);
        
        topFrontTeeth(z=pieceHeight, nothing=10);
        topFrontTeeth(z=-thickness, nothing=10);
        
        speakers(cutout=true, includeScrews=true);
        ultrasonicSensor(cutout=true, includeScrews=false);
        frontMagnets(projection=projection);
        frontScrews();
        controlMagnetPlates(nothing=0.1, teethExtension=10);
    }
    
}

module speakerMountingHoles() {
    translate([speakerDepth, (m3D/2) + 1.3, (m3D/2) + 1.75]) rotate([0, 90, 0]) cylinder(h=50, d=m3D, center = true);
    translate([speakerDepth, (m3D/2) + 1.3, speakerHeight - (m3D/2) - 1.75]) rotate([0, 90, 0]) cylinder(h=50, d=m3D, center = true);
    translate([speakerDepth, speakerWidth - (m3D/2) - 1.5, (m3D/2) + 1.75]) rotate([0, 90, 0]) cylinder(h=50, d=m3D, center = true);
    translate([speakerDepth, speakerWidth - (m3D/2) - 1.5, speakerHeight - (m3D/2) - 1.75]) rotate([0, 90, 0]) cylinder(h=50, d=m3D, center = true);
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
            if (left) {
                speakerMountingHoles();
            } else {
                rotate([180, 0, 0]) speakerMountingHoles();
            }
            speakerCone(left=left);
        }
        
        if (cutout) {
            if(includeScrews) {
                speakerMountingHoles();
            }
            speakerCone(left=left);
        }
        speakerMountingHoles();
    }
}

module speakers(cutout=false, includeScrews=false) {
    translate([0, speakerInset, 0]) speaker(left=true, cutout=cutout, includeScrews=includeScrews);
    translate([0, pieceWidth-speakerWidth-speakerInset, 0]) speaker(left=false, cutout=cutout, includeScrews=includeScrews);
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
    translate([(codeDepth/2) + pcbDepth, 8+1, 8+1]) rotate([0, 90, 0]) cylinder(h=codeDepth, d=16, center = true);
    translate([(codeDepth/2) + pcbDepth, 8+40-16-1, 8+1]) rotate([0, 90, 0]) cylinder(h=codeDepth, d=16, center = true);
}

module ultrasonicSensor(cutout=false, includeScrews=true) {
    translate([mountPlateInset-pcbDepth-0.1, (pieceWidth - ultrasonicWidth)/2, (pieceHeight-ultrasonicHeight)/2]) {
        difference() {
            cube([pcbDepth, ultrasonicWidth, ultrasonicHeight]);
            
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
    if (cutout) {
        encoderD = 6.8;
        translate([controlPanelDepth/2, controlPanelY + (dialDepth/2), pieceHeight-(dialZ/2)-4])
        rotate([90, 0, 0])
        cylinder(h=50, d=encoderD, center = true);
    } else {
        translate([controlPanelDepth/2, controlPanelY + (dialDepth/2), pieceHeight-(dialZ/2)-4]) rotate([0, 0, 180]) {
            rotate([90, 0, 0]) cylinder(h=dialDepth, d=dialZ, center = true);
            translate([-10, -(-dialDepth/2), -10]) cube([20, 20, 20]);
        }
    }
}

module controlPlate(nothing=0, teethExtension=thickness) {
    teethDepth = 12;
    difference() {
        translate([0, controlPanelY, 0]) {
            union() {
                cube([controlPanelDepth, thickness, pieceHeight]);
                // Top and bottom
                translate([(controlPanelDepth-teethDepth)/2-(nothing/2), -(nothing/2), -teethExtension])
                cube([teethDepth+nothing, thickness+nothing, teethExtension+nothing]);
                translate([(controlPanelDepth-teethDepth)/2-(nothing/2), -(nothing/2), pieceHeight-nothing])
                cube([teethDepth+nothing, thickness+nothing, teethExtension+nothing]);
                
                // Back 
                translate([-teethExtension, -(nothing/2), 6-(nothing/2)])
                cube([teethExtension+nothing, thickness+nothing, teethDepth+nothing]);
                
                translate([-teethExtension, -(nothing/2), pieceHeight-teethDepth-6-(nothing/2)])
                cube([teethExtension+nothing, thickness+nothing, teethDepth+nothing]);
            }
        }
        volumeEncoder(cutout=true);
        powerSwitch(cutout=true);
    }
}

module smallMagnetPair(magnetExtension=smallMagnetDepth) {
    color(flatui[1])
    translate([0, (magnetExtension * 1), 0])
    rotate([90, 0, 0])
    cylinder(h=magnetExtension, d=smallMagnetD);
    
    color(flatui[2])
    translate([0, (magnetExtension * 2), 0])
    rotate([90, 0, 0])
    cylinder(h=magnetExtension, d=smallMagnetD);
}

module controlPlateMagnetSet(magnetExtension=smallMagnetDepth) {
    magnetX = pieceDepth-(panelDepth/2);
    
    translate([magnetX, 0, (smallMagnetD/2)+thickness]) smallMagnetPair(magnetExtension=magnetExtension);
    translate([magnetX, 0, pieceHeight-(smallMagnetD/2)-thickness]) smallMagnetPair(magnetExtension=magnetExtension);
    translate([magnetX, 0, (pieceHeight/2)]) smallMagnetPair(magnetExtension=magnetExtension);
}

panelDepth = smallMagnetD + 6;
module controlPlateMagnets(magnetExtension=smallMagnetDepth) {
    // Left magnets
    translate([0, thickness-magnetInset-((magnetExtension-smallMagnetDepth)/2), 0]) controlPlateMagnetSet(magnetExtension=magnetExtension);
    // Right magnets
    translate([0, pieceWidth-(magnetExtension * 2)-thickness+magnetInset+((magnetExtension-smallMagnetDepth)/2), 0]) controlPlateMagnetSet(magnetExtension=magnetExtension);
}

module controlMagnetPlate(nothing=0, teethExtension=thickness) {
    union() {
        translate([pieceDepth-panelDepth, 0, 0])
        cube([panelDepth, thickness, pieceHeight]);
        
        // Top and bottom teeth
        bottomTopTeethWidth = panelDepth/2;
        translate([pieceDepth - (panelDepth/2) - (bottomTopTeethWidth/2)-(nothing/2), -(nothing/2), -teethExtension+nothing])
        cube([bottomTopTeethWidth+nothing, thickness+nothing, teethExtension+nothing]);
        
        translate([pieceDepth - (panelDepth/2) - (bottomTopTeethWidth/2)-(nothing/2), -(nothing/2), pieceHeight-nothing])
        cube([bottomTopTeethWidth+nothing, thickness+nothing, teethExtension+nothing]);
        
        // Front teeth
        frontTeethWidth = 12;
        translate([pieceDepth-nothing, -(nothing/2), (pieceHeight-frontTeethWidth)/2 - (nothing/2)])
        cube([teethExtension+nothing, thickness+nothing, frontTeethWidth+nothing]);
    } 
}

module leftMagnetPlate(nothing=0, teethExtension=thickness, magnetExtension=smallMagnetDepth) {
    leftPanelY = thickness-magnetInset + (smallMagnetDepth * 2) - magnetInset;
    difference() {
        translate([0, leftPanelY, 0]) controlMagnetPlate(nothing=nothing, teethExtension=teethExtension);
        controlPlateMagnets(magnetExtension=magnetExtension);
    }
}

module rightMagnetPlate(nothing=0, teethExtension=thickness, magnetExtension=smallMagnetDepth) {
    rightPanelY = pieceWidth-thickness+magnetInset-(smallMagnetDepth * 2)-thickness+magnetInset;
    difference() {
        translate([0, rightPanelY, 0]) controlMagnetPlate(nothing=nothing, teethExtension=teethExtension);
        controlPlateMagnets(magnetExtension=magnetExtension);
    }
}

module controlMagnetPlates(nothing=0, teethExtension=thickness) {
    leftMagnetPlate(nothing=nothing, teethExtension=teethExtension);
    rightMagnetPlate(nothing=nothing, teethExtension=teethExtension);
}

module sideCover() {
    translate([0.5, 0, 0.5]) cube([pieceDepth-1, thickness, pieceHeight-1]);
}

module leftSideCover(magnetExtension=smallMagnetDepth) {
    difference() {
        translate([0, 0, 0]) sideCover();
        controlPlateMagnets(magnetExtension=magnetExtension);
    }
}

module rightSideCover(magnetExtension=smallMagnetDepth) {
    difference() {
        translate([0, pieceWidth-thickness, 0]) sideCover();
        controlPlateMagnets(magnetExtension=magnetExtension);
    }
}

module sideCovers() {
    leftSideCover();
    
    rightSideCover();
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
    translate([controlPanelDepth/2, controlPanelY-0.5, powerSwitchHeight+6]) {
        rotate([90, 0, 90]) {
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

module topMountPlateTeeth(z, nothing = 0, teethExtension=thickness) {
    teethWidth = 12;
    
    // Left Teeth
    translate([mountPlateInset, (pieceWidth - mountPlateWidth) / 2, z-nothing])
        cube([thickness, teethWidth, teethExtension]);
    
    // Right Teeth
    translate([mountPlateInset-(nothing/2), (((pieceWidth + mountPlateWidth) / 2)-teethWidth)-(nothing/2), z-nothing])
        cube([thickness+nothing, teethWidth+nothing, teethExtension+nothing]);
}

module mountingPlate(teethExtension=thickness) {
    difference() {
        union() {
            translate([mountPlateInset, (pieceWidth - mountPlateWidth) / 2, 0])
            cube([thickness, mountPlateWidth, pieceHeight]);
            
            topMountPlateTeeth(z=pieceHeight, teethExtension=teethExtension);
            topMountPlateTeeth(z=-thickness, teethExtension=teethExtension);
        }
        ultrasonicSensor(cutout=true);
        mountPlateScrews();
    }
}

module pcbMountingHoles() {
    translate([0, 0, 0]) cylinder(h=50, d=m3D, center = true);
    translate([0, 38, 0]) cylinder(h=50, d=m3D, center = true);
    translate([104, 0, 0]) cylinder(h=50, d=m3D, center = true);
    translate([104, 38, 0]) cylinder(h=50, d=m3D, center = true);
}

module pcb(cutout=false) {
    translate([0, 4.5 + (pieceWidth - pcbWidth) / 2, 4.5 + (pieceHeight-pcbHeight)/2])
    rotate([90, 0, 90]) {
        if (cutout) {
            pcbMountingHoles();
        } else {
            color(flatui[3]) difference() {
                translate([-4.5, -4.5, 0]) cube([pcbWidth, pcbHeight, 23]);
                
                pcbMountingHoles();
            }
        }
    }
}

module magnet(projection) {
    if(projection) {
        rotate([0, 90, 0]) cylinder(h=(thickness * 10), d=largeMagnetD);
    } else {
        rotate([0, 90, 0]) cylinder(h=largeMagnetDepth, d=largeMagnetD);
    }
    
}

module magnetPosition(projection) {
    hPadding = 4;
    vpadding = 2;
    translate([0, largeMagnetD/2 + hPadding, largeMagnetD/2 + vpadding]) magnet(projection=projection);
    translate([0, largeMagnetD/2 + hPadding, pieceHeight - largeMagnetD/2 - vpadding]) magnet(projection=projection);
    translate([0, pieceWidth - largeMagnetD/2 - hPadding, largeMagnetD/2 + vpadding]) magnet(projection=projection);
    translate([0, pieceWidth - largeMagnetD/2 - hPadding, pieceHeight - largeMagnetD/2 - vpadding]) magnet(projection=projection);
}

module frontMagnets(projection=false) {
    if(projection) {
        inset = thickness*5;
        translate([pieceDepth+thickness-inset, 0, 0]) magnetPosition(projection=projection);
        translate([pieceDepth+thickness-inset+largeMagnetDepth, 0, 0]) magnetPosition(projection=projection);
    } else {
        translate([pieceDepth+thickness-magnetInset, 0, 0]) magnetPosition(projection=projection);
        translate([pieceDepth+thickness-magnetInset+largeMagnetDepth, 0, 0]) magnetPosition(projection=projection);
    }
    
}

module cover(projection=false) {
    difference() {
        translate([pieceDepth+thickness-magnetInset+largeMagnetDepth+largeMagnetDepth-magnetInset, -caseInset, -thickness-caseInset]) cube([thickness, pieceWidth+(caseInset * 2), pieceHeight+(caseInset * 2)+(thickness*2)]);
        speakers(cutout=true, includeScrews=false);
        ultrasonicSensor(cutout=true, includeScrews=false);
        frontMagnets(projection=projection);
    }
}

module sideTopTeeth(z, nothing = 0) {
    translate([pieceDepth / 2, (thickness/2), 0]) 
    rotate([0, 0, 90]) verticalTeeth(z, pieceDepth, thickness, 0, 3, pieceDepth/6, thickness+nothing);
}

module sideBackTeeth(x, nothing = 0) {
    translate([x, (thickness/2), pieceHeight/2]) 
    rotate([90, 0, 90]) verticalTeeth(0, pieceHeight, thickness, 0, 2, pieceHeight/8, thickness+nothing);
}

remainingSpace = (pieceWidth - (pieceWTeethCount * pieceWTeethWidth)) / (pieceWTeethCount + 1);
frontBackLeftScrewY = remainingSpace + pieceWTeethWidth + (remainingSpace/2);
frontBackRightScrewY = pieceWidth-frontBackLeftScrewY;

module backScrews() {
    // Top Left
    translate([0, frontBackLeftScrewY, pieceHeight + thickness / 2])
    rotate([90, 0, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    // Top Center
    translate([0, (pieceWidth/2), pieceHeight + thickness / 2])
    rotate([90, 0, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    // Top Right
    translate([0, pieceWidth - (remainingSpace/2), pieceHeight + thickness / 2])
    rotate([90, 0, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    
    
    // Bottom Left
    translate([0, remainingSpace + pieceWTeethWidth + (remainingSpace/2), -(thickness / 2)])
        rotate([90, 0, 90])
        createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    // Bottom Center
    translate([0, (pieceWidth/2), -(thickness / 2)])
    rotate([90, 0, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    // Bottom Right
    translate([0, pieceWidth - (remainingSpace/2), -(thickness / 2)])
        rotate([90, 0, 90])
        createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
}

module frontScrews() {
    // Top Left
    translate([pieceDepth, frontBackLeftScrewY, pieceHeight + thickness / 2])
    rotate([90, 0, -90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    // Top Center
    translate([pieceDepth, (pieceWidth/2), pieceHeight + thickness / 2])
        rotate([90, 0, -90])
        createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);

    // Top Right
    translate([pieceDepth, frontBackRightScrewY, pieceHeight + thickness / 2])
    rotate([90, 0, -90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);

    // Bottom Left
    translate([pieceDepth, frontBackLeftScrewY, -(thickness / 2)])
        rotate([90, 0, -90])
        createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);

    // Bottom Center
    translate([pieceDepth, (pieceWidth/2), -thickness / 2])
        rotate([90, 0, -90])
        createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    // Bottom Right
    translate([pieceDepth, frontBackRightScrewY, -(thickness / 2)])
        rotate([90, 0, -90])
        createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
}

module mountPlateScrews() {
    // Top
    /* translate([mountPlateInset + (thickness/2), pieceWidth/2, pieceHeight])
    rotate([0, 180, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);
    
    // Bottom
    translate([mountPlateInset + (thickness/2), pieceWidth/2, 0])
    rotate([0, 0, 90])
    createTJoint(th=3, bD=5.5, bH=2.5, sD=m3D, sL=7);*/
}

module layoutPieces() {
    // Top and bottom
    translate([0, 0, -pieceHeight]) topPiece();
    translate([pieceDepth + (thickness*3), 0, 0]) bottomPiece();
    
    // Back and front
    translate([(caseInset+thickness)*2, pieceWidth + (thickness*3), 0]) rotate([0, 90, 0]) backPiece();
    translate([pieceHeight + (caseInset+thickness)*4 + thickness, pieceWidth + (thickness*3), 0]) rotate([0, 90, 0]) frontPiece(projection=true);
    
    // Left and right
    translate([thickness, ((pieceWidth + (thickness*2)) * 2) + pieceHeight + (thickness * 3), 0]) rotate([90, 0, 0]) leftSideCover(magnetExtension=20);
    translate([thickness + pieceDepth + (thickness * 3), ((pieceWidth + (thickness*2)) * 2) + pieceHeight + (thickness * 3), 0]) rotate([90, 0, 0]) rightSideCover(magnetExtension=20);
    
    // Mounting plate
    translate([pieceDepth * 3, 0, 0]) rotate([0, 90, 0]) mountingPlate();
    
    // Cover
    translate([pieceDepth * 5, 0, 0]) rotate([0, 90, 0]) cover(projection=true);
    
    // Control Plate
    translate([pieceDepth * 3, 70, 0]) rotate([90, 0, 0]) controlPlate();
    
    // Magnet Plates
    translate([pieceDepth * 3, 70, 0]) rotate([90, 0, 0]) leftMagnetPlate(magnetExtension=20);
    translate([(pieceDepth * 5)+15, 80, 0]) rotate([90, 180, 0]) rightMagnetPlate(magnetExtension=20);
}

module displayProjection() {
    $fn=20;
    projection() {
        layoutPieces();
    }
}

module renderModel() {
    color(flatui[1]) topPiece();
    color(flatui[4]) bottomPiece();
    color(flatui[2]) backPiece();
    color(flatui[3]) frontPiece();
    color(flatui[9]) mountingPlate();
    // color(flatui[5]) cover();

    // color(flatui[4]) frontMagnets(projection=true);

    color(flatui[5]) speakers();
    
    color(flatui[9]) controlPlate();
    color(flatui[1]) pcb();
    color(flatui[6]) ultrasonicSensor();
    color(flatui[7]) volumeEncoder();
    // color(flatui[8]) powerSwitch();
    
    color(flatui[2]) controlMagnetPlates();
    color(flatui[3]) sideCovers();
}
// renderModel();
displayProjection();