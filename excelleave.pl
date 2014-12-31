{
	name => 'Leave Management System',
	'Model::Leave' => {
		traits       => "Caching",
		cursor_class => "DBIx::Class::Cursor::Cached",
		connect_info => {
			dsn               => "dbi:Pg:database=ExcelLeave",
			user              => "pavan",
			password          => "1234",
			quote_field_names => "0",
			quote_char        => "\"",
			name_sep          => ".",
			array_datatypes   => "1",
		},
	},
}

