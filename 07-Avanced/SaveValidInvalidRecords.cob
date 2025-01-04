IDENTIFICATION DIVISION.
PROGRAM-ID. SaveValidInvalidRecords.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT INPUT-FILE ASSIGN TO "personas.txt"
       ORGANIZATION IS LINE SEQUENTIAL.
    SELECT VALID-FILE ASSIGN TO "validos.txt"
       ORGANIZATION IS LINE SEQUENTIAL.
    SELECT INVALID-FILE ASSIGN TO "invalidos.txt"
       ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD INPUT-FILE.
01 INPUT-RECORD PIC X(80).

FD VALID-FILE.
01 VALID-RECORD PIC X(80).

FD INVALID-FILE.
01 INVALID-RECORD PIC X(80).

WORKING-STORAGE SECTION.
01 WS-NAME PIC X(20).
01 WS-AGE PIC XX.
01 EOF-FLAG PIC X VALUE "N".
01 WS-NUMERIC-FLAG PIC X VALUE "N".
01 WS-AGE-CHECK PIC 9 VALUE 1.

PROCEDURE DIVISION.
    OPEN INPUT INPUT-FILE
         OUTPUT VALID-FILE
         OUTPUT INVALID-FILE.

    PERFORM UNTIL EOF-FLAG = "Y"
        READ INPUT-FILE INTO INPUT-RECORD
            AT END MOVE "Y" TO EOF-FLAG
            NOT AT END
                MOVE INPUT-RECORD (1:20) TO WS-NAME
                MOVE INPUT-RECORD (21:2) TO WS-AGE

                *> Validar el nombre
                IF WS-NAME = SPACES
                    DISPLAY "Error: Nombre vacío o en blanco. Registro guardado como inválido."
                    MOVE INPUT-RECORD TO INVALID-RECORD
                    WRITE INVALID-RECORD
                ELSE
                    *> Validar que la edad sea numérica
                    MOVE 1 TO WS-AGE-CHECK
                    MOVE "Y" TO WS-NUMERIC-FLAG
                    PERFORM VARYING WS-AGE-CHECK FROM 1 BY 1 UNTIL WS-AGE-CHECK > 2
                        IF WS-AGE(WS-AGE-CHECK:1) NOT NUMERIC
                            MOVE "N" TO WS-NUMERIC-FLAG
                            EXIT PERFORM
                        END-IF
                    END-PERFORM

                    IF WS-NUMERIC-FLAG = "N"
                        DISPLAY "Error: Edad no válida para el nombre: " WS-NAME
                        MOVE INPUT-RECORD TO INVALID-RECORD
                        WRITE INVALID-RECORD
                    ELSE
                        DISPLAY "Nombre: " WS-NAME " | Edad: " WS-AGE
                        MOVE INPUT-RECORD TO VALID-RECORD
                        WRITE VALID-RECORD
                    END-IF
                END-IF
        END-READ
    END-PERFORM.

    CLOSE INPUT-FILE
          VALID-FILE
          INVALID-FILE.

    DISPLAY "Registros válidos guardados en 'validos.txt'."
    DISPLAY "Registros inválidos guardados en 'invalidos.txt'."
    DISPLAY "Fin del procesamiento.".
    STOP RUN.
