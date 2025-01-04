IDENTIFICATION DIVISION.
PROGRAM-ID. SaveValidRecordsToCSV.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT INPUT-FILE ASSIGN TO "personas.txt"
       ORGANIZATION IS LINE SEQUENTIAL.
    SELECT CSV-FILE ASSIGN TO "validos.csv"
       ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD INPUT-FILE.
01 INPUT-RECORD PIC X(80).

FD CSV-FILE.
01 CSV-RECORD PIC X(80).

WORKING-STORAGE SECTION.
01 WS-NAME PIC X(20).
01 WS-AGE PIC XX.
01 WS-NUMERIC-FLAG PIC X VALUE "N".
01 WS-AGE-CHECK PIC 9 VALUE 1.
01 EOF-FLAG PIC X VALUE "N".
01 CSV-HEADER PIC X(80) VALUE "Nombre,Edad".

PROCEDURE DIVISION.
    OPEN INPUT INPUT-FILE
         OUTPUT CSV-FILE.

    *> Escribir encabezado en el archivo CSV
    WRITE CSV-RECORD FROM CSV-HEADER.

    PERFORM UNTIL EOF-FLAG = "Y"
        READ INPUT-FILE INTO INPUT-RECORD
            AT END MOVE "Y" TO EOF-FLAG
            NOT AT END
                MOVE SPACES TO CSV-RECORD           *> Limpiar CSV-RECORD
                MOVE INPUT-RECORD (1:20) TO WS-NAME
                MOVE INPUT-RECORD (21:2) TO WS-AGE

                *> Validar que el nombre no esté vacío
                IF WS-NAME = SPACES
                    DISPLAY "Error: Nombre vacío. Registro ignorado."
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

                    IF WS-NUMERIC-FLAG = "Y"
                        *> Crear registro CSV
                        STRING WS-NAME DELIMITED BY SPACE
                               "," DELIMITED BY SIZE
                               WS-AGE DELIMITED BY SIZE
                               INTO CSV-RECORD
                        WRITE CSV-RECORD
                    ELSE
                        DISPLAY "Error: Edad no válida para el nombre: " WS-NAME
                    END-IF
                END-IF
        END-READ
    END-PERFORM.

    CLOSE INPUT-FILE
          CSV-FILE.

    DISPLAY "Registros válidos exportados a 'validos.csv'."
    STOP RUN.
