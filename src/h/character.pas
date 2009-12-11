{$I item.h}

const
   itemmax     =    9;

type
     itemarray      =    array[1..itemmax] of item_t;
     character_t    =    record
        name           :    string;
        picfile        :    string;
        sex            :    char;
        level          :    byte;
        endurance      :    word;
        endurancemax   :    word;
        armorclass     :    integer;
        thac0          :    shortint;
        damage         :    dicerecord;
        savingthrow    :    byte;
        experience     :    longint;
        coins          :    longint;
        numitems       :    byte;
        item           :    itemarray;
        numspells      :    byte;
        spell          :    spellarray;
        strength       :    byte;
        dexterity      :    byte;
        stages         :    set of stage;
        charges        :    byte;
        chargemax      :    byte;
                         end;

