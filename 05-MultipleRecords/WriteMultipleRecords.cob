IDENTIFICATION DIVISION.
PROGRAM-ID. WriteMultipleRecords.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT OUTPUT-FILE ASSIGN TO "personas.txt"
       ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD OUTPUT-FILE.
01 OUTPUT-RECORD PIC X(80).

WORKING-STORAGE SECTION.
01 WS-NAME PIC X(20).      *> Nombre ajustado a 20 caracteres
01 WS-AGE PIC XX.          *> Edad ajustada a 2 caracteres
01 WS-CONTINUE PIC X VALUE "Y".

PROCEDURE DIVISION.
    OPEN OUTPUT OUTPUT-FILE.
    
    PERFORM UNTIL WS-CONTINUE = "N"
        MOVE SPACES TO OUTPUT-RECORD            *> Limpiar el registro
        DISPLAY "Introduce el nombre (máx. 20 caracteres): " WITH NO ADVANCING
        ACCEPT WS-NAME
        DISPLAY "Introduce la edad (máx. 2 dígitos): " WITH NO ADVANCING
        ACCEPT WS-AGE
        MOVE WS-NAME TO OUTPUT-RECORD (1:20)    *> Mover nombre
        MOVE WS-AGE TO OUTPUT-RECORD (21:2)     *> Mover edad
        WRITE OUTPUT-RECORD                     *> Escribir registro
        DISPLAY "¿Quieres continuar? (Y/N): " WITH NO ADVANCING
        ACCEPT WS-CONTINUE
    END-PERFORM.
    
    CLOSE OUTPUT-FILE.
    DISPLAY "Los datos han sido escritos en 'personas.txt'".
    STOP RUN.
