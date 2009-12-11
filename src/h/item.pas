{$ifndef item_h}

const
   ITM_dir     =    'item/';


type

   item_t      =    record
      name     :       string;
      item_type:       byte;
      value    :       word;
      picfile  :       string;
      msg      :       string;
      data     :       array[1..8] of shortint;
                    end;

{$define item_h}

{$endif}
