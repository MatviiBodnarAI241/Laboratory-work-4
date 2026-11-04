-- Фізична схема БД TicTacAR (PostgreSQL 16)

CREATE TABLE cells (
    cell_num SMALLINT NOT NULL,
    marker_num SMALLINT NOT NULL,
    CONSTRAINT cells_pk PRIMARY KEY (cell_num),
    CONSTRAINT cells_marker_uq UNIQUE (marker_num),
    CONSTRAINT cells_cell_ck CHECK (cell_num BETWEEN 1 AND 9),
    CONSTRAINT cells_marker_ck CHECK (marker_num BETWEEN 0 AND 49)
);

CREATE TABLE tokens (
    marker_num SMALLINT NOT NULL,
    figure_name VARCHAR(1) NOT NULL,
    CONSTRAINT tokens_pk PRIMARY KEY (marker_num),
    CONSTRAINT tokens_marker_ck CHECK (marker_num BETWEEN 0 AND 49),
    -- регулярний вираз: лише велика латинська X або O
    CONSTRAINT tokens_figure_ck CHECK (figure_name ~ '^[XO]$')
);

CREATE TABLE error_reasons (
    reason_name VARCHAR(20) NOT NULL,
    message_text VARCHAR(100) NOT NULL,
    CONSTRAINT error_reasons_pk PRIMARY KEY (reason_name),
    -- регулярний вираз: великі латинські слова через підкреслення
    CONSTRAINT error_reasons_name_ck CHECK (
        reason_name ~ '^[A-Z]+(_[A-Z]+)*$'
    ),
    CONSTRAINT error_reasons_text_ck CHECK (
        LENGTH(TRIM(message_text)) > 0
    )
);

CREATE TABLE games (
    game_id INTEGER GENERATED ALWAYS AS IDENTITY,
    start_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    turn_figure_name VARCHAR(1) NOT NULL DEFAULT 'X',
    result_status VARCHAR(10),
    CONSTRAINT games_pk PRIMARY KEY (game_id),
    CONSTRAINT games_turn_ck CHECK (turn_figure_name ~ '^[XO]$'),
    -- NULL, доки партію не завершено
    CONSTRAINT games_result_ck CHECK (
        result_status ~ '^(X_WIN|O_WIN|DRAW)$'
    )
);

CREATE TABLE moves (
    game_id INTEGER NOT NULL,
    move_seq SMALLINT NOT NULL,
    cell_num SMALLINT NOT NULL,
    token_marker_num SMALLINT NOT NULL,
    CONSTRAINT moves_pk PRIMARY KEY (game_id, move_seq),
    CONSTRAINT moves_cell_uq UNIQUE (game_id, cell_num),
    CONSTRAINT moves_token_uq UNIQUE (game_id, token_marker_num),
    CONSTRAINT moves_seq_ck CHECK (move_seq BETWEEN 1 AND 9),
    CONSTRAINT moves_game_fk FOREIGN KEY (game_id)
    REFERENCES games (game_id) ON DELETE CASCADE,
    CONSTRAINT moves_cell_fk FOREIGN KEY (cell_num)
    REFERENCES cells (cell_num),
    CONSTRAINT moves_token_fk FOREIGN KEY (token_marker_num)
    REFERENCES tokens (marker_num)
);

CREATE TABLE rejected_moves (
    game_id INTEGER NOT NULL,
    reject_seq SMALLINT NOT NULL,
    reason_name VARCHAR(20) NOT NULL,
    cell_num SMALLINT,
    token_marker_num SMALLINT,
    CONSTRAINT rejected_moves_pk PRIMARY KEY (game_id, reject_seq),
    CONSTRAINT rejected_moves_seq_ck CHECK (reject_seq >= 1),
    CONSTRAINT rejected_moves_game_fk FOREIGN KEY (game_id)
    REFERENCES games (game_id) ON DELETE CASCADE,
    CONSTRAINT rejected_moves_reason_fk FOREIGN KEY (reason_name)
    REFERENCES error_reasons (reason_name),
    CONSTRAINT rejected_moves_cell_fk FOREIGN KEY (cell_num)
    REFERENCES cells (cell_num),
    CONSTRAINT rejected_moves_token_fk FOREIGN KEY (token_marker_num)
    REFERENCES tokens (marker_num)
);
