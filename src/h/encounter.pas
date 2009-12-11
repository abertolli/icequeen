type

     monsterlist    =    array[1..monstermax] of monsterrecord;
     chartrecord    =    record
        value          :    array[1..20,1..2] of byte;
        filename       :    array[1..20] of string;
        number         :    array[1..20] of dicerecord;
        diceroll       :    dicerecord;
                         end;
     effectrecord    =    record
        blue           :    boolean;
        courage        :    boolean;
        resistfire     :    boolean;
        resistcold     :    boolean;
        glacier        :    boolean;
                          end;
     effectlist      =    array[1..monstermax] of effectrecord;


