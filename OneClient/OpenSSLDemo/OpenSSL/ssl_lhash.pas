unit ssl_lhash;

interface
uses ssl_types;
var
	lh_new: function(h: LHASH_HASH_FN_TYPE; c: LHASH_COMP_FN_TYPE): P_LHASH; cdecl = nil;
	lh_free: procedure(_lh: P_LHASH); cdecl = nil;
	lh_insert: function(_lh: P_LHASH; _data: Pointer): Pointer; cdecl = nil;
	lh_delete: function(_lh: P_LHASH; const _data: Pointer): Pointer; cdecl = nil;
	lh_retrieve: function(_lh: P_LHASH; const _data: Pointer): Pointer; cdecl = nil;
	lh_doall: procedure(_lh: P_LHASH; func: LHASH_DOALL_FN_TYPE); cdecl = nil;
	lh_doall_arg: procedure(_lh: P_LHASH; func: LHASH_DOALL_ARG_FN_TYPE; _arg: Pointer); cdecl = nil;
	lh_strhash: function(const _c: PAnsiChar): TC_ULONG; cdecl = nil;
	lh_num_items: function(const _lh: P_LHASH): TC_ULONG; cdecl = nil;
	lh_stats_bio: procedure(const _lh: P_LHASH; _out: PBIO); cdecl = nil;
	lh_node_stats_bio: procedure(const _lh: P_LHASH; _out: PBIO); cdecl = nil;
	lh_node_usage_stats_bio: procedure(const _lh: P_LHASH; _out: PBIO); cdecl = nil;

procedure SSL_InitLHASH;

implementation
uses ssl_lib;

procedure SSL_InitLHASH;
begin
	if @lh_new = nil then
		begin
			@lh_new:= LoadFuncCLibCrypto('lh_new');
			@lh_free:= LoadFuncCLibCrypto('lh_free');
			@lh_insert:= LoadFuncCLibCrypto('lh_insert');
			@lh_delete:= LoadFuncCLibCrypto('lh_delete');
			@lh_retrieve:= LoadFuncCLibCrypto('lh_retrieve');
			@lh_doall:= LoadFuncCLibCrypto('lh_doall');
			@lh_doall_arg:= LoadFuncCLibCrypto('lh_doall_arg');
			@lh_strhash:= LoadFuncCLibCrypto('lh_strhash');
			@lh_num_items:= LoadFuncCLibCrypto('lh_num_items');
			@lh_stats_bio:= LoadFuncCLibCrypto('lh_stats_bio');
			@lh_node_stats_bio:= LoadFuncCLibCrypto('lh_node_stats_bio');
			@lh_node_usage_stats_bio:= LoadFuncCLibCrypto('lh_node_usage_stats_bio');
		end;

end;

end.
