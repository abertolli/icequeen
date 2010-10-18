const
     MON_dir        =    'monst/';

type

     monsterrecord  =    record
        name           :    string;
        picfile        :    string;
        sex            :    char;
        alignment      :    char;
        hitdice        :    byte;
        hpbonus        :    shortint;
        endurance      :    word;
        endurancemax   :    word;
        armorclass     :    integer;
        thac0          :    shortint;
        damage         :    dicerecord;
        attacktype     :    string;
        savingthrow    :    byte;
        morale         :    byte;
        xpvalue        :    word;
        treasure       :    dicerecord;
        coins          :    word;
        numspells      :    byte;
        spell          :    spellarray;
                         end;
