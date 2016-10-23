//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2016 Nicolas Froment
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.0
import MuseScore 1.0

MuseScore {
      version:  "1.0"
      description: "Modify playback for Extended Helmholtz-Ellis"
      menuPath: "Plugins.Notes.Just Intonation (Extended HE)"


      // Apply the given function to all notes in selection
      // or, if nothing is selected, in the entire score

      function applyToNotesInSelection(func) {
            var cursor = curScore.newCursor();
            cursor.rewind(1);
            var startStaff;
            var endStaff;
            var endTick;
            var fullScore = false;
            if (!cursor.segment) { // no selection
                  fullScore = true;
                  startStaff = 0; // start with 1st staff
                  endStaff = curScore.nstaves - 1; // and end with last
            } else {
                  startStaff = cursor.staffIdx;
                  cursor.rewind(2);
                  if (cursor.tick == 0) {
                        // this happens when the selection includes
                        // the last measure of the score.
                        // rewind(2) goes behind the last segment (where
                        // there's none) and sets tick=0
                        endTick = curScore.lastSegment.tick + 1;
                  } else {
                        endTick = cursor.tick;
                  }
                  endStaff = cursor.staffIdx;
            }
            console.log(startStaff + " - " + endStaff + " - " + endTick)
            for (var staff = startStaff; staff <= endStaff; staff++) {
                  for (var voice = 0; voice < 4; voice++) {
                        cursor.rewind(1); // sets voice to 0
                        cursor.voice = voice; //voice has to be set after goTo
                        cursor.staffIdx = staff;

                        if (fullScore)
                              cursor.rewind(0) // if no selection, beginning of score

                        while (cursor.segment && (fullScore || cursor.tick < endTick)) {
                              if (cursor.element && cursor.element.type == Element.CHORD) {
                                    var graceChords = cursor.element.graceNotes;
                                    for (var i = 0; i < graceChords.length; i++) {
                                          // iterate through all grace chords
                                          var notes = graceChords[i].notes;
                                          for (var j = 0; j < notes.length; j++)
                                                func(notes[j]);
                                    }
                                    var notes = cursor.element.notes;
                                    for (var i = 0; i < notes.length; i++) {
                                          var note = notes[i];
                                          func(note);
                                    }
                              }
                              cursor.next();
                        }
                  }
            }
      }

      function adjustTuning(note) {
            var rootTpc = 12 // Bb, the first degree of the scale. it needs to be change if the scale starts on another degree.
            // needs to be a parameter in the UI
            var tpc = note.tpc
            var t = 0
            if (note.accidental) {
                console.log(note.accidental.accType)

                  switch (note.accidental.accType) {
                        case Accidental.DOUBLE_FLAT_ONE_ARROW_DOWN:
                              tpc = tpc - 14
                              t = -21.5
                              break;
                        case Accidental.FLAT_ONE_ARROW_DOWN:
                              tpc = tpc - 7
                              t = -21.5
                              break;
                        case Accidental.NATURAL_ONE_ARROW_DOWN:
                              t = -21.5
                              break;
                        case Accidental.SHARP_ONE_ARROW_DOWN:
                              tpc = tpc + 7
                              t = -21.5
                              break;
                        case Accidental.DOUBLE_SHARP_ONE_ARROW_DOWN:
                              tpc = tpc + 14
                              t = -21.5
                              break;
                        case Accidental.DOUBLE_FLAT_ONE_ARROW_UP:
                              tpc = tpc - 14
                              t = 21.5
                              break;
                        case Accidental.FLAT_ONE_ARROW_UP:
                              tpc = tpc - 7
                              t = 21.5
                              break;
                        case Accidental.NATURAL_ONE_ARROW_UP:
                              t = 21.5
                              break;
                        case Accidental.SHARP_ONE_ARROW_UP:
                              tpc = tpc + 7
                              t = 21.5
                              break;
                        case Accidental.DOUBLE_SHARP_ONE_ARROW_UP:
                              tpc = tpc + 14
                              t = 21.5
                              break;
                        case Accidental.DOUBLE_FLAT_TWO_ARROWS_DOWN:
                              tpc = tpc - 14
                              t = -43
                              break;
                        case Accidental.FLAT_TWO_ARROWS_DOWN:
                              tpc = tpc - 7
                              t = -43
                              break;
                        case Accidental.NATURAL_TWO_ARROWS_DOWN:
                              t = -43
                              break;
                        case Accidental.SHARP_TWO_ARROWS_DOWN:
                              tpc = tpc + 7
                              t = -43
                              break;
                        case Accidental.DOUBLE_SHARP_TWO_ARROWS_DOWN:
                              tpc = tpc + 14
                              t = -43
                              break;
                        case Accidental.DOUBLE_FLAT_TWO_ARROWS_UP:
                              tpc = tpc - 14
                              t = 43
                              break;
                        case Accidental.FLAT_TWO_ARROWS_UP:
                              tpc = tpc - 7
                              t = 43
                              break;
                        case Accidental.NATURAL_TWO_ARROWS_UP:
                              t = 43
                              break;
                        case Accidental.SHARP_TWO_ARROWS_UP:
                              tpc = tpc + 7
                              t = 43
                              break;
                        case Accidental.DOUBLE_SHARP_TWO_ARROWS_UP:
                              tpc = tpc + 14
                              t = 43
                              break;
                        case Accidental.DOUBLE_FLAT_THREE_ARROWS_DOWN:
                              tpc = tpc - 14
                              t = -64.5
                              break;
                        case Accidental.FLAT_THREE_ARROWS_DOWN:
                              tpc = tpc - 7
                              t = -64.5
                              break;
                        case Accidental.NATURAL_THREE_ARROWS_DOWN:
                              t = -64.5
                              break;
                        case Accidental.SHARP_THREE_ARROWS_DOWN:
                              tpc = tpc + 7
                              t = -64.5
                              break;
                        case Accidental.DOUBLE_SHARP_THREE_ARROWS_DOWN:
                              tpc = tpc + 14
                              t = -64.5
                              break;
                        case Accidental.DOUBLE_FLAT_THREE_ARROWS_UP:
                              tpc = tpc - 14
                              t = 64.5
                              break;
                        case Accidental.FLAT_THREE_ARROWS_UP:
                              tpc = tpc - 7
                              t = 64.5
                              break;
                        case Accidental.NATURAL_THREE_ARROWS_UP:
                              t = 64.5
                              break;
                        case Accidental.SHARP_THREE_ARROWS_UP:
                              tpc = tpc + 7
                              t = 64.5
                              break;
                        case Accidental.DOUBLE_SHARP_THREE_ARROWS_UP:
                              tpc = tpc + 14
                              t = 64.5
                              break;

                        case Accidental.DOUBLE_FLAT_EQUAL_TEMPERED:
                              tpc = tpc - 14
                              break;
                        case Accidental.FLAT_EQUAL_TEMPERED:
                              tpc = tpc - 7
                              break;
                        case Accidental.NATURAL_EQUAL_TEMPERED:
                              tpc = tpc
                              break;
                        case Accidental.SHARP_EQUAL_TEMPERED:
                              tpc = tpc + 7
                              break;
                        case Accidental.DOUBLE_SHARP_EQUAL_TEMPERED:
                              tpc = tpc + 14
                              break;

                        case Accidental.LOWER_ONE_SEPTIMAL_COMMA:
                              t += -27.3
                              break;
                        case Accidental.RAISE_ONE_SEPTIMAL_COMMA:
                              t += 27.3
                              break;
                        case Accidental.LOWER_TWO_SEPTIMAL_COMMAS:
                              t += -54.5
                              break;
                        case Accidental.RAISE_TWO_SEPTIMAL_COMMAS:
                              t += 54.5
                              break;
                        case Accidental.LOWER_ONE_UNDECIMAL_QUARTERTONE:
                              t += -53.3
                              break;
                        case Accidental.RAISE_ONE_UNDECIMAL_QUARTERTONE:
                              t += 53.3
                              break;
                        case Accidental.LOWER_ONE_TRIDECIMAL_QUARTERTONE:
                              t += -65.3
                              break;
                        case Accidental.RAISE_ONE_TRIDECIMAL_QUARTERTONE:
                              t += 65.3
                              break;

                  }
            } // accidental null

            for (var i = 0; i < note.elements.length; i++) {
                if (note.elements[i].type == Element.SYMBOL) {
                     var sym = note.elements[i].symbol
                     if (sym === "accidentalLowerOneSeptimalComma")
                           t += -27.3
                     else if (sym === "accidentalRaiseOneSeptimalComma")
                           t += 27.3
                     else if (sym === "accidentalLowerTwoSeptimalCommas")
                           t += -54.5
                     else if (sym === "accidentalRaiseTwoSeptimalCommas")
                           t += 54.5
                     else if (sym === "accidentalLowerOneUndecimalQuartertone")
                           t += - 53.3
                     else if (sym === "accidentalRaiseOneUndecimalQuartertone")
                           t += 53.3
                     else if (sym === "accidentalLowerOneTridecimalQuartertone")
                           t += - 65.3
                     else if (sym === "accidentalRaiseOneTridecimalQuartertone")
                           t += 65.3
                }
            }
            var tuning = (tpc - rootTpc) * 2 + t
            note.tuning = tuning
          }

      onRun: {
            console.log("hello JI HE");

            if (typeof curScore === 'undefined')
                  Qt.quit();

            applyToNotesInSelection(adjustTuning)

            Qt.quit();
         }
}
