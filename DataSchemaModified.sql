CREATE TABLE students (
        student_id INTEGER GENERATED ALWAYS AS IDENTITY,
    surname VARCHAR(50)  NOT NULL ,
    CONSTRAINT students_pk PRIMARY KEY (student_id)
    )
