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
    (241 / 255),
    (196 / 255),
    (15 / 255)
];
networkSwitchWidth = 29;
networkSwitchHeight = 158;
networkSwitchDepth = 102;
networkSwitchBackCableSapce = 45;
networkSwitchFrontCableSapce = 50;

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
itemIdentation = 8;

leftThickness = acrylicThickness + networkSwitchWidth + acrylicThickness;

rightThickness = switchWidth + switchLeftCableSapce + acrylicThickness;

boxWidth = leftThickness + rightThickness;
boxDepth = 266;
boxHeight = acrylicThickness + nasHeight + acrylicThickness + switchHeight + acrylicThickness + raspPiHeight + 16;

module base() {
    cube([boxWidth, boxDepth, acrylicThickness]);
}

module left() {
    cube([acrylicThickness, boxDepth, boxHeight]);
}

module leftFirstShelf() {
    translate([acrylicThickness, 0, acrylicThickness + ankerHubHeight]) {
        cube([networkSwitchWidth, boxDepth, acrylicThickness]);
    }
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

base();
leftFirstShelf();

rightFirstShelf();
rightSecondShelf();

translate([0, 0, boxHeight]) {
    base();
}

left();

translate([acrylicThickness + networkSwitchWidth, 0, 0]) {
    left();
}
translate([leftThickness + switchWidth + switchLeftCableSapce, 0, 0]) {
    left();
}

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
}

