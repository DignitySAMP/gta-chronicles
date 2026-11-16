#tryinclude <a_samp>
#tryinclude <a_mysql>
#tryinclude <YSI_Extra\y_inline_mysql>

new MySQL:mysql;

stock cache_get_data(&rows, &fields, MySQL:handle = MYSQL_DEFAULT_HANDLE) {
	rows = cache_num_rows();
	fields = cache_num_fields();
	return 1;
}

stock cache_get_row_int(row, column, MySQL:handle = MYSQL_DEFAULT_HANDLE) {
	new value;

	cache_get_value_index_int(row, column, value);
	return value;
}

stock cache_get_field_content(row, const field_name[], destination[], MySQL:handle = MYSQL_DEFAULT_HANDLE, max_len = sizeof(destination)) {
	return cache_get_value_name(row, field_name, destination, max_len);
}

stock Float:cache_get_field_float(row, const field_name[]) {
	new str[16];

	cache_get_value_name(row, field_name, str, sizeof(str));
	return floatstr(str);
}

stock cache_get_field_int(row, const field_name[]) {
	new str[12];

	cache_get_value_name(row, field_name, str, sizeof(str));
	return strval(str);
}

stock Float:cache_get_field_content_float(row, const field_name[], MySQL:handle = MYSQL_DEFAULT_HANDLE) {
	new str[16];

	cache_get_value_name(row, field_name, str, sizeof(str));
	return floatstr(str);
}

stock cache_get_field_content_int(row, const field_name[], MySQL:handle = MYSQL_DEFAULT_HANDLE) {
	new str[12];

	cache_get_value_name(row, field_name, str, sizeof(str));
	return strval(str);
}

#define mysql_tquery_inline(%0,%1,%2,%3) \
	MySQL_TQueryInline(%0, %2, "%s", %1)

MySQL_Init()
{
    mysql_log(ERROR | WARNING);

    mysql = mysql_connect_file();

    if(mysql_errno(mysql) != 0) return print(" * [SQL] Could not connect to database!\n");
	return print(" * [SQL] Connected to database ");
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	switch(errorid)
	{
		case CR_SERVER_GONE_ERROR:
		{
			printf(" * [SQL] Lost connection to server, trying reconnect...");
		}
		case ER_SYNTAX_ERROR:
		{
			printf(" * [SQL] Something is wrong in your syntax, query: %s",query);
		}
	}
	return 1;
}
