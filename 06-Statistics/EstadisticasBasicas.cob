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
01 WS-AGE PIC 99.                  *> Edad ahora numérica
01 EOF-FLAG PIC X VALUE "N".
01 WS-NUMERIC-FLAG PIC X VALUE "N".
01 WS-AGE-CHECK PIC 9 VALUE 1.     *> Contador para recorrer WS-AGE
01 TOTAL-VALID-RECORDS PIC 9(4) VALUE 0.
01 TOTAL-INVALID-RECORDS PIC 9(4) VALUE 0.
01 SUM-AGE PIC 9(6) VALUE 0.       *> Suma total de edades
01 MAX-AGE PIC 99 VALUE 0.         *> Edad máxima
01 MIN-AGE PIC 99 VALUE 99.        *> Edad mínima
01 AVG-AGE PIC 99V99 VALUE 0.      *> Edad promedio

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
                        ADD WS-AGE TO SUM-AGE
                        IF WS-AGE > MAX-AGE
                            MOVE WS-AGE TO MAX-AGE
                        END-IF
                        IF WS-AGE < MIN-AGE
                            MOVE WS-AGE TO MIN-AGE
                        END-IF
                    END-IF
                END-IF
        END-READ
    END-PERFORM.

    CLOSE INPUT-FILE.

    *> Mostrar resumen
    DISPLAY "Resumen del procesamiento:"
    DISPLAY "Registros válidos: " TOTAL-VALID-RECORDS
    DISPLAY "Registros inválidos: " TOTAL-INVALID-RECORDS
    IF TOTAL-VALID-RECORDS > 0
        COMPUTE AVG-AGE = SUM-AGE / TOTAL-VALID-RECORDS
        DISPLAY "Edad promedio: " AVG-AGE
        DISPLAY "Edad máxima: " MAX-AGE
        DISPLAY "Edad mínima: " MIN-AGE
    ELSE
        DISPLAY "No se procesaron registros válidos."
    END-IF

    DISPLAY "Fin del archivo.".
    STOP RUN.
