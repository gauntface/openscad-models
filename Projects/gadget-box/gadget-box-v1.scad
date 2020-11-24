zyxelNasColor = [
    (26 / 255),
    (188 / 255),
    (156 / 255)
];
nasWidth = 124;
nasHeight = 164;
nasDepth = 206;
nasBackCableSapce = 42;

switchColor = [
    (155 / 255),
    (89 / 255),
    (182 / 255)
];
switchWidth = 117;
switchHeight = 26;
switchDepth = 65;
switchBackCableSapce = 60;
switchLeftCableSapce = 14;

raspPiColor = [
    (231 / 255),
    (76 / 255),
    (60 / 255)
];
raspPiWidth = 68;
raspPiHeight = 45;
raspPiDepth = 104;
raspPiBackCableSapce = 40;
raspPiRightCableSapce = 30;

ankerHubColor = [
    (46 / 255),
    (204 / 255),
    (113 / 255)
];
ankerHubWidth = 26;
ankerHubHeight = 70;
ankerHubDepth = 100;
ankerHubBackCableSapce = 64;

networkSwitchColor = [
    (52 / 255),
    (73 / 255),
    (94 / 255)
];
networkSwitchWidth = 29;
networkSwitchHeight = 158;
networkSwitchDepth = 102;
networkSwitchBackCableSapce = 45;
networkSwitchFrontCableSapce = 50;

frontCoverColor = [
    (231 / 255),
    (76 / 255),
    (60 / 255)
];

module zxyelNas() {
    totalDepth = nasDepth + nasBackCableSapce;
    
    color(zyxelNasColor)
    
    cube([nasWidth, nasDepth, nasHeight]);
}

module hdmiSwitch() {
    totalWidth = switchWidth + switchLeftCableSapce;
    totalDepth = switchDepth + switchBackCableSapce;
    
    color(switchColor)
    translate([switchLeftCableSapce, 0, 0]) {
        cube([switchWidth, switchDepth, switchHeight]);
    }
}

module raspPi() {
    totalWidth = raspPiWidth + raspPiRightCableSapce;
    totalDepth = raspPiDepth + raspPiBackCableSapce;
    
    color(raspPiColor)
    
    cube([totalWidth, totalDepth, raspPiHeight]);
}

module ankerHub() {
    
    color(ankerHubColor)
    
    cube([ankerHubWidth, ankerHubDepth, ankerHubHeight]);
}

module networkSwitch() {
    totalDepth = networkSwitchDepth + networkSwitchBackCableSapce + networkSwitchFrontCableSapce;
    
    color(networkSwitchColor)
    translate([0, networkSwitchFrontCableSapce, 0]) {
        cube([networkSwitchWidth, networkSwitchDepth, networkSwitchHeight]);
    }
}

acrylicThickness = 3;
itemIdentation = 12 + acrylicThickness;

leftThickness = acrylicThickness + networkSwitchWidth + acrylicThickness;

rightThickness = switchWidth + switchLeftCableSapce + acrylicThickness;

boxWidth = leftThickness + rightThickness;
boxDepth = 266;
boxHeight = acrylicThickness + nasHeight + acrylicThickness + switchHeight + acrylicThickness + raspPiHeight + 16;

module base() {
    cube([boxWidth, boxDepth, acrylicThickness]);
}

module left() {
    echo(boxHeight);
    echo(boxDepth);
    cube([acrylicThickness, boxDepth, boxHeight]);
}

module ankerHubHolder(extendTeeth = false) {
    numberOfTeeth = 5;
    totalTeethHeight = ankerHubHeight + (acrylicThickness * 2);
    toothHeight = totalTeethHeight / numberOfTeeth;
    
    teethWidth = extendTeeth ? (acrylicThickness * 3) : 0;
    
    union() {
        difference() {
             translate([-(teethWidth / 2), 0, acrylicThickness]) {
                color(frontCoverColor) cube([networkSwitchWidth + (2 * acrylicThickness) + teethWidth, acrylicThickness, ankerHubHeight]);
             }
            
            translate([((networkSwitchWidth - (ankerHubWidth - 8)) / 2 + acrylicThickness), -acrylicThickness, 2 + acrylicThickness]) {
                cube([ankerHubWidth - 8, acrylicThickness * 3, ankerHubHeight - 2 - 8]);
            }
            
            teethLeftX = -teethWidth - acrylicThickness;
            for(zPosition = [0 : 2 : numberOfTeeth]) {
                translate([teethLeftX, - acrylicThickness, zPosition * toothHeight]) {
                    cube([teethWidth + (acrylicThickness * 2), acrylicThickness * 3, toothHeight]);
                }
            }
            
            teethRightX = ankerHubWidth + (acrylicThickness * 2);
            for(zPosition = [0 : 2 : numberOfTeeth]) {
                translate([teethRightX, - acrylicThickness, zPosition * toothHeight]) {
                    cube([teethWidth + (acrylicThickness * 2), acrylicThickness * 3, toothHeight]);
                }
            }
        }
        
        translate([(networkSwitchWidth / 2) - (10 / 2) + acrylicThickness, 0, -teethWidth]) {
            color(frontCoverColor) cube([10, acrylicThickness, teethWidth + acrylicThickness]);
        }
        
        translate([(networkSwitchWidth / 2) - (10 / 2) + acrylicThickness, 0, ankerHubHeight + acrylicThickness]) {
            color(frontCoverColor) cube([10, acrylicThickness, teethWidth + acrylicThickness]);
        }
    }
}

module ankerHubFrontBack(extendTeeth = false) {
    // Anker Hub Front    
    translate([0, itemIdentation - acrylicThickness, 0]) {
        ankerHubHolder(extendTeeth);
    }
    
    // Anker Hub Back
    translate([0, itemIdentation + ankerHubDepth, 0]) {
        ankerHubHolder(extendTeeth);
    }
}

module networkSwitchHolder(extendTeeth = false) {
    numberOfTeeth = 7;
    totalTeethHeight = boxHeight - ankerHubHeight;
    toothHeight = totalTeethHeight / numberOfTeeth;
    
    teethWidth = extendTeeth ? (acrylicThickness * 3) : 0;
    
    difference() {
        translate([-(teethWidth / 2), 0, acrylicThickness]) {
            color(frontCoverColor) cube([
                networkSwitchWidth + (2 * acrylicThickness) + teethWidth,
                acrylicThickness,
                boxHeight - ankerHubHeight - acrylicThickness + teethWidth
            ]);
        }
        
        // Cut out the middle
        translate([(networkSwitchWidth / 2) - ((networkSwitchWidth - 4) / 2) + acrylicThickness, -acrylicThickness, 12 + acrylicThickness]) {
            cube([networkSwitchWidth - 4, acrylicThickness * 3, networkSwitchHeight - 24]);
        }
        
        // Cut out the top
        translate([(networkSwitchWidth / 2) - (18 / 2) + acrylicThickness, -acrylicThickness, (((boxHeight - ankerHubHeight) - networkSwitchHeight) / 2) - 9 + networkSwitchHeight]) {
            cube([18, acrylicThickness * 3, 26 + teethWidth]);
        }
        
        teethLeftX = -teethWidth - acrylicThickness;
        for(zPosition = [0 : 2 : numberOfTeeth]) {
            translate([teethLeftX, - acrylicThickness, zPosition * toothHeight]) {
                cube([teethWidth + (acrylicThickness * 2), acrylicThickness * 3, toothHeight]);
            }
        }
        
        teethRightX = networkSwitchWidth + acrylicThickness;
        for(zPosition = [0 : 2 : numberOfTeeth]) {
            translate([teethRightX, - acrylicThickness, zPosition * toothHeight]) {
                cube([teethWidth + (acrylicThickness * 2), acrylicThickness * 3, toothHeight]);
            }
        }
        
        translate([teethLeftX, - acrylicThickness, numberOfTeeth * toothHeight]) {
            cube([teethWidth + (acrylicThickness * 2), acrylicThickness * 3, toothHeight]);
        }
        translate([teethRightX, - acrylicThickness, numberOfTeeth * toothHeight]) {
            cube([teethWidth + (acrylicThickness * 2), acrylicThickness * 3, toothHeight]);
        }
    }
    
    translate([(networkSwitchWidth / 2) - (10 / 2) + acrylicThickness, 0, -teethWidth]) {
        color(frontCoverColor) cube([10, acrylicThickness, acrylicThickness + teethWidth]);
    }
}

module networkSwitchFrontBack(extendTeeth) {
    teethHeight = networkSwitchHeight + (acrylicThickness * 2);
    numberOfTeeth = teethHeight / 7;
    
    // Network Switch Front
    translate([0, networkSwitchFrontCableSapce + itemIdentation - acrylicThickness, ankerHubHeight + acrylicThickness]) {
        networkSwitchHolder(extendTeeth);
    }
    
    // Network Switch Back
    translate([0, networkSwitchFrontCableSapce + itemIdentation + networkSwitchDepth, ankerHubHeight + acrylicThickness]) {
        networkSwitchHolder(extendTeeth);
    }
}

module leftFirstShelf() {
    extendTeeth = true;
    numberOfTeeth = 7;
    totalTeethDepth = boxDepth;
    toothDepth = totalTeethDepth / numberOfTeeth;
    
    teethWidth = extendTeeth ? (acrylicThickness * 3) : 0;
    
    difference() {
        translate([0, 0, acrylicThickness + ankerHubHeight]) {
            cube([networkSwitchWidth + (acrylicThickness * 2), boxDepth, acrylicThickness]);
            
            teethLeftX = -teethWidth - acrylicThickness;
            for(yPosition = [0 : 2 : numberOfTeeth]) {
                translate([- acrylicThickness, yPosition * toothDepth, 0]) {
                    cube([teethWidth + (acrylicThickness * 2), toothDepth, acrylicThickness * 3]);
                }
            }
        }
        
        ankerHubFrontBack(true);
    
        networkSwitchFrontBack(true);
    }
    
    // ankerHubFrontBack();
    
    // networkSwitchFrontBack();
}

module rightFirstShelf() {
    translate([leftThickness, 0, acrylicThickness + nasHeight]) {
        cube([rightThickness, boxDepth, acrylicThickness]);
    }
}

module rightSecondShelf() {
    translate([leftThickness, 0, acrylicThickness + nasHeight + acrylicThickness + switchHeight]) {
        cube([rightThickness, boxDepth, acrylicThickness]);
    }
}

/** difference() {
    left();
    
    ankerHubFrontBack(true);
    networkSwitchFrontBack(true);
}

difference() {
    translate([acrylicThickness + networkSwitchWidth, 0, 0]) {
        left();
    }
    
    ankerHubFrontBack(true);
    networkSwitchFrontBack(true);
}**/

leftFirstShelf();

translate([leftThickness + switchWidth + switchLeftCableSapce, 0, 0]) {
    left();
}

/**difference() {
    base();
    ankerHubFrontBack(true);
}

rightFirstShelf();
rightSecondShelf();

translate([0, 0, boxHeight]) {
   base();
}**/


/** 
translate([acrylicThickness, itemIdentation, acrylicThickness]) {
    ankerHub();
}

translate([acrylicThickness, itemIdentation, acrylicThickness + ankerHubHeight + acrylicThickness]) {
    networkSwitch();
}

translate([leftThickness, itemIdentation,acrylicThickness]) {
    zxyelNas();
}

translate([leftThickness, itemIdentation, acrylicThickness + nasHeight + acrylicThickness]) {
    hdmiSwitch();
}

translate([leftThickness, itemIdentation, acrylicThickness + nasHeight + acrylicThickness + switchHeight + acrylicThickness]) {
    raspPi();
}**/