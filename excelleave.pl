{
	name => 'Leave Management System',
	'Model::Leave' => {
		traits       => "Caching",
		cursor_class => "DBIx::Class::Cursor::Cached",
		connect_info => {
			dsn               => "dbi:Pg:database=ExcelLeave",
			user              => "staging",
			password          => "staging",
			quote_field_names => "0",
			quote_char        => "\"",
			name_sep          => ".",
			array_datatypes   => "1",
		},
	},
	baseurl => 'http://dev01.blr.exceleron.in:8000'
}

