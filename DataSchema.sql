CREATE TABLE students (
    student_id INTEGER GENERATED ALWAYS AS IDENTITY,
    surname VARCHAR(50) NOT NULL,
    CONSTRAINT students_pk PRIMARY KEY (student_id),
    CONSTRAINT students_surname_ck CHECK (
        surname ~ '^[А-ЩЬЮЯҐЄІЇ][а-щьюяґєіїʼ''-]+'
        '(-[А-ЩЬЮЯҐЄІЇ][а-щьюяґєіїʼ''-]+)?$'
    )
);

CREATE TABLE attempts (
    attempt_id INTEGER GENERATED ALWAYS AS IDENTITY,
    student_id INTEGER NOT NULL,
    start_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finish_date TIMESTAMP,
    CONSTRAINT attempts_pk PRIMARY KEY (attempt_id),
    CONSTRAINT attempts_students_fk FOREIGN KEY (student_id)
    REFERENCES students (student_id),
    CONSTRAINT attempts_finish_ck CHECK (
        finish_date IS NULL OR finish_date >= start_date
    )
);

CREATE TABLE component_cards (
    card_id INTEGER GENERATED ALWAYS AS IDENTITY,
    card_name VARCHAR(30) NOT NULL,
    marker_num SMALLINT NOT NULL,
    expected_num SMALLINT NOT NULL,
    CONSTRAINT component_cards_pk PRIMARY KEY (card_id),
    CONSTRAINT component_cards_name_uk UNIQUE (card_name),
    CONSTRAINT component_cards_marker_uk UNIQUE (marker_num),
    CONSTRAINT component_cards_expected_uk UNIQUE (expected_num),
    CONSTRAINT component_cards_name_ck CHECK (
        card_name ~ '^[А-ЩЬЮЯҐЄІЇ][а-щьюяґєії ]+$'
    ),
    CONSTRAINT component_cards_marker_ck CHECK (marker_num BETWEEN 0 AND 49),
    CONSTRAINT component_cards_expected_ck CHECK (expected_num BETWEEN 1 AND 6)
);

CREATE TABLE placements (
    placement_id INTEGER GENERATED ALWAYS AS IDENTITY,
    attempt_id INTEGER NOT NULL,
    card_id INTEGER NOT NULL,
    placed_num SMALLINT NOT NULL,
    placement_status VARCHAR(7) NOT NULL,
    placement_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT placements_pk PRIMARY KEY (placement_id),
    CONSTRAINT placements_attempts_fk FOREIGN KEY (attempt_id)
    REFERENCES attempts (attempt_id),
    CONSTRAINT placements_cards_fk FOREIGN KEY (card_id)
    REFERENCES component_cards (card_id),
    CONSTRAINT placements_placed_ck CHECK (placed_num BETWEEN 1 AND 6),
    CONSTRAINT placements_status_ck CHECK (
        placement_status IN ('correct', 'wrong')
    )
);
