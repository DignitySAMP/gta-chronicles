enum E_SKIN_CUSTOM_DATA {

	E_CUSTOM_SKIN_TYPE,
	E_CUSTOM_SKIN_MODEL [ 64 ]
} ;

enum {

	E_CUSTOM_SKIN_NONE,
	E_CUSTOM_SKIN_BODY,
	E_CUSTOM_SKIN_HEAD,

}

new SkinCustomization [ ] [ E_SKIN_CUSTOM_DATA ] = {

	#warning Add "default" head position for each body! (Make system to /testskin [id] that puts at 0.0, 0.0, 0.0, adjust with /attachments then make it set default head pos (str8 from editor!))

	// Part 1 (Lewis, Kirama)
	{ E_CUSTOM_SKIN_BODY, "baggyshirtbody" },
	{ E_CUSTOM_SKIN_BODY, "ballas1body" },
	{ E_CUSTOM_SKIN_HEAD, "ballas1head" },
	{ E_CUSTOM_SKIN_BODY, "ballas2body" },
	{ E_CUSTOM_SKIN_HEAD, "ballas2head" },
	{ E_CUSTOM_SKIN_BODY, "ballas3body" },
	{ E_CUSTOM_SKIN_HEAD, "ballas3head" },
	{ E_CUSTOM_SKIN_BODY, "bmybarbody" },
	{ E_CUSTOM_SKIN_HEAD, "bmybarhead" },
	{ E_CUSTOM_SKIN_BODY, "bmybebody" },
	{ E_CUSTOM_SKIN_HEAD, "bmybehead" },
	{ E_CUSTOM_SKIN_BODY, "bmycgbody" },
	{ E_CUSTOM_SKIN_HEAD, "bmycghead" },
	{ E_CUSTOM_SKIN_BODY, "bmycrbody" },
	{ E_CUSTOM_SKIN_HEAD, "bmycrhead" },
	{ E_CUSTOM_SKIN_BODY, "bmydjbody" },
	{ E_CUSTOM_SKIN_HEAD, "bmydjhead" },
	{ E_CUSTOM_SKIN_NONE, "bmydrug" },
	{ E_CUSTOM_SKIN_BODY, "bmydrugbody" },
	{ E_CUSTOM_SKIN_HEAD, "bmydrughead" },
	{ E_CUSTOM_SKIN_BODY, "bmypol1body" },
	{ E_CUSTOM_SKIN_HEAD, "bmypol1head" },
	{ E_CUSTOM_SKIN_BODY, "bmypol2body" },
	{ E_CUSTOM_SKIN_HEAD, "bmypol2head" },
	{ E_CUSTOM_SKIN_BODY, "bmyribody" },
	{ E_CUSTOM_SKIN_HEAD, "bmyrihead" },
	{ E_CUSTOM_SKIN_BODY, "bmystbody" },
	{ E_CUSTOM_SKIN_HEAD, "bmysthead" },
	{ E_CUSTOM_SKIN_NONE, "emmet" },
	{ E_CUSTOM_SKIN_BODY, "emmetbody" },
	{ E_CUSTOM_SKIN_HEAD, "emmethead" },
	{ E_CUSTOM_SKIN_BODY, "fam1body" },
	{ E_CUSTOM_SKIN_HEAD, "fam1head" },
	{ E_CUSTOM_SKIN_BODY, "fam2body" },
	{ E_CUSTOM_SKIN_HEAD, "fam2head" },
	{ E_CUSTOM_SKIN_BODY, "fam3body" },
	{ E_CUSTOM_SKIN_HEAD, "fam3head" },
	{ E_CUSTOM_SKIN_BODY, "hernbody" },
	{ E_CUSTOM_SKIN_BODY, "hmycrbody" },
	{ E_CUSTOM_SKIN_HEAD, "hmycrhead" },
	{ E_CUSTOM_SKIN_BODY, "hmydrugbody" },
	{ E_CUSTOM_SKIN_HEAD, "hmydrughead" },
	{ E_CUSTOM_SKIN_BODY, "hmystbody" },
	{ E_CUSTOM_SKIN_HEAD, "hmysthead" },
	{ E_CUSTOM_SKIN_BODY, "lapd1body" },
	{ E_CUSTOM_SKIN_HEAD, "lapd1head" },
	{ E_CUSTOM_SKIN_BODY, "lsv1body" },
	{ E_CUSTOM_SKIN_HEAD, "lsv1head" },
	{ E_CUSTOM_SKIN_BODY, "lsv2body" },
	{ E_CUSTOM_SKIN_HEAD, "lsv2head" },
	{ E_CUSTOM_SKIN_BODY, "lsv3body" },
	{ E_CUSTOM_SKIN_HEAD, "lsv3head" },
	{ E_CUSTOM_SKIN_BODY, "male01body" },
	{ E_CUSTOM_SKIN_HEAD, "male01head" },
	{ E_CUSTOM_SKIN_BODY, "pulaskibody" },
	{ E_CUSTOM_SKIN_BODY, "sbmycrbody" },
	{ E_CUSTOM_SKIN_HEAD, "sbmycrhead" },
	{ E_CUSTOM_SKIN_BODY, "sfpd1body" },
	{ E_CUSTOM_SKIN_HEAD, "sfpd1head" },
	{ E_CUSTOM_SKIN_BODY, "sfr1body" },
	{ E_CUSTOM_SKIN_HEAD, "sfr1head" },
	{ E_CUSTOM_SKIN_BODY, "sfr2body" },
	{ E_CUSTOM_SKIN_HEAD, "sfr2head" },
	{ E_CUSTOM_SKIN_BODY, "sfr3body" },
	{ E_CUSTOM_SKIN_HEAD, "sfr3head" },
	{ E_CUSTOM_SKIN_BODY, "sweetbody" },
	{ E_CUSTOM_SKIN_HEAD, "sweethead" },
	{ E_CUSTOM_SKIN_BODY, "swmyhp2body" },
	{ E_CUSTOM_SKIN_HEAD, "swmyhp2head" },
	{ E_CUSTOM_SKIN_BODY, "tenpenbody" },
	{ E_CUSTOM_SKIN_BODY, "vbmyboxbody" },
	{ E_CUSTOM_SKIN_HEAD, "vbmyboxhead" },
	{ E_CUSTOM_SKIN_BODY, "vla1body" },
	{ E_CUSTOM_SKIN_HEAD, "vla1head" },
	{ E_CUSTOM_SKIN_BODY, "vla2body" },
	{ E_CUSTOM_SKIN_HEAD, "vla2head" },
	{ E_CUSTOM_SKIN_BODY, "vla3body" },
	{ E_CUSTOM_SKIN_HEAD, "vla3head" },
	{ E_CUSTOM_SKIN_BODY, "wbdyg1body" },
	{ E_CUSTOM_SKIN_HEAD, "wbdyg1head" },
	{ E_CUSTOM_SKIN_BODY, "wbdyg2body" },
	{ E_CUSTOM_SKIN_HEAD, "wbdyg2head" },
	{ E_CUSTOM_SKIN_BODY, "wmybebody" },
	{ E_CUSTOM_SKIN_HEAD, "wmybehead" },

	// Part 2 (Lewis)
	{  E_CUSTOM_SKIN_BODY, "bikerabody" },
	{  E_CUSTOM_SKIN_HEAD, "bikerahead" },
	{  E_CUSTOM_SKIN_BODY, "copgrl3body" },
	{  E_CUSTOM_SKIN_HEAD, "copgrl3head" },
	{  E_CUSTOM_SKIN_BODY, "dwaynebody" },
	{  E_CUSTOM_SKIN_HEAD, "dwaynehead" },
	{  E_CUSTOM_SKIN_BODY, "gangrl3body" },
	{  E_CUSTOM_SKIN_HEAD, "gangrl3head" },
	{  E_CUSTOM_SKIN_BODY, "gungrl3body" },
	{  E_CUSTOM_SKIN_HEAD, "gungrl3head" },
	{  E_CUSTOM_SKIN_BODY, "maddoggbody" },
	{  E_CUSTOM_SKIN_HEAD, "maddogghead" },
	{  E_CUSTOM_SKIN_BODY, "nurgrl3body" },
	{  E_CUSTOM_SKIN_HEAD, "nurgrl3head" },
	{  E_CUSTOM_SKIN_BODY, "oglocbody" },
	{  E_CUSTOM_SKIN_HEAD, "oglochead" },
	{  E_CUSTOM_SKIN_BODY, "paulbody" },
	{  E_CUSTOM_SKIN_HEAD, "paulhead" },
	{  E_CUSTOM_SKIN_BODY, "somystbody" },
	{  E_CUSTOM_SKIN_HEAD, "somysthead" },
	{  E_CUSTOM_SKIN_BODY, "swfyribody" },
	{  E_CUSTOM_SKIN_HEAD, "swfyrihead" },
	{  E_CUSTOM_SKIN_BODY, "swmyribody" },
	{  E_CUSTOM_SKIN_HEAD, "swmyrihead" },
	{  E_CUSTOM_SKIN_BODY, "swmystbody" },
	{  E_CUSTOM_SKIN_HEAD, "swmysthead" },
	{  E_CUSTOM_SKIN_BODY, "triadabody" },
	{  E_CUSTOM_SKIN_HEAD, "triadahead" },
	{  E_CUSTOM_SKIN_BODY,  "triadbbody" },
	{  E_CUSTOM_SKIN_HEAD, "triadbhead" },
	{  E_CUSTOM_SKIN_BODY, "tribossbody" },
	{  E_CUSTOM_SKIN_HEAD, "tribosshead" },
	{  E_CUSTOM_SKIN_BODY, "vbmocdbody" },
	{  E_CUSTOM_SKIN_HEAD, "vbmocdhead" },
	{  E_CUSTOM_SKIN_BODY, "vhmycrbody" },
	{  E_CUSTOM_SKIN_HEAD, "vhmycrhead" },
	{  E_CUSTOM_SKIN_BODY, "vmaff1body" },
	{  E_CUSTOM_SKIN_HEAD, "vmaff1head" },
	{  E_CUSTOM_SKIN_BODY, "vmaff3body" },
	{  E_CUSTOM_SKIN_HEAD, "vmaff3head" },
	{  E_CUSTOM_SKIN_BODY, "vmaff4body" },
	{  E_CUSTOM_SKIN_HEAD, "vmaff4head" },
	{  E_CUSTOM_SKIN_BODY, "wfyclotbody" },
	{  E_CUSTOM_SKIN_HEAD, "wfyclothead" },
	{  E_CUSTOM_SKIN_BODY, "wmyammobody" },
	{  E_CUSTOM_SKIN_HEAD, "wmyammohead" },
	{  E_CUSTOM_SKIN_BODY, "wmycrbody" },
	{  E_CUSTOM_SKIN_HEAD, "wmycrhead" }

} ;


public OnGameModeInit() {
	
	for ( new i, j = sizeof ( SkinCustomization ) ; i < j ; i ++ ) {

		switch ( SkinCustomization [ i ] [ E_CUSTOM_SKIN_TYPE ] ) {

			case E_CUSTOM_SKIN_BODY: {
				AddCharModel(28, 22000 + i, sprintf("custom/%s.dff", 
					SkinCustomization [ i ] [ E_CUSTOM_SKIN_MODEL ]), 
					sprintf("custom/%s.txd", SkinCustomization [ i ] [ E_CUSTOM_SKIN_MODEL ])
				);
			}

			case E_CUSTOM_SKIN_HEAD: {
				AddSimpleModel(-1, 18963, -10000 - i, sprintf("custom/%s.dff", 
					SkinCustomization [ i ] [ E_CUSTOM_SKIN_MODEL ]), 
					sprintf("custom/%s.txd", SkinCustomization [ i ] [ E_CUSTOM_SKIN_MODEL ])
				);
			}
		}	
	}

	#if defined customskinmodels_OnGameModeInit
		return customskinmodels_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit customskinmodels_OnGameModeInit
#if defined customskinmodels_OnGameModeInit
	forward customskinmodels_OnGameModeInit();
#endif