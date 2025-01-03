IDENTIFICATION DIVISION.
PROGRAM-ID. ReadMultipleRecords.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT INPUT-FILE ASSIGN TO "personas.txt"
       ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD INPUT-FILE.
01 INPUT-RECORD PIC X(80).

WORKING-STORAGE SECTION.
01 WS-NAME PIC X(20).
01 WS-AGE PIC XX.
01 EOF-FLAG PIC X VALUE "N".
01 WS-NUMERIC-FLAG PIC X VALUE "N".
01 WS-AGE-CHECK PIC 9 VALUE 1.       *> Contador para recorrer los caracteres de WS-AGE
01 TOTAL-VALID-RECORDS PIC 9(4) VALUE 0. *> Contador de registros válidos
01 TOTAL-INVALID-RECORDS PIC 9(4) VALUE 0. *> Contador de registros inválidos

PROCEDURE DIVISION.
    OPEN INPUT INPUT-FILE.

    PERFORM UNTIL EOF-FLAG = "Y"
        READ INPUT-FILE INTO INPUT-RECORD
            AT END MOVE "Y" TO EOF-FLAG
            NOT AT END
                MOVE INPUT-RECORD (1:20) TO WS-NAME
                MOVE INPUT-RECORD (21:2) TO WS-AGE

                *> Validar el nombre
                IF WS-NAME = SPACES
                    DISPLAY "Error: Nombre vacío o en blanco. Registro ignorado."
                    ADD 1 TO TOTAL-INVALID-RECORDS
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
                        ADD 1 TO TOTAL-INVALID-RECORDS
                    ELSE
                        DISPLAY "Nombre: " WS-NAME " | Edad: " WS-AGE
                        ADD 1 TO TOTAL-VALID-RECORDS
                    END-IF
                END-IF
        END-READ
    END-PERFORM.

    CLOSE INPUT-FILE.

    *> Mostrar resumen
    DISPLAY "Resumen del procesamiento:"
    DISPLAY "Registros válidos: " TOTAL-VALID-RECORDS
    DISPLAY "Registros inválidos: " TOTAL-INVALID-RECORDS
    DISPLAY "Fin del archivo.".
    STOP RUN.
