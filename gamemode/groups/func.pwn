Group_GetEnumID(sql_id) {

	foreach(new groupid: Groups) {

		if ( Group [ groupid ] [ E_GROUP_DATA_SQLID ] == sql_id ) {

			return groupid ;
		}

		else continue ;
	}

	return INVALID_GROUP_ID ;
}