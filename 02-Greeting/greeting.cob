IDENTIFICATION DIVISION.
PROGRAM-ID. Greeting.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 USER-INFO.
   02 USER-NAME PIC A(20).
   02 AGE       PIC 99.

PROCEDURE DIVISION.
    DISPLAY "Por favor, introduce tu nombre:".
    ACCEPT USER-NAME.
    DISPLAY "Por favor, introduce tu edad:".
    ACCEPT AGE.
    DISPLAY "Hola, " USER-NAME "! Tienes " AGE " años.".
    STOP RUN.
