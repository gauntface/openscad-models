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

topH = 6.6;
topXY = 15.6;

innerH = 5;
innerXY = 13.95;

pinH = 3.3;

railW = 3.5;
railD = 0.8;
railFromEdge = 2.75;

module cherrymxPlate() {
    union() {
        translate([0, 0, topH / 2])
        color("#0be881") cube([innerXY, innerXY, topH], center=true);
        
        translate([0, 0, -2.5])
        color("#ffc048") cube([innerXY, innerXY, innerH + nothing], center=true);
        
        translate([0, 0, -(innerH + (pinH / 2))])
        color("#ffdd59") cube([innerXY, innerXY, pinH + nothing], center=true);

        railH = topH + innerH + pinH;
        translate([-7 + railFromEdge, -(innerXY / 2) - (railD / 2), (railH / 2) - (innerH + pinH)])
        color("#ff5e57") cube([railW, railD + nothing, railH], center=true);
        
        translate([7 - railFromEdge, -(innerXY / 2) - (railD / 2), (railH / 2) - (innerH + pinH)])
        color("#ff5e57") cube([railW, railD + nothing, railH], center=true);
        
        translate([-7 + railFromEdge, (innerXY / 2) + (railD / 2), (railH / 2) - (innerH + pinH)])
        color("#ff5e57") cube([railW, railD + nothing, railH], center=true);
        
        translate([7 - railFromEdge, (innerXY / 2) + (railD / 2), (railH / 2) - (innerH + pinH)])
        color("#ff5e57") cube([railW, railD + nothing, railH], center=true);
    }
}

module cherrymxSwitch() {
    union() {
        translate([0, 0, topH / 2])
        color("#ef5777") cube([topXY, topXY, topH], center=true);
        
        translate([0, 0, -(innerH / 2)])
        color("#575fcf") cube([innerXY, innerXY, innerH], center=true);
        
        translate([0, 0, -(innerH + (pinH / 2))])
        color("#4bcffa") cube([innerXY, innerXY, pinH], center=true);
    }
}

// cherrymxSwitch();

// cherrymxPlate();