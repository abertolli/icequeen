{Functions that return the names of items and spells given the enum type.}
{---------------------------------------------------------------------------}
function itemstring(theitem:item):stringtype;

begin
     case theitem of
          sword          :itemstring:='sword';
          shield         :itemstring:='shield';
          axe            :itemstring:='axe';
          bluepotion     :itemstring:='blue potion';
          redpotion      :itemstring:='red potion';
          greenpotion    :itemstring:='green potion';
          chainmail      :itemstring:='chain mail';
          platemail      :itemstring:='plate mail';
          dagger         :itemstring:='dagger';
          club           :itemstring:='club';
          staff          :itemstring:='staff';
          hammer         :itemstring:='hammer';
          magicsword     :itemstring:='magic sword';
          magicshield    :itemstring:='magic shield';
          flamewand      :itemstring:='flame wand';
     end;{case}
end;
{---------------------------------------------------------------------------}
function spellstring(thespell:spell):stringtype;

begin
     case thespell of
          icestorm       :spellstring:='ice storm';
          fireblast      :spellstring:='fire blast';
          web            :spellstring:='web';
          callwild       :spellstring:='call wild';
          heal           :spellstring:='heal';
          courage        :spellstring:='courage';
          freeze         :spellstring:='freeze';
          obliterate     :spellstring:='obliterate';
          icicle         :spellstring:='icicle';
          power          :spellstring:='power';
          shatter        :spellstring:='shatter';
          glacier        :spellstring:='glacier';
          dragonbreath   :spellstring:='dragon breath';
          resistfire     :spellstring:='resist fire';
          resistcold     :spellstring:='resist cold';
     end;{case}
end;
