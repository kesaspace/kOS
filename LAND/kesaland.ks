run kesalib.


declare parameter ENTRYHEIGHT.
declare parameter STOPSPEED.

set LOG2FILE TO 0.
set h1 to 13000.
set h2 to 9000.
set h3 to 2300.
set h4 to 1300.
set h5 to 250.
set h6 to 50.
set h7 to 20.

MissScrInit().				//PRINT BASIC SCREEN 
LandScrInit().				//PRINT ADDONS FOR LANDING 


PrtLog("STARTING LANDING MANOEUVRE").
SET END_LANDING TO 0.

RCS ON.
SET TSET TO 0.
LOCK STEERING TO SRFRETROGRADE.		// STEERING TO SURFACE RETROGRADE
WAIT 10. 				// SOME WAIT FOR TURNING
LOCK THROTTLE TO TSET.

PrtLog("LANDING MANOEUVRE AT : "+ENTRYHEIGHT).
PrtLog("LANDING BREAKING POINT 1 AT: "+h1).
PrtLog("LANDING BREAKING POINT 2 AT: "+h2).
PrtLog("LANDING BREAKING POINT 3 AT: "+h3).
PrtLog("LANDING BREAKING POINT 4 AT: "+h4).
PrtLog("LANDING BREAKING POINT 5 AT: "+h5).

WHEN SHIP:GROUNDSPEED > STOPSPEED AND SHIP:ALTITUDE > ENTRYHEIGHT THEN {
PrtLog("SLOWING DOWN TO "+STOPSPEED+"m/s HORIZONTAL SPEED"). 
SET TSET TO 1. 
	WHEN SHIP:GROUNDSPEED < STOPSPEED THEN {
	PrtLog("HORIZONTAL SPEED "+round(SHIP:GROUNDSPEED,2)+" REACHED. CUT OFF ENGINE").
	SET TSET TO 0.
	}.
}.


WHEN SHIP:GROUNDSPEED > 15 AND SHIP:ALTITUDE < ENTRYHEIGHT THEN {
PrtLog("THROTTELING HORIZONTAL SPEED TO 1 m/s"). 
PrtLog("SETTING THROTTLE TO TO 80%").
SET TSET TO 0.8.
	WHEN GROUNDSPEED > 15 THEN {
	PrtLog("15 m/s REACHED, SETTING THROTTLE TO TO 30%").
	SET TSET TO 0.3.
		WHEN GROUNDSPEED < 5 THEN {
		PrtLog("5 m/s REACHED, SETTING THROTTLE TO TO 10%").
		SET TSET TO 0.1.
			WHEN GROUNDSPEED < 1 THEN {
			PrtLog("1 m/s REACHED, CUT OFF ENGINE").
			SET TSET TO 0.
			}.
		}.
	}.
}.


WHEN SHIP:ALTITUDE < h1 THEN {
PrtLog("BREAKING MANOEUVRE ("+h1+") at VSpeed: "+round(SHIP:VERTICALSPEED,2)+" TO -75 m/s").
SET TSET TO 1.
	WHEN SHIP:VERTICALSPEED > -50 THEN {
	PrtLog("END BREAK. MAN. ("+h1+") AT RADAR ALT "+round(ALT:RADAR,2)).
	SET TSET TO 0.
	}.
}.

WHEN SHIP:ALTITUDE < h2 THEN {
PrtLog("BREAKING MANOEUVRE ("+h2+") at VSpeed: "+round(SHIP:VERTICALSPEED,2)+" TO -50 m/s").
SET TSET TO 1.
	WHEN SHIP:VERTICALSPEED > -50 THEN {
	PrtLog("END BREAK. MAN. ("+h2+") AT RADAR ALT "+round(ALT:RADAR,2)).
	SET TSET TO 0.
	}.
}.

WHEN ALT:RADAR < h3 THEN {
PrtLog("USING RADAR ALTITUDE").
PrtLog("BREAKING MANOEUVRE ("+h3+") at VSpeed: "+round(SHIP:VERTICALSPEED,2)+" TO -40 m/s").
PrtLog("DEPLOYING LANDING LEGS").
LEGS ON.
SET TSET TO 1.
	WHEN SHIP:VERTICALSPEED > -40 THEN {
	PrtLog("END BREAK.MAN. ("+h3+") AT RADAR ALT "+round(ALT:RADAR,2)).
	SET TSET TO 0.
	}.
}.

WHEN ALT:RADAR < h4 THEN {
PrtLog("BREAKING MAN. ("+h4+") at VSpeed: "+round(SHIP:VERTICALSPEED,2)+" TO -20 m/s").
SET TSET TO 1.
	WHEN SHIP:VERTICALSPEED > -20 THEN {
	PrtLog("END BREAK. MAN. ("+h4+") AT RADAR ALT "+round(ALT:RADAR,2)).
	SET TSET TO 0.
	}.
}.

WHEN ALT:RADAR < h5 THEN {
PrtLog("BEGINN FINAL LANDING SEQUENCE").
PrtLog("BREAKING MAN. ("+h5+") at VSpeed: "+round(SHIP:VERTICALSPEED,2)+" TO -5 m/s").
SET TSET TO 1.
	WHEN SHIP:VERTICALSPEED > -5 THEN {
	PrtLog("END BREAK. MAN.("+h5+") AT RADAR ALT "+round(ALT:RADAR,2)).
	SET TSET TO 0.
	}.
}.

WHEN ALT:RADAR < h6 THEN {
PrtLog("FINAL LANDING SEQUENCE").
PrtLog("BREAKING MAN. ("+h6+") at VSpeed: "+round(SHIP:VERTICALSPEED,2)+" TO -3 m/s").
SET TSET TO 1.
	WHEN SHIP:VERTICALSPEED > -3 THEN {
	PrtLog("END BREAK. MAN. ("+h6+") AT RADAR ALT "+round(ALT:RADAR,2)).
	SET TSET TO 0.
	}.
}.

WHEN ALT:RADAR < h7 THEN {
PrtLog("BREAKING MAN. ("+h7+") at VSpeed: "+round(SHIP:VERTICALSPEED,2)+" TO -3 m/s").
SET TSET TO 1.
	WHEN SHIP:VERTICALSPEED > -3 THEN {
	PrtLog("END BREAK. MAN. ("+h7+") AT RADAR ALT "+round(ALT:RADAR,2)).
	SET TSET TO 0.
	}.
}.

WHEN STAGE:LIQUIDFUEL < 1 THEN {
	PrtLog("LIQ.FUEL END - STAGING").
	STAGE.
	WAIT 3.
	PrtLog("STARTING NEXT ENGINE").
	STAGE.
	PRESERVE.
}.

WAIT UNTIL END_LANDING = 1.
