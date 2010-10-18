{$ifndef itemdef}

type

	item_t		= record
		name		: string;
		item_type	: byte;
		value	 	: word;
		picfile		: string;
		msg		: string;
		data		: array[1..8] of shortint;
	end;

{$define itemdef}
{$endif}
