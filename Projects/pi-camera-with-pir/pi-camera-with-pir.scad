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

m2ClearanceDiameter = 2.4;
m3ClearanceDiameter = 3.4;

acrylicThickness3 = 3;
acrylicThickness2 = 2;

holeBorder = 5;

// Pan Tilt
panTiltBaseWidth = 33;
panTiltBaseDepth = 37;
panTiltBaseHeight = 3;
panTiltHoleWidth = 26;
panTiltHoleDepth = 30;

// Pan Tilt Top Section
topSectionWidth = 36;
topSectionHeight = 38;
topSectionThickness = 2;
topSectionInsetCutawayWidth = 5;
topSectionInsetCutawayHeight = 10;

armDepth = 10;
armTopThickness = acrylicThickness3;
bottomInsetThickness = 1;
bottomInset = 6;
topInsetThickness = 1;
topInset = 1;

// Camera
pirSensorWidth = 32;
pirSensorHeight = 24;
pirSensorDepth = 13;
pirSensorDomeDiam = 23;
pirSensorDomePlatformDepth = 3;
cameraLayerWidth = topSectionWidth + pirSensorWidth + (holeBorder * 3);
cameraLenseWidth = 8.6;
cameraLenseHeight = 8.6;
cameraRibbonAndLense = 17.4;
cameraLEDWidth = 5.7;
cameraLEDHeight = 3;
cameraBodyWidth = 25;
cameraBodyHeight = 24;
cameraRibbonWidth = 16;

cameraZoffset = (((topSectionHeight - bottomInset - bottomInsetThickness - topInset - topInsetThickness) - cameraBodyHeight) / 2) + bottomInset - bottomInsetThickness;
remainingRibbonHeight = topSectionHeight - cameraZoffset - cameraBodyHeight;

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

module panTileHoles() {
    translate([(panTiltBaseWidth - panTiltHoleWidth) / 2, (panTiltBaseDepth - panTiltHoleDepth) / 2, 0]) {
        squareHoles(panTiltBaseHeight, panTiltHoleWidth, panTiltHoleDepth);
    }
}

module panTiltBase() {
    difference() {
        cube([panTiltBaseWidth, panTiltBaseDepth, panTiltBaseHeight]);

        panTileHoles();
    }
}

module panTiltTopSection() {
    translate([topSectionWidth + holeBorder, topSectionThickness + armDepth + armTopThickness, 0]) {
        rotate([0, 0, 180]) {
            difference() {
                color([1,0,0]) cube([topSectionWidth, topSectionThickness, topSectionHeight]);

                cube([topSectionInsetCutawayWidth, topSectionThickness, topSectionInsetCutawayHeight]);

                translate([topSectionWidth - topSectionInsetCutawayWidth, 0, 0]) {
                    cube([topSectionInsetCutawayWidth, topSectionThickness, topSectionInsetCutawayHeight]);
                }
            }

            armHeight = 14;
            armThickness = 1;
            armInset = 2;
            armTopWidth = 2;

            translate([armInset-armThickness, topSectionThickness, armHeight]) {
                color([1,0,0]) cube([armTopWidth, armDepth, armHeight]);
            }

            translate([topSectionWidth - armInset, topSectionThickness, armHeight]) {
                color([1,0,0]) cube([armTopWidth, armDepth, armHeight]);
            }

            translate([armInset-armThickness, topSectionThickness + armDepth, armHeight]) {
                color([1,0,0]) cube([armTopWidth + armThickness, armTopThickness, armHeight]);
            }

            translate([topSectionWidth - armTopWidth - armInset + armThickness, topSectionThickness + armDepth, armHeight]) {
                color([1,0,0]) cube([armTopWidth + armThickness, armTopThickness, armHeight]);
            }

            bottomInsetWidth = 6;
            bottomInsetDepth = 3;

            translate([topSectionWidth - bottomInsetWidth - topSectionInsetCutawayWidth - bottomInset, topSectionThickness, 4]) {
                color([1,0,0]) cube([bottomInsetWidth, bottomInsetDepth, bottomInsetThickness]);
            }

            topInsetWidth = 14;
            topInsetDepth = 3;

            translate([(topSectionWidth - topInsetWidth) / 2, topSectionThickness, topSectionHeight - topInsetThickness - topInset]) {
                color([1,0,0]) cube([topInsetWidth, topInsetDepth, topInsetThickness]);
            }

            cableInsetWidth = 8;
            // cableInsetDepth = 4;
            // To make it easier on removing sections on the camera layers
            cableInsetDepth = acrylicThickness3 + acrylicThickness2 + acrylicThickness2;
            cableInsetThickness = 1;

            translate([topSectionInsetCutawayWidth + 1, topSectionThickness, 1]) {
                color([1,0,0]) cube([cableInsetWidth, cableInsetDepth, cableInsetThickness]);
            }
        }
    }
}

module cameraLayerScrews() {
    screwHoleHeight = 30;
    borderInset = ((holeBorder - m3ClearanceDiameter) / 2) + (m3ClearanceDiameter / 2);
    translate([borderInset, screwHoleHeight - 5, borderInset]) {
        rotate([90, 0, 0]) {
            cylinder(h = screwHoleHeight, d1=m3ClearanceDiameter, d2=m3ClearanceDiameter);
        }
    }

    translate([borderInset, screwHoleHeight - 5, topSectionHeight - borderInset]) {
        rotate([90, 0, 0]) {
            cylinder(h = screwHoleHeight, d1=m3ClearanceDiameter, d2=m3ClearanceDiameter);
        }
    }

    translate([borderInset + holeBorder + topSectionWidth, screwHoleHeight - 5, borderInset]) {
        rotate([90, 0, 0]) {
            cylinder(h = screwHoleHeight, d1=m3ClearanceDiameter, d2=m3ClearanceDiameter);
        }
    }

    translate([borderInset + holeBorder + topSectionWidth, screwHoleHeight - 5, topSectionHeight - borderInset]) {
        rotate([90, 0, 0]) {
            cylinder(h = screwHoleHeight, d1=m3ClearanceDiameter, d2=m3ClearanceDiameter);
        }
    }

    translate([cameraLayerWidth - borderInset, screwHoleHeight - 5, borderInset]) {
        rotate([90, 0, 0]) {
            cylinder(h = screwHoleHeight, d1=m3ClearanceDiameter, d2=m3ClearanceDiameter);
        }
    }

    translate([cameraLayerWidth - borderInset, screwHoleHeight - 5, topSectionHeight - borderInset]) {
        rotate([90, 0, 0]) {
            cylinder(h = screwHoleHeight, d1=m3ClearanceDiameter, d2=m3ClearanceDiameter);
        }
    }
}

module pirSensor() {
    translate([(holeBorder * 2) + topSectionWidth, 0, (topSectionHeight - pirSensorHeight) / 2]) {
        difference() {
            translate([pirSensorWidth / 2, 0, pirSensorHeight / 2]) {
                //sphere(d = pirSensorDomeDiam);
                rotate([90,0,0]) {
                    cylinder(h = 20, d1=pirSensorDomeDiam, d2=pirSensorDomeDiam);
                }
            }

            cube([pirSensorWidth, pirSensorDomeDiam, pirSensorHeight]);
        }
        translate([(pirSensorWidth - pirSensorDomeDiam) / 2, 0, (pirSensorHeight - pirSensorDomeDiam) / 2]) {
            cube([pirSensorDomeDiam, pirSensorDomePlatformDepth, pirSensorDomeDiam]);
        }

        translate([0, pirSensorDomePlatformDepth, 0]) {
            cube([pirSensorWidth, pirSensorDepth, pirSensorHeight]);
        }

        translate([(m2ClearanceDiameter / 2) + 0.5, pirSensorDomePlatformDepth, pirSensorHeight / 2]) {
            rotate([90, 0, 0]) {
                cylinder(h = 20, d1=m2ClearanceDiameter, d2=m2ClearanceDiameter);
            }
        }

        translate([pirSensorWidth - ((m2ClearanceDiameter / 2) + 0.5), pirSensorDomePlatformDepth, pirSensorHeight / 2]) {
            rotate([90, 0, 0]) {
                cylinder(h = 20, d1=m2ClearanceDiameter, d2=m2ClearanceDiameter);
            }
        }
        
        // Pin headers
        pinHeaderWidth = 9;
        pinHeaderHeight = 4;
        // This is large to ensure it pierces the case
        pinHeaderDepth = 20;
        // This is the center of the pin on the board
        pinHeaderCenterXOffset = 16;
        translate([pinHeaderCenterXOffset - (pinHeaderWidth / 2), pirSensorDomePlatformDepth, 0]) {
            cube([pinHeaderWidth, pinHeaderDepth, pinHeaderHeight]);
        }
    }
}

module baseLayer() {
    difference() {
        translate([0, armDepth + armTopThickness - acrylicThickness3, 0]) {
            color([0, 1, 0]) cube([cameraLayerWidth, acrylicThickness3, topSectionHeight]);
        }
        panTiltTopSection();
        cameraLayerScrews();
        pirSensor();
    }
}

module cameraBodyBack() {
    difference() {
        translate([0, armDepth + armTopThickness - acrylicThickness3 - acrylicThickness2, 0]) {
            difference() {
                color([0, 0.5, 1]) cube([cameraLayerWidth, acrylicThickness2, topSectionHeight]);
                translate([((topSectionWidth - 22) / 2) + holeBorder, 0, topSectionHeight - remainingRibbonHeight - 6.5]) {
                    cube([22, acrylicThickness2, 6.5]);
                }
                translate([((topSectionWidth - cameraRibbonWidth) / 2) + holeBorder, 0, topSectionHeight - remainingRibbonHeight]) {
                    cube([cameraRibbonWidth, acrylicThickness2, remainingRibbonHeight]);
                }
            }
        }
        
        panTiltTopSection();
        cameraLayerScrews();
        pirSensor();
    }
}

module cameraBodyFront() {
    difference() {
        translate([0, armDepth + armTopThickness - acrylicThickness3 - acrylicThickness2 - acrylicThickness2, 0]) {
            difference() {
                color([0, 0, 1]) cube([cameraLayerWidth, acrylicThickness2, topSectionHeight]);
                translate([((topSectionWidth - cameraBodyWidth) / 2) + holeBorder, 0, cameraZoffset]) {
                    cube([cameraBodyWidth, acrylicThickness2, cameraBodyHeight]);
                }
                translate([((topSectionWidth - cameraRibbonWidth) / 2) + holeBorder, 0, topSectionHeight - remainingRibbonHeight]) {
                    cube([cameraRibbonWidth, acrylicThickness2, remainingRibbonHeight]);
                }
            }
        }
        
        panTiltTopSection();
        cameraLayerScrews();
        pirSensor();
    }
}

module cameraLense() {
    difference() {
        translate([0, armDepth + armTopThickness - acrylicThickness3 - acrylicThickness2 - acrylicThickness2 - acrylicThickness3, 0]) {
            difference() {
                color([1, 1, 0]) cube([cameraLayerWidth, acrylicThickness3, topSectionHeight]);

                // 6 is calculated by looking at previous thingeverse case
                translate([((topSectionWidth - cameraLenseWidth) / 2) + holeBorder, 0, cameraZoffset + 6]) {
                    cube([cameraLenseWidth, acrylicThickness3, cameraRibbonAndLense]);
                }

                translate([((topSectionWidth - cameraLenseWidth) / 2) + holeBorder + cameraLenseWidth, 0, cameraZoffset + 6 + 11.4]) {
                    cube([cameraLEDWidth, acrylicThickness3, cameraLEDHeight]);
                }
            }
        }
        panTiltTopSection();
        cameraLayerScrews();
        pirSensor();
    }
}

module cameraFront() {
    difference() {
        translate([0, armDepth + armTopThickness - acrylicThickness3 - acrylicThickness2 - acrylicThickness2 - acrylicThickness3 - acrylicThickness3, 0]) {
            difference() {
                color([1, 1, 1]) cube([cameraLayerWidth, acrylicThickness3, topSectionHeight]);

                // 6 is calculated by looking at previous thingeverse case
                translate([((topSectionWidth - cameraLenseWidth) / 2) + holeBorder, 0, cameraZoffset + 6]) {
                    cube([cameraLenseWidth, acrylicThickness3, cameraLenseHeight]);
                }
            }
        }
        panTiltTopSection();
        cameraLayerScrews();
        pirSensor();
    }
}

module clearCover() {
    difference() {
        translate([0, armDepth + armTopThickness - acrylicThickness3 - acrylicThickness2 - acrylicThickness2 - acrylicThickness3 - acrylicThickness3 - acrylicThickness3, 0]) {
            color([1, 1, 0.5]) cube([cameraLayerWidth, acrylicThickness3, topSectionHeight]);
        }
        panTiltTopSection();
        cameraLayerScrews();
        pirSensor();
    }
}

module pirBackLayerSpace() {
    difference() {
        translate([topSectionWidth + holeBorder, (armDepth + armTopThickness - acrylicThickness3 + acrylicThickness3), 0]) {
            color([1, 0, 1]) cube([(pirSensorWidth + (holeBorder * 2)), acrylicThickness3, topSectionHeight]);
        }
        cameraLayerScrews();
        pirSensor();
    }
}

module pirBackLayer() {
    difference() {
        translate([topSectionWidth + holeBorder, (armDepth + armTopThickness - acrylicThickness3 + acrylicThickness3 + acrylicThickness3), 0]) {
            color([0.5, 1, 0.5]) cube([(pirSensorWidth + (holeBorder * 2)), acrylicThickness3, topSectionHeight]);
        }
        cameraLayerScrews();
        pirSensor();
    }
}

module panTiltCamera() {
    // Baser Layer Solid
    baseLayer();

    // Layer to position camera body
    cameraBodyBack();
    cameraBodyFront();

    // Layer to position lense
    cameraLense();

    // Final Layer for lense
    cameraFront();

    // PIR back layers
    pirBackLayerSpace();

    // PIR back layers
    pirBackLayer();
    
    // Clear Front Cover
    clearCover();
}

module projectionMode() {
    padding = 10;
    projection(cut=false) {
        // Baser Layer Solid
        rotate([-90, 0, 0]) {
            baseLayer();
        }

        translate([0, topSectionHeight + padding, 0]) {
        rotate([-90, 0, 0]) {
            cameraBodyBack();
        }
        }
        
        translate([0, (topSectionHeight + padding) * 2, 0]) {
        rotate([-90, 0, 0]) {
            cameraBodyFront();
        }
        }

        translate([0, (topSectionHeight + padding) * 3, 0]) {
        rotate([-90, 0, 0]) {
            cameraLense();
        }
        }

        translate([0, (topSectionHeight + padding) * 4, 0]) {
        rotate([-90, 0, 0]) {
            cameraFront();
        }
        }

        translate([0, (topSectionHeight + padding) * 5, 0]) {
        rotate([-90, 0, 0]) {
            pirBackLayerSpace();
        }
        }

        translate([0, (topSectionHeight + padding) * 6, 0]) {
        rotate([-90, 0, 0]) {
            pirBackLayer();
        }
        }
        
        translate([0, (topSectionHeight + padding) * 7, 0]) {
        rotate([-90, 0, 0]) {
            clearCover();
        }
        }
    }
}

projectionMode();

// panTiltCamera();
