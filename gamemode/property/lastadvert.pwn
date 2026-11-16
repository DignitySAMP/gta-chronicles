/*

#include <a_samp>
#include <strlib>

enum E_LAST_ADVERTS {

	E_LAST_ADVERT_AI,
	E_LAST_ADVERT_TIMESTAMP,
	E_LAST_ADVERT_PLACEDBY[MAX_PLAYER_NAME],
	E_LAST_ADVERT_TEXT[64]
} ;

#if !defined MAX_LAST_ADVERTS
	#define MAX_LAST_ADVERTS	20
#endif
#if !defined INVALID_LAST_ADVERT
	#define INVALID_LAST_ADVERT	-1
#endif

new LastAdverts [ MAX_LAST_ADVERTS ] [ E_LAST_ADVERTS ] ;

public OnFilterScriptInit() {

	LastAdvert_ClearIDs() ;

	for ( new i, j = sizeof ( LastAdverts ); i < j ; i ++ ) {
		LastAdvert_SaveSubmission(sprintf("Hades_%d", i ), sprintf("Test %d", i ) ) ;
	}

	
	for ( new i, j = 5; i < j ; i ++ ) {
		LastAdvert_SaveSubmission(sprintf("Overflow_Hades_%d", i ), sprintf("Overflow Test %d", i ) ) ;
	}

	LastAdvert_SaveSubmission("Overflow_Hades_FINAL", "This string should be put FIRST in the array, as it is the LAST one to be added." ) ;

	for ( new i, j = sizeof ( LastAdverts ); i < j ; i ++ ) {
		printf("Displaying submission (%d) ID %d at %d with text \"%s\" by \"%s\".",
			i,
			LastAdverts [ i] [ E_LAST_ADVERT_AI ],
			LastAdverts [ i] [ E_LAST_ADVERT_TIMESTAMP ],
			LastAdverts [ i] [ E_LAST_ADVERT_TEXT ],
			LastAdverts [ i] [ E_LAST_ADVERT_PLACEDBY ] 	
		);
	}


	return true ;
}

LastAdvert_SaveSubmission(name[], text[]) {

	new index = LastAdvert_GetFreeID() ;

	LastAdverts [ index ] [ E_LAST_ADVERT_AI ] 			= index ;
	LastAdverts [ index ] [ E_LAST_ADVERT_TIMESTAMP ] 	= gettime() ;

	format(LastAdverts [ index ] [ E_LAST_ADVERT_PLACEDBY ], 	MAX_PLAYER_NAME, 	"%s",  name );
	format(LastAdverts [ index ] [ E_LAST_ADVERT_TEXT ], 		64, 				"%s",  text );

	printf("Saved submission ID %d at %d with text \"%s\" by \"%s\".",
		LastAdverts [ index ] [ E_LAST_ADVERT_AI ],
		LastAdverts [ index ] [ E_LAST_ADVERT_TIMESTAMP ],
		LastAdverts [ index ] [ E_LAST_ADVERT_TEXT ],
		LastAdverts [ index ] [ E_LAST_ADVERT_PLACEDBY ] 	
	);

	return index ;
}

LastAdvert_ClearIDs() {

	for ( new i, j = sizeof ( LastAdverts ); i < j ; i ++ ) {

		LastAdverts [ i ] [ E_LAST_ADVERT_AI ] = INVALID_LAST_ADVERT ;
	}
}

LastAdvert_GetFreeID() {

	new result = INVALID_LAST_ADVERT ;

	for ( new i, j = sizeof ( LastAdverts ); i < j ; i ++ ) {

		if ( LastAdverts [ i ] [ E_LAST_ADVERT_AI ] == INVALID_LAST_ADVERT ) {

			result = i ;
			break;
		}
	}

	new buffer_array [ MAX_LAST_ADVERTS ] [ E_LAST_ADVERTS ] ;

	// All slots are taken. Time to shift the array...
	if ( result == INVALID_LAST_ADVERT ) {

		print("Overflow found. Shifting array....");

		new shift_index ;

		for ( new i, j = sizeof ( LastAdverts ); i < j ; i ++ ) {

			// The target index is always one higher than before.
			shift_index = i + 1 ;

			// If the index reaches the sizeof, let's reset it to avoid overflow.
			if ( shift_index >= sizeof ( LastAdverts ) ) {
				
				shift_index = sizeof ( LastAdverts ) - 1 ;
				printf("Index capped, currently %d, cap is %d, changed to %d.", (i+1), sizeof ( LastAdverts), shift_index );
			}

			printf("Shifting id %d (ai %d) to id %d.", i, LastAdverts [ i ] [ E_LAST_ADVERT_AI ], shift_index);

			#warning There is a bug here that caused the LAST index (19) to not properly shift. See the server log below!
			buffer_array [ shift_index ] [ E_LAST_ADVERT_AI ] = shift_index 	;
			buffer_array [ shift_index ] [ E_LAST_ADVERT_TIMESTAMP ] = LastAdverts [ i ] [ E_LAST_ADVERT_TIMESTAMP ] ;

			format(buffer_array [ shift_index ] [ E_LAST_ADVERT_PLACEDBY ], 	MAX_PLAYER_NAME, 	"%s", LastAdverts [ i ] [ E_LAST_ADVERT_PLACEDBY ] );
			format(buffer_array [ shift_index ] [ E_LAST_ADVERT_TEXT ], 		64, 				"%s", LastAdverts [ i ] [ E_LAST_ADVERT_TEXT ] );

			// All variables are shifted upwards, 0 is duplicate. Let's free it.
			result = 0 ;
		}

		//print("Porting over buffer array to normal array.");

		for ( new i, j = sizeof ( LastAdverts ); i < j ; i ++ ) {

			LastAdverts [ i ] [ E_LAST_ADVERT_AI ] 			= buffer_array [ i ] [ E_LAST_ADVERT_AI ] ;
			LastAdverts [ i ] [ E_LAST_ADVERT_TIMESTAMP ] 	= buffer_array [ i ] [ E_LAST_ADVERT_TIMESTAMP ] ;

			format(LastAdverts [ i ] [ E_LAST_ADVERT_PLACEDBY ], 	MAX_PLAYER_NAME, 	"%s", buffer_array [ i ] [ E_LAST_ADVERT_PLACEDBY ] );
			format(LastAdverts [ i ] [ E_LAST_ADVERT_TEXT ], 		64, 				"%s", buffer_array [ i ] [ E_LAST_ADVERT_TEXT ] );
	
			//printf("New ID %d (\"%s\" posted \"%s\"", LastAdverts [ i ] [ E_LAST_ADVERT_AI ], LastAdverts [ i ] [ E_LAST_ADVERT_PLACEDBY ], LastAdverts [ i ] [ E_LAST_ADVERT_TEXT ] );
		}

	}

	return result ;
}

*/

/*
  Loading filterscript 'lastadvert.amx'...
Saved submission ID 0 at 1644925184 with text "Test 0" by "Hades_0".
Saved submission ID 1 at 1644925184 with text "Test 1" by "Hades_1".
Saved submission ID 2 at 1644925184 with text "Test 2" by "Hades_2".
Saved submission ID 3 at 1644925184 with text "Test 3" by "Hades_3".
Saved submission ID 4 at 1644925184 with text "Test 4" by "Hades_4".
Saved submission ID 5 at 1644925184 with text "Test 5" by "Hades_5".
Saved submission ID 6 at 1644925184 with text "Test 6" by "Hades_6".
Saved submission ID 7 at 1644925184 with text "Test 7" by "Hades_7".
Saved submission ID 8 at 1644925184 with text "Test 8" by "Hades_8".
Saved submission ID 9 at 1644925184 with text "Test 9" by "Hades_9".
Saved submission ID 10 at 1644925184 with text "Test 10" by "Hades_10".
Saved submission ID 11 at 1644925184 with text "Test 11" by "Hades_11".
Saved submission ID 12 at 1644925184 with text "Test 12" by "Hades_12".
Saved submission ID 13 at 1644925184 with text "Test 13" by "Hades_13".
Saved submission ID 14 at 1644925184 with text "Test 14" by "Hades_14".
Saved submission ID 15 at 1644925184 with text "Test 15" by "Hades_15".
Saved submission ID 16 at 1644925184 with text "Test 16" by "Hades_16".
Saved submission ID 17 at 1644925184 with text "Test 17" by "Hades_17".
Saved submission ID 18 at 1644925184 with text "Test 18" by "Hades_18".
Saved submission ID 19 at 1644925184 with text "Test 19" by "Hades_19".
Overflow found. Shifting array....
Saved submission ID 0 at 1644925184 with text "Overflow Test 0" by "Overflow_Hades_0".
Overflow found. Shifting array....
Saved submission ID 0 at 1644925184 with text "Overflow Test 1" by "Overflow_Hades_1".
Overflow found. Shifting array....
Saved submission ID 0 at 1644925184 with text "Overflow Test 2" by "Overflow_Hades_2".
Overflow found. Shifting array....
Saved submission ID 0 at 1644925184 with text "Overflow Test 3" by "Overflow_Hades_3".
Overflow found. Shifting array....
Saved submission ID 0 at 1644925184 with text "Overflow Test 4" by "Overflow_Hades_4".
Overflow found. Shifting array....
Saved submission ID 0 at 1644925184 with text "This string should be put FIRST in the array, as it is the LAST" by "Overflow_Hades_FINAL".
Displaying submission ID 0 at 1644925184 with text "This string should be put FIRST in the array, as it is the LAST" by "Overflow_Hades_FINAL".
Displaying submission ID 1 at 1644925184 with text "Overflow Test 4" by "Overflow_Hades_4".
Displaying submission ID 2 at 1644925184 with text "Overflow Test 3" by "Overflow_Hades_3".
Displaying submission ID 3 at 1644925184 with text "Overflow Test 2" by "Overflow_Hades_2".
Displaying submission ID 4 at 1644925184 with text "Overflow Test 1" by "Overflow_Hades_1".
Displaying submission ID 5 at 1644925184 with text "Overflow Test 0" by "Overflow_Hades_0".
Displaying submission ID 6 at 1644925184 with text "Test 0" by "Hades_0".
Displaying submission ID 7 at 1644925184 with text "Test 1" by "Hades_1".
Displaying submission ID 8 at 1644925184 with text "Test 2" by "Hades_2".
Displaying submission ID 9 at 1644925184 with text "Test 3" by "Hades_3".
Displaying submission ID 10 at 1644925184 with text "Test 4" by "Hades_4".
Displaying submission ID 11 at 1644925184 with text "Test 5" by "Hades_5".
Displaying submission ID 12 at 1644925184 with text "Test 6" by "Hades_6".
Displaying submission ID 13 at 1644925184 with text "Test 7" by "Hades_7".
Displaying submission ID 14 at 1644925184 with text "Test 8" by "Hades_8".
Displaying submission ID 15 at 1644925184 with text "Test 9" by "Hades_9".
Displaying submission ID 16 at 1644925184 with text "Test 10" by "Hades_10".
Displaying submission ID 17 at 1644925184 with text "Test 11" by "Hades_11".
Displaying submission ID 18 at 1644925184 with text "Test 12" by "Hades_12".
Displaying submission ID 19 at 1644925184 with text "Test 19" by "Hades_19". <--- ID 19 is untouched, it should be Test 13 by  Hades_13!


*/