-- Змінена схема (навмисно порушує норми кодування)

create table cells (
	cell_num SMALLINT not null,
	marker_num SMALLINT not null,
	constraint cells_pk primary key (cell_num ),
	constraint cells_marker_uq unique (marker_num),
	constraint cells_cell_ck check (cell_num between 1 and 9),
	constraint cells_marker_ck check (marker_num between 0 and 49)
)

create table tokens (
	marker_num SMALLINT not null,
	figure_name VARCHAR(1) not null,
	constraint tokens_pk primary key (marker_num),
	constraint tokens_marker_ck check (marker_num between 0 and 49),
	-- регулярний вираз: лише велика латинська X або O
	constraint tokens_figure_ck check (figure_name ~ '^[XO]$')
)

create table error_reasons (
	reason_name VARCHAR(20) not null,
	message_text VARCHAR(100) not null,
	constraint error_reasons_pk primary key (reason_name),
	-- регулярний вираз: великі латинські слова через підкреслення
	constraint error_reasons_name_ck check (
		reason_name ~ '^[A-Z]+(_[A-Z]+)*$'
	),
	constraint error_reasons_text_ck check (
		LENGTH(TRIM(message_text)) > 0
	)
)

create table games (
	game_id INTEGER generated always as identity,
	start_date TIMESTAMP not null default CURRENT_TIMESTAMP,
	turn_figure_name VARCHAR(1) not null default 'X',
	result_status VARCHAR(10),
	constraint games_pk primary key (game_id),
	constraint games_turn_ck check (turn_figure_name ~ '^[XO]$'),
	-- NULL, доки партію не завершено
	constraint games_result_ck check (
		result_status ~ '^(X_WIN|O_WIN|DRAW)$'
	)
)

create table moves (
	game_id INTEGER not null,
	move_seq SMALLINT not null,
	cell_num SMALLINT not null,
	token_marker_num SMALLINT not null,
	constraint moves_pk primary key (game_id, move_seq),
	constraint moves_cell_uq unique (game_id, cell_num),
	constraint moves_token_uq unique (game_id, token_marker_num),
	constraint moves_seq_ck check (move_seq between 1 and 9),
	constraint moves_game_fk foreign key (game_id)
	references games (game_id) on delete cascade,
	constraint moves_cell_fk foreign key (cell_num )
	references cells (cell_num ),
	constraint moves_token_fk foreign key (token_marker_num)
	references tokens (marker_num)
)

create table rejected_moves (
	game_id INTEGER not null,
	reject_seq SMALLINT not null,
	reason_name VARCHAR(20) not null,
	cell_num SMALLINT,
	token_marker_num SMALLINT,
	constraint rejected_moves_pk primary key (game_id, reject_seq),
	constraint rejected_moves_seq_ck check (reject_seq >= 1),
	constraint rejected_moves_game_fk foreign key (game_id)
	references games (game_id) on delete cascade,
	constraint rejected_moves_reason_fk foreign key (reason_name)
	references error_reasons (reason_name),
	constraint rejected_moves_cell_fk foreign key (cell_num )
	references cells (cell_num ),
	constraint rejected_moves_token_fk foreign key (token_marker_num)
	references tokens (marker_num)
)
