create table TEST
(
    ID           integer
        constraint TEST_pk
            primary key autoincrement,
    DT           TEXT,
    ACCESSION    TEXT,
    PATIENT_NAME TEXT,
    TEST_NAME    TEXT
);

