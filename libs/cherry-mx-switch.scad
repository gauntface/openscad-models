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

nothing=0.01; // See https://3dprinting.stackexchange.com/questions/9794/how-to-prevent-z-fighting-in-openscad

cherryKeyCapH = 6.6;
cherryKeyCapXY = 15.6;

cherrySwitchH = 5;
cherrySwitchXY = 14;

pinH = 3.3;

module cherrymxPlate(kerf = 0.5) {
    xy = cherrySwitchXY - kerf;
    union() {
        translate([0, 0, cherryKeyCapH / 2])
        color("#0be881") cube([xy, xy, cherryKeyCapH], center=true);
        
        translate([0, 0, -2.5])
        color("#ffc048") cube([xy, xy, cherrySwitchH + nothing], center=true);
        
        translate([0, 0, -(cherrySwitchH + (pinH / 2))])
        color("#ffdd59") cube([xy, xy, pinH + nothing], center=true);
    }
}

module cherrymxSwitch() {
    union() {
        translate([0, 0, cherryKeyCapH / 2])
        color("#ef5777") cube([cherryKeyCapXY, cherryKeyCapXY, cherryKeyCapH], center=true);
        
        translate([0, 0, -(cherrySwitchH / 2)])
        color("#575fcf") cube([cherrySwitchXY, cherrySwitchXY, cherrySwitchH], center=true);
        
        translate([0, 0, -(cherrySwitchH + (pinH / 2))])
        color("#4bcffa") cube([cherrySwitchXY, cherrySwitchXY, pinH], center=true);
    }
}

// cherrymxSwitch();

// cherrymxPlate();

module demoPlate() {
    projection() {
        difference() {
            cube([(19.5 * 3) + 8, 19.5 + 8, 3]);

            // 13.85mm
            c = 19.5/2 + 4;
            translate([c, c, 0]) cherrymxPlate(kerf = 0.25);

            // 13.5mm
            translate([c + 19.5, c, 0]) cherrymxPlate(kerf = 0.5);

            // 13mm
            translate([c + (19.5 * 2), c, 0]) cherrymxPlate(kerf = 1);
        }
    }
}

// demoPlate();