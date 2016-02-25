unit Actor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grobal2, DxDraws, CliUtil, magiceff, Wil, ClFunc, SDK;

const
  MAXACTORSOUND = 3;
  CMMX = 150;
  CMMY = 200;

  HUMANFRAME = 600;
  MONFRAME = 280;
  EXPMONFRAME = 360;
  SCULMONFRAME = 440;
  ZOMBIFRAME = 430;
  MERCHANTFRAME = 60;
  MAXSAY = 5;
  //   MON1_FRAME =
  //   MON2_FRAME =

  RUN_MINHEALTH = 10;
  DEFSPELLFRAME = 10;
  FIREHIT_READYFRAME = 6; //¿°È­°á ½ÃÀü ÇÁ·¡ÀÓ
  MAGBUBBLEBASE = 3890; //Ä§·¨¶ÜÐ§¹ûÍ¼Î»ÖÃ
  MAGBUBBLESTRUCKBASE = 3900; //±»¹¥»÷Ê±Ä§·¨¶ÜÐ§¹ûÍ¼Î»ÖÃ
  MAXWPEFFECTFRAME = 5;
  WPEFFECTBASE = 3750;
  EFFECTBASE = 0;

type
  TActionInfo = packed record
    start: Word; //0x14              // ½ÃÀÛ ÇÁ·¡ÀÓ
    frame: Word; //0x16              // ÇÁ·¡ÀÓ °¹¼ö
    skip: Word; //0x18
    ftime: Word; //0x1A              // ÇÁ·¡ÀÓ °¹¼ö
    usetick: Word; //0x1C              // »ç¿ëÆ½, ÀÌµ¿ µ¿ÀÛ¿¡¸¸ »ç¿ëµÊ
  end;
  pTActionInfo = ^TActionInfo;
  THumanAction = packed record
    ActStand: TActionInfo; //1
    ActWalk: TActionInfo; //8
    ActRun: TActionInfo; //8
    ActRushLeft: TActionInfo;
    ActRushRight: TActionInfo;
    ActWarMode: TActionInfo; //1
    ActHit: TActionInfo; //6
    ActHeavyHit: TActionInfo; //6
    ActBigHit: TActionInfo; //6
    ActFireHitReady: TActionInfo; //6
    ActSpell: TActionInfo; //6
    ActSitdown: TActionInfo; //1
    ActStruck: TActionInfo; //3
    ActDie: TActionInfo; //4
  end;
  pTHumanAction = ^THumanAction;
  TMonsterAction = packed record
    ActStand: TActionInfo; //1
    ActWalk: TActionInfo; //8
    ActAttack: TActionInfo; //6 0x14 - 0x1C
    ActCritical: TActionInfo; //6 0x20 -
    ActStruck: TActionInfo; //3
    ActDie: TActionInfo; //4
    ActDeath: TActionInfo;
  end;
  pTMonsterAction = ^TMonsterAction;
const
  HA: THumanAction = (
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 90; usetick: 2);
    ActRun: (start: 128; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActRushLeft: (start: 128; frame: 3; skip: 5; ftime: 120; usetick: 3);
    ActRushRight: (start: 131; frame: 3; skip: 5; ftime: 120; usetick: 3);
    ActWarMode: (start: 192; frame: 1; skip: 0; ftime: 200; usetick: 0);
    //ActHit:    (start: 200;    frame: 5;  skip: 3;  ftime: 140;  usetick: 0);
    ActHit: (start: 200; frame: 6; skip: 2; ftime: 85; usetick: 0);
    ActHeavyHit: (start: 264; frame: 6; skip: 2; ftime: 90; usetick: 0);
    ActBigHit: (start: 328; frame: 8; skip: 0; ftime: 70; usetick: 0);
    ActFireHitReady: (start: 192; frame: 6; skip: 4; ftime: 70; usetick: 0);
    ActSpell: (start: 392; frame: 6; skip: 2; ftime: 60; usetick: 0);
    ActSitdown: (start: 456; frame: 2; skip: 0; ftime: 300; usetick: 0);
    ActStruck: (start: 472; frame: 3; skip: 5; ftime: 70; usetick: 0);
    ActDie: (start: 536; frame: 4; skip: 4; ftime: 120; usetick: 0)
    );
  MA9: TMonsterAction = (//4C03D4
    ActStand: (start: 0; frame: 1; skip: 7; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActAttack: (start: 64; frame: 6; skip: 2; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 64; frame: 6; skip: 2; ftime: 100; usetick: 0);
    ActDie: (start: 0; frame: 1; skip: 7; ftime: 140; usetick: 0);
    ActDeath: (start: 0; frame: 1; skip: 7; ftime: 0; usetick: 0);
    );
  MA10: TMonsterAction = (//(8Frame) ´øµ¶ÎÀÊ¿
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActAttack: (start: 128; frame: 4; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 192; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 208; frame: 4; skip: 4; ftime: 140; usetick: 0);
    ActDeath: (start: 272; frame: 1; skip: 0; ftime: 0; usetick: 0);
    );
  MA11: TMonsterAction = (//»ç½¿(10FrameÂ¥¸®)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 120; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 140; usetick: 0);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 0; usetick: 0);
    );
  MA12: TMonsterAction = (//°æºñº´, ¶§¸®´Â ¼Óµµ ºü¸£´Ù.
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActAttack: (start: 128; frame: 6; skip: 2; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 192; frame: 2; skip: 0; ftime: 150; usetick: 0);
    ActDie: (start: 208; frame: 4; skip: 4; ftime: 160; usetick: 0);
    ActDeath: (start: 272; frame: 1; skip: 0; ftime: 0; usetick: 0);
    );
  MA13: TMonsterAction = (//½ÄÀÎÃÊ
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 10; frame: 8; skip: 2; ftime: 160; usetick: 0); //µîÀå...
    ActAttack: (start: 30; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 110; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 130; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 20; frame: 9; skip: 0; ftime: 150; usetick: 0); //¼ûÀ½..
    );
  MA14: TMonsterAction = (//ÇØ°ñ ¿À¸¶
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 100; usetick: 0); //¹é°ñÀÎ°æ¿ì(¼ÒÈ¯)
    );
  MA15: TMonsterAction = (//µµ³¢´øÁö´Â ¿À¸¶
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 1; frame: 1; skip: 0; ftime: 100; usetick: 0);
    );
  MA16: TMonsterAction = (//°¡½º½î´Â ±¸µ¥±â
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 4; skip: 6; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 1; skip: 0; ftime: 160; usetick: 0);
    );
  MA17: TMonsterAction = (//¹Ùµü²¨¸®´Â ¸÷
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 60; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 140; usetick: 0); //
    );
  MA19: TMonsterAction = (//¿ì¸é±Í (Á×´Â°Å »¡¸®Á×À½)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 140; usetick: 0);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 140; usetick: 0); //
    );
  MA20: TMonsterAction = (//Á×¾ú´Ù »ì¾Æ³ª´Â Á»ºñ)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 170; usetick: 0); //´Ù½Ã »ì¾Æ³ª±â
    );
  MA21: TMonsterAction = (//¹úÁý
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0); //
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120; usetick: 0); //¹ú ¹ß»ç
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 30; frame: 10; skip: 0; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0); //
    );
  MA22: TMonsterAction = (//¼®»ó¸ó½ºÅÍ(¿°¼Ò´ëÀå,¿°¼ÒÀå±º)
    ActStand: (start: 80; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 240; frame: 6; skip: 4; ftime: 100; usetick: 0); //
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 340; frame: 10; skip: 0; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 6; skip: 4; ftime: 170; usetick: 0); //¼®»ó³ìÀ½
    );
  MA23: TMonsterAction = (//ÁÖ¸¶¿Õ
    ActStand: (start: 20; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 100; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 180; frame: 6; skip: 4; ftime: 100; usetick: 0); //
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 260; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 280; frame: 10; skip: 0; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 20; skip: 0; ftime: 100; usetick: 0); //¼®»ó³ìÀ½
    );
  MA24: TMonsterAction = (//Àü°¥, °ø°Ý 2°¡Áö
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 240; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 340; frame: 10; skip: 0; ftime: 140; usetick: 0);
    ActDeath: (start: 420; frame: 1; skip: 0; ftime: 140; usetick: 0); //
    );
  {
MA25: TMonsterAction = (  //Áö³×¿Õ
    ActStand:  (start: 0;      frame: 4;  skip: 6;  ftime: 200;  usetick: 0);
    ActWalk:   (start: 70;     frame: 10; skip: 0;  ftime: 200;  usetick: 3); //µîÀå
    ActAttack: (start: 20;     frame: 6;  skip: 4;  ftime: 120;  usetick: 0); //Á÷Á¢°ø°Ý
    ActCritical:(start: 10;    frame: 6;  skip: 4;  ftime: 120;  usetick: 0); //µ¶Ä§°ø°Ý(¿ø°Å¸®)
    ActStruck: (start: 50;     frame: 2;  skip: 0;  ftime: 100;  usetick: 0);
    ActDie:    (start: 60;     frame: 10; skip: 0;  ftime: 200;  usetick: 0);
    ActDeath:  (start: 0;      frame: 0;  skip: 0;  ftime: 140;  usetick: 0); //
  );
  }
  MA25: TMonsterAction = (//4C080C
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 70; frame: 10; skip: 0; ftime: 200; usetick: 3);
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 10; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 50; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 60; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 80; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );

  MA26: TMonsterAction = (//¼º¹®,
    ActStand: (start: 0; frame: 1; skip: 7; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 160; usetick: 0); //µîÀå...
    ActAttack: (start: 56; frame: 6; skip: 2; ftime: 500; usetick: 0); //¿­±â
    ActCritical: (start: 64; frame: 6; skip: 2; ftime: 500; usetick: 0); //´Ý±â
    ActStruck: (start: 0; frame: 4; skip: 4; ftime: 100; usetick: 0);
    ActDie: (start: 24; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 150; usetick: 0); //¼ûÀ½..
    );
  MA27: TMonsterAction = (//¼ºº®
    ActStand: (start: 0; frame: 1; skip: 7; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 160; usetick: 0); //µîÀå...
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 250; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 250; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 0; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 150; usetick: 0); //¼ûÀ½..
    );
  MA28: TMonsterAction = (//½Å¼ö (º¯½Å Àü)
    ActStand: (start: 80; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 0; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100; usetick: 0); //µîÀå..
    );
  MA29: TMonsterAction = (//½Å¼ö (º¯½Å ÈÄ)
    ActStand: (start: 80; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 3); //
    ActAttack: (start: 240; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 340; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100; usetick: 0); //µîÀå..
    );
  MA30: TMonsterAction = (//4C0974
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 10; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 30; frame: 20; skip: 0; ftime: 150; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );
  MA31: TMonsterAction = (//4C09BC
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 0; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 0; frame: 2; skip: 8; ftime: 100; usetick: 0);
    ActDie: (start: 20; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );

  MA32: TMonsterAction = (//4C0A04
    ActStand: (start: 0; frame: 1; skip: 9; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 0; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 0; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 0; frame: 2; skip: 8; ftime: 100; usetick: 0);
    ActDie: (start: 80; frame: 10; skip: 0; ftime: 80; usetick: 0);
    ActDeath: (start: 80; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );

  MA33: TMonsterAction = (//4C0A4C
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 340; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 260; frame: 10; skip: 0; ftime: 200; usetick: 0);
    );

  MA34: TMonsterAction = (//4C0A94
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 320; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 400; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 420; frame: 20; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 420; frame: 20; skip: 0; ftime: 200; usetick: 0);
    );

  MA35: TMonsterAction = (//4C0ADC
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 30; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );

  MA36: TMonsterAction = (//4C0B24
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 30; frame: 20; skip: 0; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );

  MA37: TMonsterAction = (//4C0B6C
    ActStand: (start: 30; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 30; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );

  MA38: TMonsterAction = (//4C0BB4
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 80; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );

  MA39: TMonsterAction = (//4C0BFC
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 300; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 150; usetick: 0);
    ActDie: (start: 30; frame: 10; skip: 0; ftime: 80; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );

  MA40: TMonsterAction = (//4C0C44
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 250; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 210; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 110; usetick: 0);
    ActCritical: (start: 580; frame: 20; skip: 0; ftime: 135; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 120; usetick: 0);
    ActDie: (start: 260; frame: 20; skip: 0; ftime: 130; usetick: 0);
    ActDeath: (start: 260; frame: 20; skip: 0; ftime: 130; usetick: 0);
    );

  MA41: TMonsterAction = (//4C0C8C
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );

  MA42: TMonsterAction = (//4C0CD4
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 10; frame: 8; skip: 2; ftime: 160; usetick: 0);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDie: (start: 30; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 30; frame: 10; skip: 0; ftime: 150; usetick: 0);
    );

  MA43: TMonsterAction = (//4C0D1C
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 0);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 0);
    ActCritical: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 150; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 100; usetick: 0);
    );

  MA44: TMonsterAction = (//4C0D64
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActWalk: (start: 10; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 40; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActStruck: (start: 40; frame: 2; skip: 8; ftime: 150; usetick: 0);
    ActDie: (start: 30; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );

  MA45: TMonsterAction = (//4C0DAC
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActWalk: (start: 0; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActAttack: (start: 10; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActCritical: (start: 10; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 300; usetick: 0);
    ActDie: (start: 0; frame: 1; skip: 9; ftime: 300; usetick: 0);
    ActDeath: (start: 0; frame: 1; skip: 9; ftime: 300; usetick: 0);
    );

  MA46: TMonsterAction = (//4C0DF4
    ActStand: (start: 0; frame: 20; skip: 0; ftime: 100; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA47: TMonsterAction = (//4C0A4C ÊÈÑª½ÌÖ÷
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 260; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 524; frame: 6; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 524; frame: 6; skip: 0; ftime: 200; usetick: 0);
    );
  WORDER: array[0..1, 0..599] of byte = (//1: Ä®ÀÌ ¾ÕÀ¸·Î,  0: Ä®ÀÌ µÚ·Î
    (//³²ÀÚ
    //Á¤Áö
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
    //°È±â
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //¶Ù±â
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //war¸ðµå
    0, 1, 1, 1, 0, 0, 0, 0,
    //°ø°Ý
    1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1,
    //°ø°Ý 2
    0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1,
    //°ø°Ý3
    1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    //¸¶¹ý
    0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1,
    //Ø±â
    0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0,
    //¸Â±â
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    //¾²·¯Áü
    0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1
    ),

    (
    //Á¤Áö
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
    //°È±â
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //¶Ù±â
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //war¸ðµå
    1, 1, 1, 1, 0, 0, 0, 0,
    //°ø°Ý
    1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1,
    //°ø°Ý 2
    0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1,
    //°ø°Ý3
    1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    //¸¶¹ý
    0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1,
    //Ø±â
    0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0,
    //¸Â±â
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    //¾²·¯Áü
    0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1
    )
    );

  EffDir: array[0..7] of byte = (0, 0, 1, 1, 1, 1, 1, 0);


type
  TActor = class //Size 0x240
    m_nRecogId: Integer; //½ÇÉ«±êÊ¶ 0x4
    m_nCurrX: Integer; //µ±Ç°ËùÔÚµØÍ¼×ù±êX 0x08
    m_nCurrY: Integer; //µ±Ç°ËùÔÚµØÍ¼×ù±êY 0x0A
    m_btDir: byte; //µ±Ç°Õ¾Á¢·½Ïò 0x0C
    m_btSex: byte; //ÐÔ±ð 0x0D
    m_btRace: byte; //0x0E
    m_btHair: byte; //Í··¢ÀàÐÍ 0x0F
    m_btDress: byte; //ÒÂ·þÀàÐÍ 0x10
    m_btWeapon: byte; //ÎäÆ÷ÀàÐÍ
    m_btHorse: byte; //ÂíÀàÐÍ
    m_btEffect: byte; //ÌìÊ¹ÀàÐÍ
    m_btJob: byte; //Ö°Òµ 0:ÎäÊ¿  1:·¨Ê¦  2:µÀÊ¿
    m_wAppearance: Word; //0x14
    m_btDeathState: byte;
    m_nFeature: Integer; //0x18
    m_nFeatureEx: Integer; //0x18
    m_nState: Integer; //0x1C
    m_boDeath: Boolean; //0x20
    m_boSkeleton: Boolean; //0x21
    m_boDelActor: Boolean; //0x22
    m_boDelActionAfterFinished: Boolean; //0x23
    m_sDescUserName: string; //ÈËÎïÃû³Æ£¬ºó×º
    m_sUserName: string; //0x28
    m_nNameColor: Integer; //0x2C
    m_Abil: TAbility; //0x30
    m_nGold: Integer; //½ð±ÒÊýÁ¿0x58
    m_nGameGold: Integer; //ÓÎÏ·±ÒÊýÁ¿
    m_nGamePoint: Integer; //ÓÎÏ·µãÊýÁ¿
    m_nHitSpeed: ShortInt; //¹¥»÷ËÙ¶È 0: ±âº», (-)´À¸² (+)ºü¸§
    m_boVisible: Boolean; //0x5D
    m_boHoldPlace: Boolean; //0x5E

    m_SayingArr: array[0..MAXSAY - 1] of string;
    m_SayWidthsArr: array[0..MAXSAY - 1] of Integer;
    m_dwSayTime: LongWord;
    m_nSayX: Integer;
    m_nSayY: Integer;
    m_nSayLineCount: Integer;

    m_nShiftX: Integer; //0x98
    m_nShiftY: Integer; //0x9C

    m_nPx: Integer; //0xA0
    m_nHpx: Integer; //0xA4
    m_nWpx: Integer; //0xA8
    m_nSpx: Integer; //0xAC

    m_nPy: Integer;
    m_nHpy: Integer;
    m_nWpy: Integer;
    m_nSpy: Integer; //0xB0 0xB4 0xB8 0xBC

    m_nRx: Integer;
    m_nRy: Integer; //0xC0 0xC4
    m_nDownDrawLevel: Integer; //0xC8
    m_nTargetX: Integer;
    m_nTargetY: Integer; //0xCC 0xD0
    m_nTargetRecog: Integer; //0xD4
    m_nHiterCode: Integer; //0xD8
    m_nMagicNum: Integer; //0xDC
    m_nCurrentEvent: Integer; //¼­¹öÀÇ ÀÌº¥Æ® ¾ÆÀÌµð
    m_boDigFragment: Boolean; //ÀÌ¹ø °î±ªÀÌ ÁúÀÌ Ä³Á³´ÂÁö..
    m_boThrow: Boolean;

    m_nBodyOffset: Integer; //0x0E8   //0x0D0
    m_nHairOffset: Integer; //0x0EC
    m_nHumWinOffset: Integer; //0x0F0
    m_nWeaponOffset: Integer; //0x0F4
    m_boUseMagic: Boolean; //0x0F8   //0xE0
    m_boHitEffect: Boolean; //0x0F9    //0xE1
    m_boUseEffect: Boolean; //0x0FA    //0xE2
    m_nHitEffectNumber: Integer; //0xE4
    m_dwWaitMagicRequest: LongWord;
    m_nWaitForRecogId: Integer; //ÀÚ½ÅÀÌ »ç¶óÁö¸é WaitForÀÇ actor¸¦ visible ½ÃÅ²´Ù.
    m_nWaitForFeature: Integer;
    m_nWaitForStatus: Integer;


    m_nCurEffFrame: Integer; //0x110
    m_nSpellFrame: Integer; //0x114
    m_CurMagic: TUseMagicInfo; //0x118  //m_CurMagic.EffectNumber 0x110
    //GlimmingMode: Boolean;
    //CurGlimmer: integer;
    //MaxGlimmer: integer;
    //GlimmerTime: longword;
    m_nGenAniCount: Integer; //0x124
    m_boOpenHealth: Boolean; //0x140
    m_noInstanceOpenHealth: Boolean; //0x141
    m_dwOpenHealthStart: LongWord;
    m_dwOpenHealthTime: LongWord; //Integer;jacky

    //SRc: TRect;  //Screen Rect È­¸éÀÇ ½ÇÁ¦ÁÂÇ¥(¸¶¿ì½º ±âÁØ)
    m_BodySurface: TDirectDrawSurface; //0x14C   //0x134

    m_boGrouped: Boolean; //0x150 ÊÇ·ñ×é¶Ó
    m_nCurrentAction: Integer; //0x154         //0x13C
    m_boReverseFrame: Boolean; //0x158
    m_boWarMode: Boolean; //0x159
    m_dwWarModeTime: LongWord; //0x15C
    m_nChrLight: Integer; //0x160
    m_nMagLight: Integer; //0x164
    m_nRushDir: Integer; //0, 1  //0x168
    m_nXxI: Integer; //0x16C
    m_boLockEndFrame: Boolean; //0x170
    m_dwLastStruckTime: LongWord; //0x174
    m_dwSendQueryUserNameTime: LongWord; //0x178
    m_dwDeleteTime: LongWord; //0x17C

    //»ç¿îµå È¿°ú
    m_nMagicStruckSound: Integer; //0x180 ±»Ä§·¨¹¥»÷ÍäÑü·¢³öµÄÉùÒô
    m_boRunSound: Boolean; //0x184 ÅÜ²½·¢³öµÄÉùÒô
    m_nFootStepSound: Integer; //CM_WALK, CM_RUN //0x188  ×ß²½Éù
    m_nStruckSound: Integer; //SM_STRUCK         //0x18C  ÍäÑüÉùÒô
    m_nStruckWeaponSound: Integer; //0x190  ±»Ö¸¶¨ÎäÆ÷¹¥»÷ÍäÑüÉùÒô

    m_nAppearSound: Integer; //µîÀå¼Ò¸® 0    //0x194
    m_nNormalSound: Integer; //ÀÏ¹Ý¼Ò¸® 1    //0x198
    m_nAttackSound: Integer; //         2    //0x19C
    m_nWeaponSound: Integer; //          3    //0x1A0
    m_nScreamSound: Integer; //         4    //0x1A4
    m_nDieSound: Integer; //Á×À»¶§   5 SM_DEATHNOW //0x1A8
    m_nDie2Sound: Integer; //0x1AC

    m_nMagicStartSound: Integer; //0x1B0
    m_nMagicFireSound: Integer; //0x1B4
    m_nMagicExplosionSound: Integer; //0x1B8
    m_Action: pTMonsterAction;
  private
    function GetMessage(ChrMsg: pTChrMsg): Boolean;
  protected
    m_nStartFrame: Integer; //0x1BC        //0x1A8
    m_nEndFrame: Integer; //0x1C0      //0x1AC
    m_nCurrentFrame: Integer; //0x1C4          //0x1B0
    m_nEffectStart: Integer; //0x1C8         //0x1B4
    m_nEffectFrame: Integer; //0x1CC         //0x1B8
    m_nEffectEnd: Integer; //0x1D0       //0x1BC
    m_dwEffectStartTime: LongWord; //0x1D4             //0x1C0
    m_dwEffectFrameTime: LongWord; //0x1D8             //0x1C4
    m_dwFrameTime: LongWord; //0x1DC       //0x1C8
    m_dwStartTime: LongWord; //0x1E0       //0x1CC
    m_nMaxTick: Integer; //0x1E4
    m_nCurTick: Integer; //0x1E8
    m_nMoveStep: Integer; //0x1EC
    m_boMsgMuch: Boolean; //0x1F0
    m_dwStruckFrameTime: LongWord; //0x1F4
    m_nCurrentDefFrame: Integer; //0x1F8          //0x1E4
    m_dwDefFrameTime: LongWord; //0x1FC       //0x1E8
    m_nDefFrameCount: Integer; //0x200        //0x1EC
    m_nSkipTick: Integer; //0x204
    m_dwSmoothMoveTime: LongWord; //0x208
    m_dwGenAnicountTime: LongWord; //0x20C
    m_dwLoadSurfaceTime: LongWord; //0x210  //0x200

    m_nOldx: Integer;
    m_nOldy: Integer;
    m_nOldDir: Integer; //0x214 0x218 0x21C
    m_nActBeforeX: Integer;
    m_nActBeforeY: Integer; //0x220 0x224
    m_nWpord: Integer; //0x228

    procedure CalcActorFrame; dynamic;
    procedure DefaultMotion; dynamic;
    function GetDefaultFrame(wmode: Boolean): Integer; dynamic;
    procedure DrawEffSurface(dsurface, source: TDirectDrawSurface; ddx, ddy: Integer; blend: Boolean; ceff: TColorEffect);
    procedure DrawWeaponGlimmer(dsurface: TDirectDrawSurface; ddx, ddy: Integer);
  public
    m_MsgList: TGList; //list of PTChrMsg 0x22C  //0x21C
    RealActionMsg: TChrMsg; //FrmMain    0x230

    constructor Create; dynamic;
    destructor Destroy; override;
    procedure SendMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
    procedure UpdateMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
    procedure CleanUserMsgs;
    procedure ProcMsg;
    procedure ProcHurryMsg;
    function IsIdle: Boolean;
    function ActionFinished: Boolean;
    function CanWalk: Integer;
    function CanRun: Integer;
    function Strucked: Boolean;
    procedure Shift(dir, step, cur, max: Integer);
    procedure ReadyAction(msg: TChrMsg);
    function CharWidth: Integer;
    function CharHeight: Integer;
    function CheckSelect(dx, dy: Integer): Boolean;
    procedure CleanCharMapSetting(x, y: Integer);
    procedure Say(str: string);
    procedure SetSound; dynamic;
    procedure Run; dynamic;
    procedure RunSound; dynamic;
    procedure RunActSound(frame: Integer); dynamic;
    procedure RunFrameAction(frame: Integer); dynamic; //ÇÁ·¡ÀÓ¸¶´Ù µ¶Æ¯ÇÏ°Ô ÇØ¾ßÇÒÀÏ
    procedure ActionEnded; dynamic;
    function Move(step: Integer): Boolean;
    procedure MoveFail;
    function CanCancelAction: Boolean;
    procedure CancelAction;
    procedure FeatureChanged; dynamic;
    function Light: Integer; dynamic;
    procedure LoadSurface; dynamic;
    function GetDrawEffectValue: TColorEffect;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend: Boolean; boFlag: Boolean); dynamic;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: Integer); dynamic;
  end;

  TNpcActor = class(TActor)
  private
    m_nEffX: Integer; //0x240
    m_nEffY: Integer; //0x244
    m_bo248: Boolean; //0x248
    m_dwUseEffectTick: LongWord; //0x24C
    m_EffSurface: TDirectDrawSurface; //0x250
  public
    g_boNpcWalk  :Boolean; //NPC×ß¶¯ 20080621
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure LoadSurface; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: Integer); override;
  end;

  THumActor = class(TActor) //Size: 0x27C Address: 0x00475BB8
  private
    m_HairSurface: TDirectDrawSurface; //0x250  //0x240
    m_WeaponSurface: TDirectDrawSurface; //0x254  //0x244
    m_HumWinSurface: TDirectDrawSurface; //0x258  //0x248
    m_boWeaponEffect: Boolean; //0x25C  //0x24C
    m_nCurWeaponEffect: Integer; //0x260  //0x250
    m_nCurBubbleStruck: Integer; //0x264  //0x254
    m_dwWeaponpEffectTime: LongWord; //0x268
    m_boHideWeapon: Boolean; //0x26C
    m_nFrame: Integer;
    m_dwFrameTick: LongWord;
    m_dwFrameTime: LongWord;
    m_bo2D0: Boolean;
  protected
    procedure CalcActorFrame; override;
    procedure DefaultMotion; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Run; override;
    procedure RunFrameAction(frame: Integer); override;
    function Light: Integer; override;
    procedure LoadSurface; override;
    procedure DoWeaponBreakEffect;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
  end;

function GetRaceByPM(race: Integer; Appr: Word): pTMonsterAction;
function aGetMonImg(Appr: Integer): TWMImages;
function GetOffset(Appr: Integer): Integer;
function GetNpcOffset(nAppr: Integer): Integer;


implementation

uses
  ClMain, SoundUtil, clEvent, MShare;


function GetRaceByPM(race: Integer; Appr: Word): pTMonsterAction;
begin
  Result := nil;
  {
  case race of
     10,24:      Result := @MA10;
     11:      Result := @MA11;
     12:      Result := @MA12;
     13:      Result := @MA13;
     14, 17, 18, 23:  Result := @MA14;
     15, 22:  Result := @MA15;
     16:      Result := @MA16;
     30, 31:  Result := @MA17;
     19, 20, 21, 40, 45, 52, 53:  Result := @MA19;
     41, 42:  Result := @MA20;
     43:      Result := @MA21;
     47:      Result := @MA22;
     48, 49:  Result := @MA23;
     32:      Result := @MA24;  //Àü°¥, °ø°ÝÀÌ 2°¡Áö ¹æ½Ä
//      33:      Result := @MA25;
     54:      Result := @MA28;
     55:      Result := @MA29;
     98:      Result := @MA27;
     99:      Result := @MA26;
     50:      Result := @MA50;
     33:      Result := @MA51;
     34:      Result := @MA52;
  end;
  }

  case race of
    9 {01}: Result := @MA9; //475D70
    10 {02}: Result := @MA10; //475D7C
    11 {03}: Result := @MA11; //475D88
    12 {04}: Result := @MA12; //475D94
    13 {05}: Result := @MA14; //475DA0
    14 {06}: Result := @MA14; //475DAC
    15 {07}: Result := @MA15; //475DB8
    16 {08}: Result := @MA16; //475DC4
    17 {06}: Result := @MA14; //475DAC
    18 {06}: Result := @MA14; //475DAC
    19 {0A}: Result := @MA19; //475DDC
    20 {0A}: Result := @MA19; //475DDC
    21 {0A}: Result := @MA19; //475DDC
    22 {07}: Result := @MA15; //475DB8
    23 {06}: Result := @MA14; //475DAC
    24 {04}: Result := @MA12; //475D94
    30 {09}: Result := @MA17; //475DD0
    31 {09}: Result := @MA17; //475DD0
    32 {0F}: Result := @MA24; //475E18
    33 {10}: Result := @MA25; //475E24
    34 {11}: Result := @MA30; //475E30  ³àÔÂ¶ñÄ§
    35 {12}: Result := @MA31; //475E3C
    36 {13}: Result := @MA32; //475E48
    37 {0A}: Result := @MA19; //475DDC
    40 {0A}: Result := @MA19; //475DDC
    41 {0B}: Result := @MA20; //475DE8
    42 {0B}: Result := @MA20; //475DE8
    43 {0C}: Result := @MA21; //475DF4
    45 {0A}: Result := @MA19; //475DDC
    47 {0D}: Result := @MA22; //475E00
    48 {0E}: Result := @MA23; //475E0C
    49 {0E}: Result := @MA23; //475E0C
    50 {27}: begin //475F32
        case Appr of
          23 {01}: Result := @MA36; //475F77
          24 {02}: Result := @MA37; //475F80
          25 {02}: Result := @MA37; //475F80
          26 {00}: Result := @MA35; //475F9B
          27 {02}: Result := @MA37; //475F80
          28 {00}: Result := @MA35; //475F9B
          29 {00}: Result := @MA35; //475F9B
          30 {00}: Result := @MA35; //475F9B
          31 {00}: Result := @MA35; //475F9B
          32 {02}: Result := @MA37; //475F80
          33 {00}: Result := @MA35; //475F9B
          34 {00}: Result := @MA35; //475F9B
          35 {03}: Result := @MA41; //475F89
          36 {03}: Result := @MA41; //475F89
          37 {03}: Result := @MA41; //475F89
          38 {03}: Result := @MA41; //475F89
          39 {03}: Result := @MA41; //475F89
          40 {03}: Result := @MA41; //475F89
          41 {03}: Result := @MA41; //475F89
          42 {04}: Result := @MA46; //475F92
          43 {04}: Result := @MA46; //475F92
          44 {04}: Result := @MA46; //475F92
          45 {04}: Result := @MA46; //475F92
          46 {04}: Result := @MA46; //475F92
          47 {04}: Result := @MA46; //475F92
          48 {03}: Result := @MA41; //4777B3
          49 {03}: Result := @MA41; //4777B3
          50 {03}: Result := @MA41; //4777B3
          51 {00}: Result := @MA35; //4777C5
          52 {03}: Result := @MA41; //4777B3
          53 {03}: Result := @MA41; //4777B3
          else Result := @MA35;
        end;
      end;

    52 {0A}: Result := @MA19; //475DDC
    53 {0A}: Result := @MA19; //475DDC
    54 {14}: Result := @MA28; //475E54
    55 {15}: Result := @MA29; //475E60
    60 {16}: Result := @MA33; //475E6C
    61 {16}: Result := @MA33; //475E6C
    62 {16}: Result := @MA33; //475E6C
    63 {17}: Result := @MA34; //475E78
    64 {18}: Result := @MA19; //475E84
    65 {18}: Result := @MA19; //475E84
    66 {18}: Result := @MA19; //475E84
    67 {18}: Result := @MA19; //475E84
    68 {18}: Result := @MA19; //475E84
    69 {18}: Result := @MA19; //475E84
    70 {19}: Result := @MA33; //475E90
    71 {19}: Result := @MA33; //475E90
    72 {19}: Result := @MA33; //475E90
    73 {1A}: Result := @MA19; //475E9C
    74 {1B}: Result := @MA19; //475EA8
    75 {1C}: Result := @MA39; //475EB4
    76 {1D}: Result := @MA38; //475EC0
    77 {1E}: Result := @MA39; //475ECC
    78 {1F}: Result := @MA40; //475ED8
    79 {20}: Result := @MA19; //475EE4
    80 {21}: Result := @MA42; //475EF0
    81 {22}: Result := @MA43; //475EFC
    83 {23}: Result := @MA44; //475F08
    84 {24}: Result := @MA45; //475F14
    85 {24}: Result := @MA45; //475F14
    86 {24}: Result := @MA45; //475F14
    87 {24}: Result := @MA45; //475F14
    88 {24}: Result := @MA45; //475F14
    89 {24}: Result := @MA45; //475F14
    90 {11}: Result := @MA30; //475E30
    98 {25}: Result := @MA27; //475F20
    99 {26}: Result := @MA26; //475F29
  end
end;

function aGetMonImg(Appr: Integer): TWMImages;
var
  WMImage: TWMImages;
begin
  Result := FrmMain.WMonImg;
  case (Appr div 10) of
    0: Result := FrmMain.WMonImg;
    1: Result := FrmMain.WMon2Img;
    2: Result := FrmMain.WMon3Img;
    3: Result := FrmMain.WMon4Img;
    4: Result := FrmMain.WMon5Img;
    5: Result := FrmMain.WMon6Img;
    6: Result := FrmMain.WMon7Img;
    7: Result := FrmMain.WMon8Img;
    8: Result := FrmMain.WMon9Img;
    9: Result := FrmMain.WMon10Img;
    10: Result := FrmMain.WMon11Img;
    11: Result := FrmMain.WMon12Img;
    12: Result := FrmMain.WMon13Img;
    13: Result := FrmMain.WMon14Img;
    14: Result := FrmMain.WMon15Img;
    15: Result := FrmMain.WMon16Img;
    16: Result := FrmMain.WMon17Img;
    17: Result := FrmMain.WMon18Img;
    18: Result := FrmMain.WMon19Img;
    19: Result := FrmMain.WMon20Img;
    20: Result := FrmMain.WMon21Img;
    21: Result := FrmMain.WMon22Img;
    22: Result := FrmMain.WMon23Img;

    49: Result := FrmMain.WMon50Img;
    50: Result := FrmMain.WMon51Img;
    51: Result := FrmMain.WMon52Img;
    52: Result := FrmMain.WMon53Img;
    53: Result := FrmMain.WMon54Img;
    80: Result := FrmMain.WDragonImg;
    90: Result := FrmMain.WEffectImg;
  end;
  {
  if (appr >= 1000) and FrmMain.GetMonImg(appr,WMImage) then begin
    Result:=WMImage;
  end;
  }
end;

function GetOffset(Appr: Integer): Integer;
var
  nrace, npos: Integer;
begin
  Result := 0;
  if (Appr >= 1000) then Exit;
  nrace := Appr div 10;
  npos := Appr mod 10;
  case nrace of
    0: Result := npos * 280; //8ÇÁ·¡ÀÓ
    1: Result := npos * 230;
    2, 3, 7..12: Result := npos * 360; //10ÇÁ·¡ÀÓ ±âº»
    4: begin
        Result := npos * 360; //
        if npos = 1 then Result := 600; //ºñ¸·¿øÃæ
      end;
    5: Result := npos * 430; //
    6: Result := npos * 440; //
    //      13:   Result := npos * 360;
    13: case npos of
        0: Result := 0;
        1: Result := 360;
        2: Result := 440;
        3: Result := 550;
        else Result := npos * 360;
      end;
    14: Result := npos * 360;
    15: Result := npos * 360;
    16: Result := npos * 360;
    17: case npos of
        2: Result := 920;
        else Result := npos * 350;
      end;
    18: case npos of
        0: Result := 0; //¼º¹®
        1: Result := 520;
        2: Result := 950;
      end;
    19: case npos of
        0: Result := 0; //¼º¹®
        1: Result := 370;
        2: Result := 810;
        3: Result := 1250;
        4: Result := 1630;
        5: Result := 2010;
        6: Result := 2390;
      end;
    20: case npos of
        0: Result := 0; //¼º¹®
        1: Result := 360;
        2: Result := 720;
        3: Result := 1080;
        4: Result := 1440;
        5: Result := 1800;
        6: Result := 2350;
        7: Result := 3060;
      end;
    21: case npos of
        0: Result := 0; //¼º¹®
        1: Result := 460;
        2: Result := 820;
        3: Result := 1180;
        4: Result := 1540;
        5: Result := 1900;
        //               6: Result := 2260;
        6: Result := 2440;
        7: Result := 2570;
        8: Result := 2700;
      end;
    22: case npos of
        0: Result := 0;
        1: Result := 430;
        2: Result := 1290;
        3: Result := 1810;
      end;
    49, 50, 51, 52, 53: Result := npos * 360;
    80: case npos of
        0: Result := 0; //¼º¹®
        1: Result := 80;
        2: Result := 300;
        3: Result := 301;
        4: Result := 302;
        5: Result := 320;
        6: Result := 321;
        7: Result := 322;
        8: Result := 321;
      end;
    90: case npos of
        0: Result := 80; //¼º¹®
        1: Result := 168;
        2: Result := 184;
        3: Result := 200;
      end;
  end;
end;

function GetNpcOffset(nAppr: Integer): Integer;
begin
  Result := 0;
  case nAppr of
    {
    0..34: Result:=nAppr * 60;
    35: Result:=2040;
    36: Result:=2100;
    37..42: Result:=(nAppr - 37) * 60 + 2160;
    43: Result:=2520;
    44: Result:=2580;
    45: Result:=2640;
    46: Result:=2700;
    47: Result:=2760;
    48: Result:=2820;
    49: Result:=2880;
    50: Result:=2940;
    51: Result:=2960;
    }

    24, 25: Result := (nAppr - 24) * 60 + 1470;
    0..22: Result := nAppr * 60;
    23: Result := 1380;
    27, 32: Result := (nAppr - 26) * 60 + 1620 - 30;
    26, 28, 29, 30, 31, 33..41: Result := (nAppr - 26) * 60 + 1620;
    42, 43: Result := 2580;
    44..47: Result := 2640;
    48..50: Result := (nAppr - 48) * 60 + 2700;
    51: Result := 2880;
    52: Result := 2960;
  end;
end;

constructor TActor.Create;
begin
  inherited Create;
  FillChar(m_Abil, Sizeof(TAbility), 0);
  FillChar(m_Action, Sizeof(m_Action), 0);

  m_MsgList := TGList.Create;
  m_nRecogId := 0;
  m_BodySurface := nil;
  m_nGold := 0;
  m_boVisible := TRUE;
  m_boHoldPlace := TRUE;

  //ÇöÀç ÁøÇàÁßÀÎ µ¿ÀÛ, Á¾·á‰ç¾îµµ °¡Áö°í ÀÖÀ½
  //µ¿ÀÛÀÇ m_nCurrentFrameÀÌ m_nEndFrameÀ» ³Ñ¾úÀ¸¸é µ¿ÀÛÀÌ ¿Ï·áµÈ°ÍÀ¸·Î º½
  m_nCurrentAction := 0;
  m_boReverseFrame := FALSE;
  m_nShiftX := 0;
  m_nShiftY := 0;
  m_nDownDrawLevel := 0;
  m_nCurrentFrame := -1;
  m_nEffectFrame := -1;
  RealActionMsg.Ident := 0;
  m_sUserName := '';
  m_nNameColor := clWhite;
  m_dwSendQueryUserNameTime := 0; //GetTickCount;
  m_boWarMode := FALSE;
  m_dwWarModeTime := 0; //War mode
  m_boDeath := FALSE;
  m_boSkeleton := FALSE;
  m_boDelActor := FALSE;
  m_boDelActionAfterFinished := FALSE;

  m_nChrLight := 0;
  m_nMagLight := 0;
  m_boLockEndFrame := FALSE;
  m_dwSmoothMoveTime := 0; //GetTickCount;
  m_dwGenAnicountTime := 0;
  m_dwDefFrameTime := 0;
  m_dwLoadSurfaceTime := GetTickCount;
  m_boGrouped := FALSE;
  m_boOpenHealth := FALSE;
  m_noInstanceOpenHealth := FALSE;
  m_CurMagic.ServerMagicCode := 0;
  //CurMagic.MagicSerial := 0;

  m_nSpellFrame := DEFSPELLFRAME;

  m_nNormalSound := -1;
  m_nFootStepSound := -1; //¾øÀ½  //ÁÖÀÎ°øÀÎ°æ¿ì, CM_WALK, CM_RUN
  m_nAttackSound := -1;
  m_nWeaponSound := -1;
  m_nStruckSound := s_struck_body_longstick; //¸ÂÀ»¶§ ³ª´Â ¼Ò¸®    SM_STRUCK
  m_nStruckWeaponSound := -1;
  m_nScreamSound := -1;
  m_nDieSound := -1; //¾øÀ½    //Á×À»¶§ ³ª´Â ¼Ò¸®    SM_DEATHNOW
  m_nDie2Sound := -1;
end;

destructor TActor.Destroy;
var
  I: Integer;
  msg: pTChrMsg;
begin
  for I := 0 to m_MsgList.Count - 1 do begin
    msg := m_MsgList.Items[I];
    Dispose(msg);
  end;
  m_MsgList.Free;
  inherited Destroy;
end;

procedure TActor.SendMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
var
  msg: pTChrMsg;
begin
  New(msg);
  msg.Ident := wIdent;
  msg.x := nX;
  msg.y := nY;
  msg.dir := ndir;
  msg.feature := nFeature;
  msg.state := nState;
  msg.saying := sStr;
  msg.Sound := nSound;
  m_MsgList.Lock;
  try
    m_MsgList.Add(msg);
  finally
    m_MsgList.UnLock;
  end;
end;

procedure TActor.UpdateMsg(wIdent: Word; nX, nY, ndir, nFeature, nState: Integer; sStr: string; nSound: Integer);
var
  I: Integer;
  msg: pTChrMsg;
begin
  m_MsgList.Lock;
  try
    I := 0;
    while TRUE do begin
      if I >= m_MsgList.Count then break;
      msg := m_MsgList.Items[I];
      if ((Self = g_MySelf) and (msg.Ident >= 3000) and (msg.Ident <= 3099)) or (msg.Ident = wIdent) then begin
        Dispose(msg);
        m_MsgList.Delete(I);
        Continue;
      end;
      Inc(I);
    end;
  finally
    m_MsgList.UnLock;
  end;
  SendMsg(wIdent, nX, nY, ndir, nFeature, nState, sStr, nSound);
end;

procedure TActor.CleanUserMsgs;
var
  I: Integer;
  msg: pTChrMsg;
begin
  m_MsgList.Lock;
  try
    I := 0;
    while TRUE do begin
      if I >= m_MsgList.Count then break;
      msg := m_MsgList.Items[I];
      if (msg.Ident >= 3000) and //Å¬¶óÀÌ¾ðÆ®¿¡¼­ º¸³½ ¸Þ¼¼Áö´Â
      (msg.Ident <= 3099) then begin
        Dispose(msg);
        m_MsgList.Delete(I);
        Continue;
      end;
      Inc(I);
    end;
  finally
    m_MsgList.UnLock;
  end;
end;

procedure TActor.CalcActorFrame;
var
  haircount: Integer;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;

  m_nBodyOffset := GetOffset(m_wAppearance);
  m_Action := GetRaceByPM(m_btRace, m_wAppearance);
  if m_Action = nil then Exit;

  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := m_Action.ActStand.start + m_btDir * (m_Action.ActStand.frame + m_Action.ActStand.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
        m_dwFrameTime := m_Action.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := m_Action.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_WALK, SM_RUSH, SM_RUSHKUNG, SM_BACKSTEP: begin
        m_nStartFrame := m_Action.ActWalk.start + m_btDir * (m_Action.ActWalk.frame + m_Action.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActWalk.frame - 1;
        m_dwFrameTime := m_Action.ActWalk.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := m_Action.ActWalk.usetick;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BACKSTEP then
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    {SM_BACKSTEP:
       begin
          startframe := pm.ActWalk.start + (pm.ActWalk.frame - 1) + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
          m_nEndFrame := startframe - (pm.ActWalk.frame - 1);
          m_dwFrameTime := pm.ActWalk.ftime;
          m_dwStartTime := GetTickCount;
          m_nMaxTick := pm.ActWalk.UseTick;
          m_nCurTick := 0;
          m_nMoveStep := 1;
          Shift (GetBack(Dir), m_nMoveStep, 0, m_nEndFrame-startframe+1);
       end;}
    SM_HIT: begin
        m_nStartFrame := m_Action.ActAttack.start + m_btDir * (m_Action.ActAttack.frame + m_Action.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActAttack.frame - 1;
        m_dwFrameTime := m_Action.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        //WarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_STRUCK: begin
        m_nStartFrame := m_Action.ActStruck.start + m_btDir * (m_Action.ActStruck.frame + m_Action.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; //pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_DEATH: begin
        m_nStartFrame := m_Action.ActDie.start + m_btDir * (m_Action.ActDie.frame + m_Action.ActDie.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH: begin
        m_nStartFrame := m_Action.ActDie.start + m_btDir * (m_Action.ActDie.frame + m_Action.ActDie.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_SKELETON: begin
        m_nStartFrame := m_Action.ActDeath.start + m_btDir;
        m_nEndFrame := m_nStartFrame + m_Action.ActDeath.frame - 1;
        m_dwFrameTime := m_Action.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

procedure TActor.ReadyAction(msg: TChrMsg);
var
  n: Integer;
  UseMagic: PTUseMagicInfo;
begin
  m_nActBeforeX := m_nCurrX;
  m_nActBeforeY := m_nCurrY;

  if msg.Ident = SM_ALIVE then begin
    m_boDeath := FALSE;
    m_boSkeleton := FALSE;
  end;
  if not m_boDeath then begin
    case msg.Ident of
      SM_TURN, SM_WALK, SM_BACKSTEP, SM_RUSH, SM_RUSHKUNG, SM_RUN, SM_HORSERUN, SM_DIGUP, SM_ALIVE: begin
          m_nFeature := msg.feature;
          m_nState := msg.state;
          if m_nState and STATE_OPENHEATH <> 0 then m_boOpenHealth := TRUE
          else m_boOpenHealth := FALSE;
        end;
    end;
    if msg.Ident = SM_LIGHTING then
      n := 0;
    if g_MySelf = Self then begin
      if (msg.Ident = CM_WALK) then
        if not PlayScene.CanWalk(msg.x, msg.y) then
          Exit; //ÀÌµ¿ ºÒ°¡
      if (msg.Ident = CM_RUN) then
        if not PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, msg.x, msg.y) then
          Exit; //ÀÌµ¿ ºÒ°¡
      if (msg.Ident = CM_HORSERUN) then
        if not PlayScene.CanRun(g_MySelf.m_nCurrX, g_MySelf.m_nCurrY, msg.x, msg.y) then
          Exit; //ÀÌµ¿ ºÒ°¡

      //msg
      case msg.Ident of
        CM_TURN,
          CM_WALK,
          CM_SITDOWN,
          CM_RUN,
          CM_HIT,
          CM_HEAVYHIT,
          CM_BIGHIT,
          CM_POWERHIT,
          CM_LONGHIT,
          CM_WIDEHIT: begin
            RealActionMsg := msg; //ÇöÀç ½ÇÇàµÇ°í ÀÖ´Â Çàµ¿, ¼­¹ö¿¡ ¸Þ¼¼Áö¸¦ º¸³¿.
            msg.Ident := msg.Ident - 3000; //SM_?? À¸·Î º¯È¯ ÇÔ
          end;
        CM_HORSERUN: begin
            RealActionMsg := msg;
            msg.Ident := SM_HORSERUN;
          end;
        CM_THROW: begin
            if m_nFeature <> 0 then begin
              m_nTargetX := TActor(msg.feature).m_nCurrX; //x ´øÁö´Â ¸ñÇ¥
              m_nTargetY := TActor(msg.feature).m_nCurrY; //y
              m_nTargetRecog := TActor(msg.feature).m_nRecogId;
            end;
            RealActionMsg := msg;
            msg.Ident := SM_THROW;
          end;
        CM_FIREHIT: begin
            RealActionMsg := msg;
            msg.Ident := SM_FIREHIT;
          end;
        CM_CRSHIT: begin
            RealActionMsg := msg;
            msg.Ident := SM_CRSHIT;
          end;
        CM_TWINHIT: begin
            RealActionMsg := msg;
            msg.Ident := SM_TWINHIT;
          end;
        CM_3037: begin
            RealActionMsg := msg;
            msg.Ident := SM_41;
          end;
        CM_SPELL: begin
            RealActionMsg := msg;
            UseMagic := PTUseMagicInfo(msg.feature);
            RealActionMsg.dir := UseMagic.MagicSerial;
            msg.Ident := msg.Ident - 3000; //SM_?? À¸·Î º¯È¯ ÇÔ
          end;
      end;

      m_nOldx := m_nCurrX;
      m_nOldy := m_nCurrY;
      m_nOldDir := m_btDir;
    end;
    case msg.Ident of
      SM_STRUCK: begin
          //Abil.HP := msg.x; {HP}
          //Abil.MaxHP := msg.y; {maxHP}
          //msg.dir {damage}
          //·¹º§ÀÌ ³ôÀ¸¸é ¸Â´Â ½Ã°£ÀÌ Âª´Ù.
          m_nMagicStruckSound := msg.x; //1ÀÌ»ó, ¸¶¹ýÈ¿°ú
          n := Round(200 - m_Abil.Level * 5);
          if n > 80 then m_dwStruckFrameTime := n
          else m_dwStruckFrameTime := 80;
          m_dwLastStruckTime := GetTickCount;
        end;
      SM_SPELL: begin
          m_btDir := msg.dir;
          //msg.x  :targetx
          //msg.y  :targety
          UseMagic := PTUseMagicInfo(msg.feature);
          if UseMagic <> nil then begin
            m_CurMagic := UseMagic^;
            m_CurMagic.ServerMagicCode := -1; //FIRE ´ë±â
            //CurMagic.MagicSerial := 0;
            m_CurMagic.TargX := msg.x;
            m_CurMagic.TargY := msg.y;
            Dispose(UseMagic);
          end;
          //DScreen.AddSysMsg ('SM_SPELL');
        end;
      else begin
          m_nCurrX := msg.x;
          m_nCurrY := msg.y;
          m_btDir := msg.dir;
        end;
    end;

    m_nCurrentAction := msg.Ident;
    CalcActorFrame;
    //DScreen.AddSysMsg (IntToStr(msg.Ident) + ' ' + IntToStr(XX) + ' ' + IntToStr(YY) + ' : ' + IntToStr(msg.x) + ' ' + IntToStr(msg.y));
  end else begin
    if msg.Ident = SM_SKELETON then begin
      m_nCurrentAction := msg.Ident;
      CalcActorFrame;
      m_boSkeleton := TRUE;
    end;
  end;
  if (msg.Ident = SM_DEATH) or (msg.Ident = SM_NOWDEATH) then begin
    m_boDeath := TRUE;
    PlayScene.ActorDied(Self);
  end;
  RunSound;
end;

function TActor.GetMessage(ChrMsg: pTChrMsg): Boolean;
var
  msg: pTChrMsg;
begin
  Result := FALSE;
  m_MsgList.Lock;
  try
    if m_MsgList.Count > 0 then begin
      msg := m_MsgList.Items[0];
      ChrMsg.Ident := msg.Ident;
      ChrMsg.x := msg.x;
      ChrMsg.y := msg.y;
      ChrMsg.dir := msg.dir;
      ChrMsg.state := msg.state;
      ChrMsg.feature := msg.feature;
      ChrMsg.saying := msg.saying;
      ChrMsg.Sound := msg.Sound;
      Dispose(msg);
      m_MsgList.Delete(0);
      Result := TRUE;
    end;
  finally
    m_MsgList.UnLock;
  end;
end;

procedure TActor.ProcMsg;
var
  msg: TChrMsg;
  Meff: TMagicEff;
begin
  while (m_nCurrentAction = 0) and GetMessage(@msg) do begin
    case msg.Ident of
      SM_STRUCK: begin
          m_nHiterCode := msg.Sound;
          ReadyAction(msg);
        end;
      SM_DEATH, //27
      SM_NOWDEATH,
        SM_SKELETON,
        SM_ALIVE,
        SM_ACTION_MIN..SM_ACTION_MAX, //26
      SM_ACTION2_MIN..SM_ACTION2_MAX, //35   2293    293
      3000..3099: ReadyAction(msg);
      SM_SPACEMOVE_HIDE: begin
          Meff := TScrollHideEffect.Create(250, 10, m_nCurrX, m_nCurrY, Self);
          PlayScene.m_EffectList.Add(Meff);
          PlaySound(s_spacemove_out);
        end;
      SM_SPACEMOVE_HIDE2: begin
          Meff := TScrollHideEffect.Create(1590, 10, m_nCurrX, m_nCurrY, Self);
          PlayScene.m_EffectList.Add(Meff);
          PlaySound(s_spacemove_out);
        end;
      SM_SPACEMOVE_SHOW: begin
          Meff := TCharEffect.Create(260, 10, Self);
          PlayScene.m_EffectList.Add(Meff);
          msg.Ident := SM_TURN;
          ReadyAction(msg);
          PlaySound(s_spacemove_in);
        end;
      SM_SPACEMOVE_SHOW2: begin
          Meff := TCharEffect.Create(1600, 10, Self);
          PlayScene.m_EffectList.Add(Meff);
          msg.Ident := SM_TURN;
          ReadyAction(msg);
          PlaySound(s_spacemove_in);
        end;
      else begin
          ReadyAction(msg); //Damian
        end;
    end;
  end;
end;

procedure TActor.ProcHurryMsg; //»¡¸® Ã³¸®ÇØ¾ß µÇ´Â ¸Þ¼¼Áö Ã³¸®ÇÔ..
var
  n: Integer;
  msg: TChrMsg;
  fin: Boolean;
begin
  n := 0;
  while TRUE do begin
    if m_MsgList.Count <= n then break;
    msg := pTChrMsg(m_MsgList[n])^;
    fin := FALSE;
    case msg.Ident of
      SM_MAGICFIRE:
        if m_CurMagic.ServerMagicCode <> 0 then begin
          m_CurMagic.ServerMagicCode := 111;
          m_CurMagic.Target := msg.x;
          if msg.y in [0..MAXMAGICTYPE - 1] then
            m_CurMagic.EffectType := TMagicType(msg.y); //EffectType
          m_CurMagic.EffectNumber := msg.dir; //Effect
          m_CurMagic.TargX := msg.feature;
          m_CurMagic.TargY := msg.state;
          m_CurMagic.Recusion := TRUE;
          fin := TRUE;
          //               DScreen.AddSysMsg ('SM_MAGICFIRE GOOD');
        end;
      SM_MAGICFIRE_FAIL:
        if m_CurMagic.ServerMagicCode <> 0 then begin
          m_CurMagic.ServerMagicCode := 0;
          fin := TRUE;
        end;
    end;
    if fin then begin
      Dispose(pTChrMsg(m_MsgList[n]));
      m_MsgList.Delete(n);
    end else
      Inc(n);
  end;
end;

function TActor.IsIdle: Boolean;
begin
  if (m_nCurrentAction = 0) and (m_MsgList.Count = 0) then
    Result := TRUE
  else Result := FALSE;
end;

function TActor.ActionFinished: Boolean;
begin
  if (m_nCurrentAction = 0) or (m_nCurrentFrame >= m_nEndFrame) then
    Result := TRUE
  else Result := FALSE;
end;

function TActor.CanWalk: Integer;
begin
  //¾ò¾î ¸ÂÀº ´ÙÀ½¿¡ °ÉÀ» ¼ö ¾ø´Ù. or ¸¶¹ý µô·¡ÀÌ
  if {(GetTickCount - LastStruckTime < 1300) or}(GetTickCount - g_dwLatestSpellTick < g_dwMagicPKDelayTime) then
    Result := -1 //µô·¹ÀÌ
  else
    Result := 1;
end;

function TActor.CanRun: Integer;
begin
  Result := 1;
  //¼ì²éÈËÎïµÄHPÖµÊÇ·ñµÍÓÚÖ¸¶¨Öµ£¬µÍÓÚÖ¸¶¨Öµ½«²»ÔÊÐíÅÜ
  if m_Abil.HP < RUN_MINHEALTH then begin
    Result := -1;
  end else
    //¼ì²éÈËÎïÊÇ·ñ±»¹¥»÷£¬Èç¹û±»¹¥»÷½«²»ÔÊÐíÅÜ£¬È¡Ïû¼ì²â½«¿ÉÒÔÅÜ²½ÌÓÅÜ
 //   if (GetTickCount - LastStruckTime < 3*1000) or (GetTickCount - LatestSpellTime < MagicPKDelayTime) then
 //      Result := -2;

end;

function TActor.Strucked: Boolean;
var
  I: Integer;
begin
  Result := FALSE;
  for I := 0 to m_MsgList.Count - 1 do begin
    if pTChrMsg(m_MsgList[I]).Ident = SM_STRUCK then begin
      Result := TRUE;
      break;
    end;
  end;
end;


//dir : ¹æÇâ
//step : ÀÌµ¿ Ä­
//cur : ÇöÀç ½ºÅÜ
//max : ÃÖ´ë ½ºÅÜ
procedure TActor.Shift(dir, step, cur, max: Integer);
var
  unx, uny, ss, v: Integer;
begin
  unx := UNITX * step;
  uny := UNITY * step;
  if cur > max then cur := max;
  m_nRx := m_nCurrX;
  m_nRy := m_nCurrY;
  ss := Round((max - cur - 1) / max) * step;
  case dir of
    DR_UP: begin
        ss := Round((max - cur) / max) * step;
        m_nShiftX := 0;
        m_nRy := m_nCurrY + ss;
        if ss = step then m_nShiftY := -Round(uny / max * cur)
        else m_nShiftY := Round(uny / max * (max - cur));
      end;
    DR_UPRIGHT: begin
        if max >= 6 then v := 2
        else v := 0;
        ss := Round((max - cur + v) / max) * step;
        m_nRx := m_nCurrX - ss;
        m_nRy := m_nCurrY + ss;
        if ss = step then begin
          m_nShiftX := Round(unx / max * cur);
          m_nShiftY := -Round(uny / max * cur);
        end else begin
          m_nShiftX := -Round(unx / max * (max - cur));
          m_nShiftY := Round(uny / max * (max - cur));
        end;
      end;
    DR_RIGHT: begin
        ss := Round((max - cur) / max) * step;
        m_nRx := m_nCurrX - ss;
        if ss = step then m_nShiftX := Round(unx / max * cur)
        else m_nShiftX := -Round(unx / max * (max - cur));
        m_nShiftY := 0;
      end;
    DR_DOWNRIGHT: begin
        if max >= 6 then v := 2
        else v := 0;
        ss := Round((max - cur - v) / max) * step;
        m_nRx := m_nCurrX - ss;
        m_nRy := m_nCurrY - ss;
        if ss = step then begin
          m_nShiftX := Round(unx / max * cur);
          m_nShiftY := Round(uny / max * cur);
        end else begin
          m_nShiftX := -Round(unx / max * (max - cur));
          m_nShiftY := -Round(uny / max * (max - cur));
        end;
      end;
    DR_DOWN: begin
        if max >= 6 then v := 1
        else v := 0;
        ss := Round((max - cur - v) / max) * step;
        m_nShiftX := 0;
        m_nRy := m_nCurrY - ss;
        if ss = step then m_nShiftY := Round(uny / max * cur)
        else m_nShiftY := -Round(uny / max * (max - cur));
      end;
    DR_DOWNLEFT: begin
        if max >= 6 then v := 2
        else v := 0;
        ss := Round((max - cur - v) / max) * step;
        m_nRx := m_nCurrX + ss;
        m_nRy := m_nCurrY - ss;
        if ss = step then begin
          m_nShiftX := -Round(unx / max * cur);
          m_nShiftY := Round(uny / max * cur);
        end else begin
          m_nShiftX := Round(unx / max * (max - cur));
          m_nShiftY := -Round(uny / max * (max - cur));
        end;
      end;
    DR_LEFT: begin
        ss := Round((max - cur) / max) * step;
        m_nRx := m_nCurrX + ss;
        if ss = step then m_nShiftX := -Round(unx / max * cur)
        else m_nShiftX := Round(unx / max * (max - cur));
        m_nShiftY := 0;
      end;
    DR_UPLEFT: begin
        if max >= 6 then v := 2
        else v := 0;
        ss := Round((max - cur + v) / max) * step;
        m_nRx := m_nCurrX + ss;
        m_nRy := m_nCurrY + ss;
        if ss = step then begin
          m_nShiftX := -Round(unx / max * cur);
          m_nShiftY := -Round(uny / max * cur);
        end else begin
          m_nShiftX := Round(unx / max * (max - cur));
          m_nShiftY := Round(uny / max * (max - cur));
        end;
      end;
  end;
end;

procedure TActor.FeatureChanged;
var
  haircount: Integer;
begin
  case m_btRace of
    //human
    0: begin
        m_btHair := HAIRfeature(m_nFeature); //º¯°æµÈ´Ù.
        m_btDress := DRESSfeature(m_nFeature);
        m_btWeapon := WEAPONfeature(m_nFeature);

        {DScreen.AddChatBoardString(inttostr(m_nFeatureEx), clBlack, clWhite);
        DScreen.AddChatBoardString(inttostr(Horsefeature(m_nFeatureEx)), clBlack, clWhite);
        DScreen.AddChatBoardString(inttostr(Effectfeature(m_nFeatureEx)), clBlack, clWhite);
        }
        m_btHorse := Horsefeature(m_nFeatureEx);
        m_btEffect := Effectfeature(m_nFeatureEx);
        m_nBodyOffset := HUMANFRAME * m_btDress; //³²ÀÚ0, ¿©ÀÚ1
        haircount := g_WHairImgImages.ImageCount div HUMANFRAME div 2;
        if m_btHair > haircount - 1 then m_btHair := haircount - 1;
        m_btHair := m_btHair * 2;
        if m_btHair > 1 then
          m_nHairOffset := HUMANFRAME * (m_btHair + m_btSex)
        else m_nHairOffset := -1;
        m_nWeaponOffset := HUMANFRAME * m_btWeapon; //(weapon*2 + m_btSex);
        //         if Dress in [1..4] then begin
        //         if Dress in [18..21] then begin
        //           HumWinOffset:=(Dress - 18)* HUMANFRAME;
        //         end;
        //               DScreen.AddSysMsg ('Effect: ' + IntToStr(Effect));
        if m_btEffect <> 0 then begin
          if m_btEffect = 50 then m_nHumWinOffset := 352
          else m_nHumWinOffset := (m_btEffect - 1) * HUMANFRAME;
        end;
      end;
    50: ; //npc
    else begin
        m_wAppearance := APPRfeature(m_nFeature);
        m_nBodyOffset := GetOffset(m_wAppearance);
        //BodyOffset := MONFRAME * (Appearance mod 10);
      end;
  end;
end;

function TActor.Light: Integer;
begin
  Result := m_nChrLight;
end;

procedure TActor.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := GetMonImg(m_wAppearance);
  if mimg <> nil then begin
    if (not m_boReverseFrame) then
      m_BodySurface := mimg.GetCachedImage(GetOffset(m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy)
    else
      m_BodySurface := mimg.GetCachedImage(
        GetOffset(m_wAppearance) + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame),
        m_nPx, m_nPy);
  end;
end;

function TActor.CharWidth: Integer;
begin
  if m_BodySurface <> nil then
    Result := m_BodySurface.Width
  else Result := 48;
end;

function TActor.CharHeight: Integer;
begin
  if m_BodySurface <> nil then
    Result := m_BodySurface.Height
  else Result := 70;
end;

function TActor.CheckSelect(dx, dy: Integer): Boolean;
var
  c: Integer;
begin
  Result := FALSE;
  if m_BodySurface <> nil then begin
    c := m_BodySurface.Pixels[dx, dy];
    if (c <> 0) and
      ((m_BodySurface.Pixels[dx - 1, dy] <> 0) and
      (m_BodySurface.Pixels[dx + 1, dy] <> 0) and
      (m_BodySurface.Pixels[dx, dy - 1] <> 0) and
      (m_BodySurface.Pixels[dx, dy + 1] <> 0)) then
      Result := TRUE;
  end;
end;

procedure TActor.DrawEffSurface(dsurface, source: TDirectDrawSurface; ddx, ddy: Integer; blend: Boolean; ceff: TColorEffect);
begin
  if m_nState and $00800000 <> 0 then begin
    blend := TRUE; //Åõ¸í
  end;
  if not blend then begin
    if ceff = ceNone then begin
      if source <> nil then
        dsurface.Draw(ddx, ddy, source.ClientRect, source, TRUE);
    end else begin
      if source <> nil then begin
        g_ImgMixSurface.Draw(0, 0, source.ClientRect, source, FALSE);
        DrawEffect(0, 0, source.Width, source.Height, g_ImgMixSurface, ceff);
        dsurface.Draw(ddx, ddy, source.ClientRect, g_ImgMixSurface, TRUE);
      end;
    end;
  end else begin
    if ceff = ceNone then begin
      if source <> nil then
        DrawBlend(dsurface, ddx, ddy, source, 0);
    end else begin
      if source <> nil then begin
        g_ImgMixSurface.Fill(0);
        g_ImgMixSurface.Draw(0, 0, source.ClientRect, source, FALSE);
        DrawEffect(0, 0, source.Width, source.Height, g_ImgMixSurface, ceff);
        DrawBlend(dsurface, ddx, ddy, g_ImgMixSurface, 0);
      end;
    end;
  end;
end;

procedure TActor.DrawWeaponGlimmer(dsurface: TDirectDrawSurface; ddx, ddy: Integer);
var
  idx, ax, ay: Integer;
  d: TDirectDrawSurface;
begin
  //»ç¿ë¾ÈÇÔ..(¿°È­°á) ±×·¡ÇÈ ¿À·ù...
  (*if BoNextTimeFireHit and WarMode and GlimmingMode then begin
     if GetTickCount - GlimmerTime > 200 then begin
        GlimmerTime := GetTickCount;
        Inc (CurGlimmer);
        if CurGlimmer >= MaxGlimmer then CurGlimmer := 0;
     end;
     idx := GetEffectBase (5-1{¿°È­°á¹ÝÂ¦ÀÓ}, 1) + Dir*10 + CurGlimmer;
     d := FrmMain.WMagic.GetCachedImage (idx, ax, ay);
     if d <> nil then
        DrawBlend (dsurface, ddx + ax, ddy + ay, d, 1);
                         //dx + ax + ShiftX,
                         //dy + ay + ShiftY,
                         //d, 1);
  end;*)
end;
//ÈËÎïÏÔÊ¾ÑÕÉ«£¬ÖÐ¶¾
function TActor.GetDrawEffectValue: TColorEffect;
var
  ceff: TColorEffect;
begin
  ceff := ceNone;

  //¼±ÅÃµÈ Ä³¸¯ ¹à°Ô.
  if (g_FocusCret = Self) or (g_MagicTarget = Self) then begin
    ceff := ceBright;
  end;

  //Áßµ¶
  if m_nState and $80000000 <> 0 then begin
    ceff := ceGreen;
  end;
  if m_nState and $40000000 <> 0 then begin
    ceff := ceRed;
  end;
  if m_nState and $20000000 <> 0 then begin
    ceff := ceBlue;
  end;
  if m_nState and $10000000 <> 0 then begin
    ceff := ceYellow;
  end;
  //¸¶ºñ·ù
  if m_nState and $08000000 <> 0 then begin
    ceff := ceFuchsia;
  end;
  if m_nState and $04000000 <> 0 then begin
    ceff := ceGrayScale;
  end;
  Result := ceff;
end;

procedure TActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend: Boolean; boFlag: Boolean);
var
  idx, ax, ay: Integer;
  d: TDirectDrawSurface;
  ceff: TColorEffect;
  wimg: TWMImages;
begin
  d := nil; //jacky
  if not (m_btDir in [0..7]) then Exit;
  if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface; //bodysurfaceµîÀÌ loadsurface¸¦ ´Ù½Ã ºÎ¸£Áö ¾Ê¾Æ ¸Þ¸ð¸®°¡ ÇÁ¸®µÇ´Â °ÍÀ» ¸·À½
  end;

  ceff := GetDrawEffectValue;

  if m_BodySurface <> nil then begin
    DrawEffSurface(dsurface,
      m_BodySurface,
      dx + m_nPx + m_nShiftX,
      dy + m_nPy + m_nShiftY,
      blend,
      ceff);
  end;

  if m_boUseMagic {and (EffDir[Dir] = 1)} and (m_CurMagic.EffectNumber > 0) then
    if m_nCurEffFrame in [0..m_nSpellFrame - 1] then begin
      GetEffectBase(m_CurMagic.EffectNumber - 1, 0, wimg, idx);
      idx := idx + m_nCurEffFrame;
      if wimg <> nil then
        d := wimg.GetCachedImage(idx, ax, ay);
      if d <> nil then
        DrawBlend(dsurface,
          dx + ax + m_nShiftX,
          dy + ay + m_nShiftY,
          d, 1);
    end;
end;

procedure TActor.DrawEff(dsurface: TDirectDrawSurface; dx, dy: Integer);
begin
end;


function TActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf, dr: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;

  if m_boDeath then begin
    if m_boSkeleton then
      Result := pm.ActDeath.start
    else Result := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip) + (pm.ActDie.frame - 1);
  end else begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
    else cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
  end;
end;

procedure TActor.DefaultMotion; //µ¿ÀÛ ¾øÀ½,  ±âº» ÀÚ¼¼..
begin
  m_boReverseFrame := FALSE;
  if m_boWarMode then begin
    if (GetTickCount - m_dwWarModeTime > 4 * 1000) then //and not BoNextTimeFireHit then
      m_boWarMode := FALSE;
  end;
  m_nCurrentFrame := GetDefaultFrame(m_boWarMode);
  Shift(m_btDir, 0, 1, 1);
end;

//ÈËÎï¶¯×÷ÉùÒô(½Å²½Éù¡¢ÎäÆ÷¹¥»÷Éù)
procedure TActor.SetSound;
var
  cx, cy, bidx, wunit, attackweapon: Integer;
  hiter: TActor;
begin
  if m_btRace = 0 then begin
    if (Self = g_MySelf) and
      ((m_nCurrentAction = SM_WALK) or
      (m_nCurrentAction = SM_BACKSTEP) or
      (m_nCurrentAction = SM_RUN) or
      (m_nCurrentAction = SM_HORSERUN) or
      (m_nCurrentAction = SM_RUSH) or
      (m_nCurrentAction = SM_RUSHKUNG)
      )
      then begin
      cx := g_MySelf.m_nCurrX - Map.m_nBlockLeft;
      cy := g_MySelf.m_nCurrY - Map.m_nBlockTop;
      cx := cx div 2 * 2;
      cy := cy div 2 * 2;
      bidx := Map.m_MArr[cx, cy].wBkImg and $7FFF;
      wunit := Map.m_MArr[cx, cy].btArea;
      bidx := wunit * 10000 + bidx - 1;
      case bidx of
        //ÂªÀº Ç®
        330..349, 450..454, 550..554, 750..754,
          950..954, 1250..1254, 1400..1424, 1455..1474,
          1500..1524, 1550..1574:
          m_nFootStepSound := s_walk_lawn_l;

        //Áß°£Ç®

        //±ä Ç®
        250..254, 1005..1009, 1050..1054, 1060..1064, 1450..1454,
          1650..1654:
          m_nFootStepSound := s_walk_rough_l;

        //µ¹ ±æ
        //´ë¸®¼® ¹Ù´Ú
        605..609, 650..654, 660..664, 2000..2049,
          3025..3049, 2400..2424, 4625..4649, 4675..4678:
          m_nFootStepSound := s_walk_stone_l;

        //µ¿±¼¾È
        1825..1924, 2150..2174, 3075..3099, 3325..3349,
          3375..3399:
          m_nFootStepSound := s_walk_cave_l;

        //³ª¹«¹Ù´Ú
        3230, 3231, 3246, 3277:
          m_nFootStepSound := s_walk_wood_l;

        //´øÀü..
        3780..3799:
          m_nFootStepSound := s_walk_wood_l;

        3825..4434:
          if (bidx - 3825) mod 25 = 0 then m_nFootStepSound := s_walk_wood_l
          else m_nFootStepSound := s_walk_ground_l;

        //Áý¾È(¼Ò¸® º°·ç ¾È³²)
        2075..2099, 2125..2149:
          m_nFootStepSound := s_walk_room_l;

        //°³¿ï
        1800..1824:
          m_nFootStepSound := s_walk_water_l;

        else
          m_nFootStepSound := s_walk_ground_l;
      end;
      //±ÃÀü³»ºÎ
      if (bidx >= 825) and (bidx <= 1349) then begin
        if ((bidx - 825) div 25) mod 2 = 0 then
          m_nFootStepSound := s_walk_stone_l;
      end;
      //µ¿±¼³»ºÎ
      if (bidx >= 1375) and (bidx <= 1799) then begin
        if ((bidx - 1375) div 25) mod 2 = 0 then
          m_nFootStepSound := s_walk_cave_l;
      end;
      case bidx of
        1385, 1386, 1391, 1392:
          m_nFootStepSound := s_walk_wood_l;
      end;

      bidx := Map.m_MArr[cx, cy].wMidImg and $7FFF;
      bidx := bidx - 1;
      case bidx of
        0..115:
          m_nFootStepSound := s_walk_ground_l;
        120..124:
          m_nFootStepSound := s_walk_lawn_l;
      end;

      bidx := Map.m_MArr[cx, cy].wFrImg and $7FFF;
      bidx := bidx - 1;
      case bidx of
        //º®µ¹±æ
        221..289, 583..658, 1183..1206, 7163..7295,
          7404..7414:
          m_nFootStepSound := s_walk_stone_l;
        //³ª¹«¸¶·ç
        3125..3267, {3319..3345, 3376..3433,} 3757..3948,
        6030..6999:
          m_nFootStepSound := s_walk_wood_l;
        //¹æ¹Ù´Ú
        3316..3589:
          m_nFootStepSound := s_walk_room_l;
      end;
      if (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
        m_nFootStepSound := m_nFootStepSound + 2;

    end;

    if m_btSex = 0 then begin //³²ÀÚ
      m_nScreamSound := s_man_struck;
      m_nDieSound := s_man_die;
    end else begin //¿©ÀÚ
      m_nScreamSound := s_wom_struck;
      m_nDieSound := s_wom_die;
    end;

    case m_nCurrentAction of
      SM_THROW, SM_HIT, SM_HIT + 1, SM_HIT + 2, SM_POWERHIT, SM_LONGHIT, SM_WIDEHIT, SM_FIREHIT, SM_CRSHIT, SM_TWINHIT: begin
          case (m_btWeapon div 2) of
            6, 20: m_nWeaponSound := s_hit_short;
            1: m_nWeaponSound := s_hit_wooden;
            2, 13, 9, 5, 14, 22: m_nWeaponSound := s_hit_sword;
            4, 17, 10, 15, 16, 23: m_nWeaponSound := s_hit_do;
            3, 7, 11: m_nWeaponSound := s_hit_axe;
            24: m_nWeaponSound := s_hit_club;
            8, 12, 18, 21: m_nWeaponSound := s_hit_long;
            else m_nWeaponSound := s_hit_fist;
          end;
        end;
      SM_STRUCK: begin
          if m_nMagicStruckSound >= 1 then begin //¸¶¹ýÀ¸·Î ¸ÂÀ½
            //strucksound := s_struck_magic;  //ÀÓ½Ã..
          end else begin
            hiter := PlayScene.FindActor(m_nHiterCode);
            attackweapon := 0;
            if hiter <> nil then begin //¶§¸°³ðÀÌ ¹«¾ùÀ¸·Î ¶§·È´ÂÁö °Ë»ç
              attackweapon := hiter.m_btWeapon div 2;
              if hiter.m_btRace = 0 then
                case (m_btDress div 2) of
                  3: //°©¿Ê
                    case attackweapon of
                      6: m_nStruckSound := s_struck_armor_sword;
                      1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17: m_nStruckSound := s_struck_armor_sword;
                      3, 7, 11: m_nStruckSound := s_struck_armor_axe;
                      8, 12, 18: m_nStruckSound := s_struck_armor_longstick;
                      else m_nStruckSound := s_struck_armor_fist;
                    end;
                  else //ÀÏ¹Ý
                    case attackweapon of
                      6: m_nStruckSound := s_struck_body_sword;
                      1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17: m_nStruckSound := s_struck_body_sword;
                      3, 7, 11: m_nStruckSound := s_struck_body_axe;
                      8, 12, 18: m_nStruckSound := s_struck_body_longstick;
                      else m_nStruckSound := s_struck_body_fist;
                    end;
                end;
            end;
          end;
        end;
    end;

    //¸¶¹ý ¼Ò¸®
    if m_boUseMagic and (m_CurMagic.MagicSerial > 0) then begin
      m_nMagicStartSound := 10000 + m_CurMagic.MagicSerial * 10;
      m_nMagicFireSound := 10000 + m_CurMagic.MagicSerial * 10 + 1;
      m_nMagicExplosionSound := 10000 + m_CurMagic.MagicSerial * 10 + 2;
    end;

  end else begin
    if m_nCurrentAction = SM_STRUCK then begin
      if m_nMagicStruckSound >= 1 then begin //¸¶¹ýÀ¸·Î ¸ÂÀ½
        //strucksound := s_struck_magic;  //ÀÓ½Ã..
      end else begin
        hiter := PlayScene.FindActor(m_nHiterCode);
        if hiter <> nil then begin //¶§¸°³ðÀÌ ¹«¾ùÀ¸·Î ¶§·È´ÂÁö °Ë»ç
          attackweapon := hiter.m_btWeapon div 2;
          case attackweapon of
            6: m_nStruckSound := s_struck_body_sword;
            1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17: m_nStruckSound := s_struck_body_sword;
            3, 11: m_nStruckSound := s_struck_body_axe;
            8, 12, 18: m_nStruckSound := s_struck_body_longstick;
            else m_nStruckSound := s_struck_body_fist;
          end;
        end;
      end;
    end;

    if m_btRace = 50 then begin
    end else begin
      m_nAppearSound := 200 + (m_wAppearance) * 10;
      m_nNormalSound := 200 + (m_wAppearance) * 10 + 1;
      m_nAttackSound := 200 + (m_wAppearance) * 10 + 2; //¿ì¿ö¾ï
      m_nWeaponSound := 200 + (m_wAppearance) * 10 + 3; //È×(¹«±âÈÖµÎ·ë)
      m_nScreamSound := 200 + (m_wAppearance) * 10 + 4;
      m_nDieSound := 200 + (m_wAppearance) * 10 + 5;
      m_nDie2Sound := 200 + (m_wAppearance) * 10 + 6;
    end;
  end;

  //Ä® ¸Â´Â ¼Ò¸®
  if m_nCurrentAction = SM_STRUCK then begin
    hiter := PlayScene.FindActor(m_nHiterCode);
    attackweapon := 0;
    if hiter <> nil then begin //¶§¸°³ðÀÌ ¹«¾ùÀ¸·Î ¶§·È´ÂÁö °Ë»ç
      attackweapon := hiter.m_btWeapon div 2;
      if hiter.m_btRace = 0 then
        case (attackweapon div 2) of
          6, 20: m_nStruckWeaponSound := s_struck_short;
          1: m_nStruckWeaponSound := s_struck_wooden;
          2, 13, 9, 5, 14, 22: m_nStruckWeaponSound := s_struck_sword;
          4, 17, 10, 15, 16, 23: m_nStruckWeaponSound := s_struck_do;
          3, 7, 11: m_nStruckWeaponSound := s_struck_axe;
          24: m_nStruckWeaponSound := s_struck_club;
          8, 12, 18, 21: m_nStruckWeaponSound := s_struck_wooden; //long;
          //else struckweaponsound := s_struck_fist;
        end;
    end;
  end;
end;

procedure TActor.RunSound;
begin
  m_boRunSound := TRUE;
  SetSound;
  case m_nCurrentAction of
    SM_STRUCK: begin
        if (m_nStruckWeaponSound >= 0) then PlaySound(m_nStruckWeaponSound);
        if (m_nStruckSound >= 0) then PlaySound(m_nStruckSound);
        if (m_nScreamSound >= 0) then PlaySound(m_nScreamSound);
      end;
    SM_NOWDEATH: begin
        if (m_nDieSound >= 0) then begin
          PlaySound(m_nDieSound);
          //              if Self.m_btRace = RC_USERHUMAN then
          if Self = g_MySelf then
            PlayBGM(bmg_gameover);
        end;
      end;
    SM_THROW, SM_HIT, SM_FLYAXE, SM_LIGHTING, SM_DIGDOWN {¹®´ÝÈû}: begin
        if m_nAttackSound >= 0 then PlaySound(m_nAttackSound);
      end;
    SM_ALIVE, SM_DIGUP {µîÀå,¹®¿­¸²}: begin
        PlaySound(m_nAppearSound);
      end;
    SM_SPELL: begin
        PlaySound(m_nMagicStartSound);
      end;
  end;
end;

procedure TActor.RunActSound(frame: Integer);
begin
  if m_boRunSound then begin
    if m_btRace = 0 then begin
      case m_nCurrentAction of
        SM_THROW, SM_HIT, SM_HIT + 1, SM_HIT + 2:
          if frame = 2 then begin
            PlaySound(m_nWeaponSound);
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
        SM_POWERHIT:
          if frame = 2 then begin
            PlaySound(m_nWeaponSound);
            if m_btSex = 0 then PlaySound(s_yedo_man)
            else PlaySound(s_yedo_woman);
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
        SM_LONGHIT:
          if frame = 2 then begin
            PlaySound(m_nWeaponSound);
            PlaySound(s_longhit);
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
        SM_WIDEHIT:
          if frame = 2 then begin
            PlaySound(m_nWeaponSound);
            PlaySound(s_widehit);
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
        SM_FIREHIT:
          if frame = 2 then begin
            PlaySound(m_nWeaponSound);
            PlaySound(s_firehit);
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
        SM_CRSHIT:
          if frame = 2 then begin
            PlaySound(m_nWeaponSound);
            PlaySound(s_firehit); //Damian
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
        SM_TWINHIT:
          if frame = 2 then begin
            PlaySound(m_nWeaponSound);
            PlaySound(s_firehit); //Damian
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
      end;
    end else begin
      if m_btRace = 50 then begin
      end else begin
        //(** »õ »ç¿îµå
        if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_TURN) then begin
          if (frame = 1) and (Random(8) = 1) then begin
            PlaySound(m_nNormalSound);
            m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
          end;
        end;
        if m_nCurrentAction = SM_HIT then begin
          if (frame = 3) and (m_nAttackSound >= 0) then begin
            PlaySound(m_nWeaponSound);
            m_boRunSound := FALSE;
          end;
        end;
        case m_wAppearance of
          80: {//°ü¹ÚÁã} begin
              if m_nCurrentAction = SM_NOWDEATH then begin
                if (frame = 2) then begin
                  PlaySound(m_nDie2Sound);
                  m_boRunSound := FALSE; //ÇÑ¹ø¸¸ ¼Ò¸®³¿
                end;
              end;
            end;
        end;
      end; //*)
    end;
  end;
end;

procedure TActor.RunFrameAction(frame: Integer);
begin
end;

procedure TActor.ActionEnded;
begin
end;

procedure TActor.Run;
  function MagicTimeOut: Boolean;
  begin
    if Self = g_MySelf then begin
      Result := GetTickCount - m_dwWaitMagicRequest > 3000;
    end else
      Result := GetTickCount - m_dwWaitMagicRequest > 2000;
    if Result then
      m_CurMagic.ServerMagicCode := 0;
  end;
var
  prv: Integer;
  m_dwFrameTimetime: LongWord;
  bofly: Boolean;
begin
  if (m_nCurrentAction = SM_WALK) or
    (m_nCurrentAction = SM_BACKSTEP) or
    (m_nCurrentAction = SM_RUN) or
    (m_nCurrentAction = SM_HORSERUN) or

  (m_nCurrentAction = SM_RUSH) or
    (m_nCurrentAction = SM_RUSHKUNG)
    then Exit;

  m_boMsgMuch := FALSE;
  if Self <> g_MySelf then begin
    if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;
  end;

  //»ç¿îµå È¿°ú
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if (Self <> g_MySelf) and (m_boUseMagic) then begin
      m_dwFrameTimetime := Round(m_dwFrameTime / 1.8);
    end else begin
      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;
    end;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
      if m_nCurrentFrame < m_nEndFrame then begin
        //¸¶¹ýÀÎ °æ¿ì ¼­¹öÀÇ ½ÅÈ£¸¦ ¹Þ¾Æ, ¼º°ø/½ÇÆÐ¸¦ È®ÀÎÇÑÈÄ
        //¸¶Áö¸·µ¿ÀÛÀ» ³¡³½´Ù.
        if m_boUseMagic then begin
          if (m_nCurEffFrame = m_nSpellFrame - 2) or (MagicTimeOut) then begin //±â´Ù¸² ³¡
            if (m_CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then begin //¼­¹ö·Î ºÎÅÍ ¹ÞÀº °á°ú. ¾ÆÁ÷ ¾È¿ÔÀ¸¸é ±â´Ù¸²
              Inc(m_nCurrentFrame);
              Inc(m_nCurEffFrame);
              m_dwStartTime := GetTickCount;
            end;
          end else begin
            if m_nCurrentFrame < m_nEndFrame - 1 then Inc(m_nCurrentFrame);
            Inc(m_nCurEffFrame);
            m_dwStartTime := GetTickCount;
          end;
        end else begin
          Inc(m_nCurrentFrame);
          m_dwStartTime := GetTickCount;
        end;

      end else begin
        if m_boDelActionAfterFinished then begin
          //ÀÌ µ¿ÀÛÈÄ »ç¶óÁü.
          m_boDelActor := TRUE;
        end;
        //µ¿ÀÛÀÌ ³¡³².
        if Self = g_MySelf then begin
          //ÁÖÀÎ°ø ÀÎ°æ¿ì
          if FrmMain.ServerAcceptNextAction then begin
            ActionEnded;
            m_nCurrentAction := 0;
            m_boUseMagic := FALSE;
          end;
        end else begin
          ActionEnded;
          m_nCurrentAction := 0; //µ¿ÀÛ ¿Ï·á
          m_boUseMagic := FALSE;
        end;
      end;
      if m_boUseMagic then begin
        //¸¶¹ýÀ» ¾²´Â °æ¿ì
        if m_nCurEffFrame = m_nSpellFrame - 1 then begin //¸¶¹ý ¹ß»ç ½ÃÁ¡
          //¸¶¹ý ¹ß»ç
          if m_CurMagic.ServerMagicCode > 0 then begin
            with m_CurMagic do
              PlayScene.NewMagic(Self,
                ServerMagicCode,
                EffectNumber, //Effect
                m_nCurrX,
                m_nCurrY,
                TargX,
                TargY,
                Target,
                EffectType, //EffectType
                Recusion,
                AniTime,
                bofly);
            if bofly then
              PlaySound(m_nMagicFireSound)
            else
              PlaySound(m_nMagicExplosionSound);
          end;
          //LatestSpellTime := GetTickCount;
          m_CurMagic.ServerMagicCode := 0;
        end;
      end;
    end;
    if m_wAppearance in [0, 1, 43] then m_nCurrentDefFrame := -10
    else m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
  end else begin
    if GetTickCount - m_dwSmoothMoveTime > 200 then begin
      if GetTickCount - m_dwDefFrameTime > 500 then begin
        m_dwDefFrameTime := GetTickCount;
        Inc(m_nCurrentDefFrame);
        if m_nCurrentDefFrame >= m_nDefFrameCount then
          m_nCurrentDefFrame := 0;
      end;
      DefaultMotion;
    end;
  end;
  if prv <> m_nCurrentFrame then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
end;

function TActor.Move(step: Integer): Boolean;
var
  prv, curstep, maxstep: Integer;
  fastmove, normmove: Boolean;
begin
  Result := FALSE;
  fastmove := FALSE;
  normmove := FALSE;
  if (m_nCurrentAction = SM_BACKSTEP) then //or (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG) then
    fastmove := TRUE;
  if (m_nCurrentAction = SM_RUSH) or (m_nCurrentAction = SM_RUSHKUNG) then
    normmove := TRUE;
  if (Self = g_MySelf) and (not fastmove) and (not normmove) then begin
    g_boMoveSlow := FALSE;
    g_boAttackSlow := FALSE;
    g_nMoveSlowLevel := 0;
    if m_Abil.Weight > m_Abil.MaxWeight then begin
      g_nMoveSlowLevel := m_Abil.Weight div m_Abil.MaxWeight;
      g_boMoveSlow := TRUE;
    end;
    if m_Abil.WearWeight > m_Abil.MaxWearWeight then begin
      g_nMoveSlowLevel := g_nMoveSlowLevel + m_Abil.WearWeight div m_Abil.MaxWearWeight;
      g_boMoveSlow := TRUE;
    end;
    if m_Abil.HandWeight > m_Abil.MaxHandWeight then begin
      g_boAttackSlow := TRUE;
    end;
    if g_boMoveSlow and (m_nSkipTick < g_nMoveSlowLevel) then begin
      Inc(m_nSkipTick); //ÇÑ¹ø ½®´Ù.
      Exit;
    end else begin
      m_nSkipTick := 0;
    end;
    //»ç¿îµå È¿°ú
    if (m_nCurrentAction = SM_WALK) or
      (m_nCurrentAction = SM_BACKSTEP) or
      (m_nCurrentAction = SM_RUN) or
      (m_nCurrentAction = SM_HORSERUN) or
      (m_nCurrentAction = SM_RUSH) or
      (m_nCurrentAction = SM_RUSHKUNG)
      then begin
      case (m_nCurrentFrame - m_nStartFrame) of
        1: PlaySound(m_nFootStepSound);
        4: PlaySound(m_nFootStepSound + 1);
      end;
    end;
  end;

  Result := FALSE;
  m_boMsgMuch := FALSE;
  if Self <> g_MySelf then begin
    if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;
  end;
  prv := m_nCurrentFrame;
  //°È±â ¶Ù±â
  if (m_nCurrentAction = SM_WALK) or
    (m_nCurrentAction = SM_RUN) or
    (m_nCurrentAction = SM_HORSERUN) or
    (m_nCurrentAction = SM_RUSH) or
    (m_nCurrentAction = SM_RUSHKUNG)
    then begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then begin
      m_nCurrentFrame := m_nStartFrame - 1;
    end;
    if m_nCurrentFrame < m_nEndFrame then begin
      Inc(m_nCurrentFrame);
      if m_boMsgMuch and not normmove then //or fastmove then
        if m_nCurrentFrame < m_nEndFrame then
          Inc(m_nCurrentFrame);

      //ºÎµå·´°Ô ÀÌµ¿ÇÏ°Ô ÇÏ·Á°í
      curstep := m_nCurrentFrame - m_nStartFrame + 1;
      maxstep := m_nEndFrame - m_nStartFrame + 1;
      Shift(m_btDir, m_nMoveStep, curstep, maxstep);
    end;
    if m_nCurrentFrame >= m_nEndFrame then begin
      if Self = g_MySelf then begin
        if FrmMain.ServerAcceptNextAction then begin
          m_nCurrentAction := 0; //¼­¹öÀÇ ½ÅÈ£¸¦ ¹ÞÀ¸¸é ´ÙÀ½ µ¿ÀÛ
          m_boLockEndFrame := TRUE; //¼­¹öÀÇ½ÅÈ£°¡ ¾ø¾î¼­ ¸¶Áö¸·ÇÁ·¡ÀÓ¿¡¼­ ¸ØÃã
          m_dwSmoothMoveTime := GetTickCount;
        end;
      end else begin
        m_nCurrentAction := 0; //µ¿ÀÛ ¿Ï·á
        m_boLockEndFrame := TRUE;
        m_dwSmoothMoveTime := GetTickCount;
      end;
      Result := TRUE;
    end;
    if m_nCurrentAction = SM_RUSH then begin
      if Self = g_MySelf then begin
        g_dwDizzyDelayStart := GetTickCount;
        g_dwDizzyDelayTime := 300; //µô·¹ÀÌ
      end;
    end;
    if m_nCurrentAction = SM_RUSHKUNG then begin
      if m_nCurrentFrame >= m_nEndFrame - 3 then begin
        m_nCurrX := m_nActBeforeX;
        m_nCurrY := m_nActBeforeY;
        m_nRx := m_nCurrX;
        m_nRy := m_nCurrY;
        m_nCurrentAction := 0;
        m_boLockEndFrame := TRUE;
        //m_dwSmoothMoveTime := GetTickCount;
      end;
    end;
    Result := TRUE;
  end;
  //µÞ°ÉÀ½Áú
  if (m_nCurrentAction = SM_BACKSTEP) then begin
    if (m_nCurrentFrame > m_nEndFrame) or (m_nCurrentFrame < m_nStartFrame) then begin
      m_nCurrentFrame := m_nEndFrame + 1;
    end;
    if m_nCurrentFrame > m_nStartFrame then begin
      Dec(m_nCurrentFrame);
      if m_boMsgMuch or fastmove then
        if m_nCurrentFrame > m_nStartFrame then Dec(m_nCurrentFrame);

      //ºÎµå·´°Ô ÀÌµ¿ÇÏ°Ô ÇÏ·Á°í
      curstep := m_nEndFrame - m_nCurrentFrame + 1;
      maxstep := m_nEndFrame - m_nStartFrame + 1;
      Shift(GetBack(m_btDir), m_nMoveStep, curstep, maxstep);
    end;
    if m_nCurrentFrame <= m_nStartFrame then begin
      if Self = g_MySelf then begin
        //if FrmMain.ServerAcceptNextAction then begin
        m_nCurrentAction := 0; //¼­¹öÀÇ ½ÅÈ£¸¦ ¹ÞÀ¸¸é ´ÙÀ½ µ¿ÀÛ
        m_boLockEndFrame := TRUE; //¼­¹öÀÇ½ÅÈ£°¡ ¾ø¾î¼­ ¸¶Áö¸·ÇÁ·¡ÀÓ¿¡¼­ ¸ØÃã
        m_dwSmoothMoveTime := GetTickCount;

        //µÚ·Î ¹Ð¸° ´ÙÀ½ ÇÑµ¿¾È ¸ø ¿òÁ÷ÀÎ´Ù.
        g_dwDizzyDelayStart := GetTickCount;
        g_dwDizzyDelayTime := 1000; //1ÃÊ µô·¹ÀÌ
        //end;
      end else begin
        m_nCurrentAction := 0; //µ¿ÀÛ ¿Ï·á
        m_boLockEndFrame := TRUE;
        m_dwSmoothMoveTime := GetTickCount;
      end;
      Result := TRUE;
    end;
    Result := TRUE;
  end;
  if prv <> m_nCurrentFrame then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TActor.MoveFail;
begin
  m_nCurrentAction := 0; //µ¿ÀÛ ¿Ï·á
  m_boLockEndFrame := TRUE;
  g_MySelf.m_nCurrX := m_nOldx;
  g_MySelf.m_nCurrY := m_nOldy;
  g_MySelf.m_btDir := m_nOldDir;
  CleanUserMsgs;
end;

function TActor.CanCancelAction: Boolean;
begin
  Result := FALSE;
  if m_nCurrentAction = SM_HIT then
    if not m_boUseEffect then
      Result := TRUE;
end;

procedure TActor.CancelAction;
begin
  m_nCurrentAction := 0; //µ¿ÀÛ ¿Ï·á
  m_boLockEndFrame := TRUE;
end;

procedure TActor.CleanCharMapSetting(x, y: Integer);
begin
  g_MySelf.m_nCurrX := x;
  g_MySelf.m_nCurrY := y;
  g_MySelf.m_nRx := x;
  g_MySelf.m_nRy := y;
  m_nOldx := x;
  m_nOldy := y;
  m_nCurrentAction := 0;
  m_nCurrentFrame := -1;
  CleanUserMsgs;
end;

procedure TActor.Say(str: string);
var
  I, len, aline, n: Integer;
  dline, temp: string;
  loop: Boolean;
const
  MAXWIDTH = 150;
begin
  m_dwSayTime := GetTickCount;
  m_nSayLineCount := 0;
  n := 0;
  loop := TRUE;
  while loop do begin
    temp := '';
    I := 1;
    len := Length(str);
    while TRUE do begin
      if I > len then begin
        loop := FALSE;
        break;
      end;
      if byte(str[I]) >= 128 then begin
        temp := temp + str[I];
        Inc(I);
        if I <= len then temp := temp + str[I]
        else begin
          loop := FALSE;
          break;
        end;
      end else
        temp := temp + str[I];
      aline := FrmMain.Canvas.TextWidth(temp);
      if aline > MAXWIDTH then begin
        m_SayingArr[n] := temp;
        m_SayWidthsArr[n] := aline;
        Inc(m_nSayLineCount);
        Inc(n);
        if n >= MAXSAY then begin
          loop := FALSE;
          break;
        end;
        str := Copy(str, I + 1, len - I);
        temp := '';
        break;
      end;
      Inc(I);
    end;
    if temp <> '' then begin
      if n < MAXWIDTH then begin
        m_SayingArr[n] := temp;
        m_SayWidthsArr[n] := FrmMain.Canvas.TextWidth(temp);
        Inc(m_nSayLineCount);
      end;
    end;
  end;
end;

{============================== NPCActor =============================}
procedure TNpcActor.CalcActorFrame;
var
  pm: pTMonsterAction;
  haircount: Integer;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetNpcOffset(m_wAppearance);
  {
  if m_btRace = 50 then //NPC
     m_nBodyOffset := MERCHANTFRAME * m_wAppearance;
  }
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_btDir := m_btDir mod 3; //¹æÇâÀº 0, 1, 2 ¹Û¿¡ ¾øÀ½..
  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
        m_dwFrameTime := pm.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := pm.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
        if ((m_wAppearance = 33) or (m_wAppearance = 34)) and not m_boUseEffect then begin
          m_boUseEffect := TRUE;
          m_nEffectFrame := m_nEffectStart;
          m_nEffectEnd := m_nEffectStart + 9;
          m_dwEffectStartTime := GetTickCount();
          m_dwEffectFrameTime := 300;
        end else begin
          if m_wAppearance in [42..47] then begin
            m_nStartFrame := 20;
            m_nEndFrame := 10;
            m_boUseEffect := TRUE;
            m_nEffectStart := 0;
            m_nEffectFrame := 0;
            m_nEffectEnd := 19;
            m_dwEffectStartTime := GetTickCount();
            m_dwEffectFrameTime := 100;
          end else begin
            if m_wAppearance = 51 then begin
              m_boUseEffect := TRUE;
              m_nEffectStart := 60;
              m_nEffectFrame := m_nEffectStart;
              m_nEffectEnd := m_nEffectStart + 7;
              m_dwEffectStartTime := GetTickCount();
              m_dwEffectFrameTime := 500;
            end;
          end;
        end;
      end;
    SM_HIT: begin
        case m_wAppearance of
          33, 34, 52: begin
              m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
              m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
              m_dwStartTime := GetTickCount;
              m_nDefFrameCount := pm.ActStand.frame;
            end;
          else begin
              m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
              m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
              m_dwFrameTime := pm.ActAttack.ftime;
              m_dwStartTime := GetTickCount;
              if m_wAppearance = 51 then begin
                m_boUseEffect := TRUE;
                m_nEffectStart := 60;
                m_nEffectFrame := m_nEffectStart;
                m_nEffectEnd := m_nEffectStart + 7;
                m_dwEffectStartTime := GetTickCount();
                m_dwEffectFrameTime := 500;
              end;
            end;
        end;
      end;
    SM_DIGUP: begin
        if m_wAppearance = 52 then begin
          m_bo248 := TRUE;
          m_dwUseEffectTick := GetTickCount + 23000;
          Randomize;
          PlaySound(Random(7) + 146);
          m_boUseEffect := TRUE;
          m_nEffectStart := 60;
          m_nEffectFrame := m_nEffectStart;
          m_nEffectEnd := m_nEffectStart + 11;
          m_dwEffectStartTime := GetTickCount();
          m_dwEffectFrameTime := 100;
        end;
      end;
  end;
end;

constructor TNpcActor.Create;
begin
  inherited;
  m_EffSurface := nil;
  m_boHitEffect := FALSE;
  m_bo248 := FALSE;
end;

procedure TNpcActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer;
  blend, boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  m_btDir := m_btDir mod 3;
  if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  ceff := GetDrawEffectValue;
  if m_BodySurface <> nil then begin
    if m_wAppearance = 51 then begin
      DrawEffSurface(dsurface,
        m_BodySurface,
        dx + m_nPx + m_nShiftX,
        dy + m_nPy + m_nShiftY,
        TRUE,
        ceff);
    end else begin
      DrawEffSurface(dsurface,
        m_BodySurface,
        dx + m_nPx + m_nShiftX,
        dy + m_nPy + m_nShiftY,
        blend,
        ceff);
    end;
  end;
end;

procedure TNpcActor.DrawEff(dsurface: TDirectDrawSurface; dx, dy: Integer);
begin
  //  inherited;
  if m_boUseEffect and (m_EffSurface <> nil) then begin
    DrawBlend(dsurface,
      dx + m_nEffX + m_nShiftX,
      dy + m_nEffY + m_nShiftY,
      m_EffSurface,
      1);
  end;
end;

function TNpcActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf, dr: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_btDir := m_btDir mod 3; //¹æÇâÀº 0, 1, 2 ¹Û¿¡ ¾øÀ½..

  if m_nCurrentDefFrame < 0 then cf := 0
  else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
  else cf := m_nCurrentDefFrame;
  Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
end;

procedure TNpcActor.LoadSurface;
var
  WMImage: TWMImages;
begin
  {
    case m_btRace of
      50: begin //Npc
        m_BodySurface:=FrmMain.WNpcImg.GetCachedImage (m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
        if m_nBodyOffset >= 1000 then begin
          if FrmMain.GetNpcImg(m_wAppearance,WMImage) then begin
            m_BodySurface:=WMImage.GetCachedImage (m_nCurrentFrame, m_nPx, m_nPy);
          end;
        end;
      end;
    end;
  }
  if m_btRace = 50 then begin
    m_BodySurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
  end;
  if m_wAppearance in [42..47] then
    m_BodySurface := nil;
  if m_boUseEffect then begin
    if m_wAppearance in [33..34] then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end else if m_wAppearance = 42 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX := m_nEffX + 71;
      m_nEffY := m_nEffY + 5;
    end else if m_wAppearance = 43 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX := m_nEffX + 71;
      m_nEffY := m_nEffY + 37;
    end else if m_wAppearance = 44 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX := m_nEffX + 7;
      m_nEffY := m_nEffY + 12;
    end else if m_wAppearance = 45 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX := m_nEffX + 6;
      m_nEffY := m_nEffY + 12;
    end else if m_wAppearance = 46 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX := m_nEffX + 7;
      m_nEffY := m_nEffY + 12;
    end else if m_wAppearance = 47 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
      m_nEffX := m_nEffX + 8;
      m_nEffY := m_nEffY + 12;
    end else if m_wAppearance = 51 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end else if m_wAppearance = 52 then begin
      m_EffSurface := g_WNpcImgImages.GetCachedImage(m_nBodyOffset + m_nEffectFrame, m_nEffX, m_nEffY);
    end;
  end;
end;


procedure TNpcActor.Run;
var
  nEffectFrame: Integer;
  dwEffectFrameTime: LongWord;
begin
  inherited Run;
  nEffectFrame := m_nEffectFrame;
  if m_boUseEffect then begin
    if m_boUseMagic then begin
      dwEffectFrameTime := Round(m_dwEffectFrameTime / 3);
    end else dwEffectFrameTime := m_dwEffectFrameTime;

    if GetTickCount - m_dwEffectStartTime > dwEffectFrameTime then begin
      m_dwEffectStartTime := GetTickCount();
      if m_nEffectFrame < m_nEffectEnd then begin
        Inc(m_nEffectFrame);
      end else begin
        if m_bo248 then begin
          if GetTickCount > m_dwUseEffectTick then begin
            m_boUseEffect := FALSE;
            m_bo248 := FALSE;
            m_dwUseEffectTick := GetTickCount();
          end;
          m_nEffectFrame := m_nEffectStart;
        end else m_nEffectFrame := m_nEffectStart;
        m_dwEffectStartTime := GetTickCount();
      end;
    end;
  end;
  if nEffectFrame <> m_nEffectFrame then begin
    m_dwLoadSurfaceTime := GetTickCount();
    LoadSurface();
  end;
end;


{============================== HUMActor =============================}

//            »ç¶÷

{-------------------------------}


constructor THumActor.Create;
begin
  inherited Create;
  m_HairSurface := nil;
  m_WeaponSurface := nil;
  m_HumWinSurface := nil;
  m_boWeaponEffect := FALSE;
  m_dwFrameTime := 150;
  m_dwFrameTick := GetTickCount();
  m_nFrame := 0;
  m_nHumWinOffset := 0;
end;

destructor THumActor.Destroy;
begin
  inherited Destroy;
end;

procedure THumActor.CalcActorFrame;
var
  haircount: Integer;
begin
  m_boUseMagic := FALSE;
  m_boHitEffect := FALSE;
  m_nCurrentFrame := -1;
  //human
  m_btHair := HAIRfeature(m_nFeature); //º¯°æµÈ´Ù.
  m_btDress := DRESSfeature(m_nFeature);
  m_btWeapon := WEAPONfeature(m_nFeature);
  m_btHorse := Horsefeature(m_nFeatureEx);
  m_btEffect := Effectfeature(m_nFeatureEx);
  m_nBodyOffset := HUMANFRAME * (m_btDress); //m_btSex; //³²ÀÚ0, ¿©ÀÚ1

  haircount := g_WHairImgImages.ImageCount div HUMANFRAME div 2;
  if m_btHair > haircount - 1 then m_btHair := haircount - 1;
  m_btHair := m_btHair * 2;
  if m_btHair > 1 then
    m_nHairOffset := HUMANFRAME * (m_btHair + m_btSex)
  else m_nHairOffset := -1;
  m_nWeaponOffset := HUMANFRAME * m_btWeapon; //(weapon*2 + m_btSex);
  //   if Dress in [1..4] then begin
  //   if Dress in [18..21] then begin
  //     HumWinOffset:=(Dress - 18)* HUMANFRAME;
  //   end;
  if (m_btEffect = 50) then begin
    m_nHumWinOffset := 352;
  end else
    if m_btEffect <> 0 then
    m_nHumWinOffset := (m_btEffect - 1) * HUMANFRAME;
  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := HA.ActStand.start + m_btDir * (HA.ActStand.frame + HA.ActStand.skip);
        m_nEndFrame := m_nStartFrame + HA.ActStand.frame - 1;
        m_dwFrameTime := HA.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := HA.ActStand.frame;
        Shift(m_btDir, 0, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_WALK,
      SM_BACKSTEP: begin
        m_nStartFrame := HA.ActWalk.start + m_btDir * (HA.ActWalk.frame + HA.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + HA.ActWalk.frame - 1;
        m_dwFrameTime := HA.ActWalk.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := HA.ActWalk.usetick;
        m_nCurTick := 0;
        //WarMode := FALSE;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_BACKSTEP then
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_RUSH: begin
        if m_nRushDir = 0 then begin
          m_nRushDir := 1;
          m_nStartFrame := HA.ActRushLeft.start + m_btDir * (HA.ActRushLeft.frame + HA.ActRushLeft.skip);
          m_nEndFrame := m_nStartFrame + HA.ActRushLeft.frame - 1;
          m_dwFrameTime := HA.ActRushLeft.ftime;
          m_dwStartTime := GetTickCount;
          m_nMaxTick := HA.ActRushLeft.usetick;
          m_nCurTick := 0;
          m_nMoveStep := 1;
          Shift(m_btDir, 1, 0, m_nEndFrame - m_nStartFrame + 1);
        end else begin
          m_nRushDir := 0;
          m_nStartFrame := HA.ActRushRight.start + m_btDir * (HA.ActRushRight.frame + HA.ActRushRight.skip);
          m_nEndFrame := m_nStartFrame + HA.ActRushRight.frame - 1;
          m_dwFrameTime := HA.ActRushRight.ftime;
          m_dwStartTime := GetTickCount;
          m_nMaxTick := HA.ActRushRight.usetick;
          m_nCurTick := 0;
          m_nMoveStep := 1;
          Shift(m_btDir, 1, 0, m_nEndFrame - m_nStartFrame + 1);
        end;
      end;
    SM_RUSHKUNG: begin
        m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
        m_dwFrameTime := HA.ActRun.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := HA.ActRun.usetick;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    {SM_BACKSTEP:
       begin
          startframe := pm.ActWalk.start + (pm.ActWalk.frame - 1) + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
          m_nEndFrame := startframe - (pm.ActWalk.frame - 1);
          m_dwFrameTime := pm.ActWalk.ftime;
          m_dwStartTime := GetTickCount;
          m_nMaxTick := pm.ActWalk.UseTick;
          m_nCurTick := 0;
          m_nMoveStep := 1;
          Shift (GetBack(Dir), m_nMoveStep, 0, m_nEndFrame-startframe+1);
       end;  }
    SM_SITDOWN: begin
        m_nStartFrame := HA.ActSitdown.start + m_btDir * (HA.ActSitdown.frame + HA.ActSitdown.skip);
        m_nEndFrame := m_nStartFrame + HA.ActSitdown.frame - 1;
        m_dwFrameTime := HA.ActSitdown.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_RUN: begin
        m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
        m_dwFrameTime := HA.ActRun.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := HA.ActRun.usetick;
        m_nCurTick := 0;
        //WarMode := FALSE;
        if m_nCurrentAction = SM_RUN then m_nMoveStep := 2
        else m_nMoveStep := 1;

        //m_nMoveStep := 2;
        Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_HORSERUN: begin
        m_nStartFrame := HA.ActRun.start + m_btDir * (HA.ActRun.frame + HA.ActRun.skip);
        m_nEndFrame := m_nStartFrame + HA.ActRun.frame - 1;
        m_dwFrameTime := HA.ActRun.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := HA.ActRun.usetick;
        m_nCurTick := 0;
        //WarMode := FALSE;
        if m_nCurrentAction = SM_HORSERUN then m_nMoveStep := 3
        else m_nMoveStep := 1;

        //m_nMoveStep := 2;
        Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_THROW: begin
        m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
        m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
        m_dwFrameTime := HA.ActHit.ftime;
        m_dwStartTime := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        m_boThrow := TRUE;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HIT, SM_POWERHIT, SM_LONGHIT, SM_WIDEHIT, SM_FIREHIT, SM_CRSHIT, SM_TWINHIT: begin
        m_nStartFrame := HA.ActHit.start + m_btDir * (HA.ActHit.frame + HA.ActHit.skip);
        m_nEndFrame := m_nStartFrame + HA.ActHit.frame - 1;
        m_dwFrameTime := HA.ActHit.ftime;
        m_dwStartTime := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        if (m_nCurrentAction = SM_POWERHIT) then begin
          m_boHitEffect := TRUE;
          m_nMagLight := 2;
          m_nHitEffectNumber := 1;
        end;
        if (m_nCurrentAction = SM_LONGHIT) then begin
          m_boHitEffect := TRUE;
          m_nMagLight := 2;
          m_nHitEffectNumber := 2;
        end;
        if (m_nCurrentAction = SM_WIDEHIT) then begin
          m_boHitEffect := TRUE;
          m_nMagLight := 2;
          m_nHitEffectNumber := 3;
        end;
        if (m_nCurrentAction = SM_FIREHIT) then begin
          m_boHitEffect := TRUE;
          m_nMagLight := 2;
          m_nHitEffectNumber := 4;
        end;
        if (m_nCurrentAction = SM_CRSHIT) then begin
          m_boHitEffect := TRUE;
          m_nMagLight := 2;
          m_nHitEffectNumber := 6;
        end;
        if (m_nCurrentAction = SM_TWINHIT) then begin
          m_boHitEffect := TRUE;
          m_nMagLight := 2;
          m_nHitEffectNumber := 7;
        end;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HEAVYHIT: begin
        m_nStartFrame := HA.ActHeavyHit.start + m_btDir * (HA.ActHeavyHit.frame + HA.ActHeavyHit.skip);
        m_nEndFrame := m_nStartFrame + HA.ActHeavyHit.frame - 1;
        m_dwFrameTime := HA.ActHeavyHit.ftime;
        m_dwStartTime := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_BIGHIT: begin
        m_nStartFrame := HA.ActBigHit.start + m_btDir * (HA.ActBigHit.frame + HA.ActBigHit.skip);
        m_nEndFrame := m_nStartFrame + HA.ActBigHit.frame - 1;
        m_dwFrameTime := HA.ActBigHit.ftime;
        m_dwStartTime := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_SPELL: begin
        m_nStartFrame := HA.ActSpell.start + m_btDir * (HA.ActSpell.frame + HA.ActSpell.skip);
        m_nEndFrame := m_nStartFrame + HA.ActSpell.frame - 1;
        m_dwFrameTime := HA.ActSpell.ftime;
        m_dwStartTime := GetTickCount;
        m_nCurEffFrame := 0;
        m_boUseMagic := TRUE;
        case m_CurMagic.EffectNumber of
          22: begin //?»ðÇ½ µØÓüÀ×¹â
              m_nMagLight := 4; //·Ú¼³È­
              m_nSpellFrame := 10; //·Ú¼³È­´Â 10 ÇÁ·¡ÀÓÀ¸·Î º¯°æ
            end;
          26: begin //ÐÄÁéÆôÊ¾
              m_nMagLight := 2;
              m_nSpellFrame := 20;
              m_dwFrameTime := m_dwFrameTime div 2;
            end;
          35: begin //
              m_nMagLight := 2;
              m_nSpellFrame := 15;
            end;
          43: begin //Ê¨×Óºð
              m_nMagLight := 2;
              m_nSpellFrame := 20;
            end;
          else begin //.....  ´ëÈ¸º¹¼ú, »çÀÚÀ±È¸, ºù¼³Ç³
              m_nMagLight := 2;
              m_nSpellFrame := DEFSPELLFRAME;
            end;
        end;
        m_dwWaitMagicRequest := GetTickCount;
        m_boWarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    (*SM_READYFIREHIT:
       begin
          startframe := HA.ActFireHitReady.start + Dir * (HA.ActFireHitReady.frame + HA.ActFireHitReady.skip);
          m_nEndFrame := startframe + HA.ActFireHitReady.frame - 1;
          m_dwFrameTime := HA.ActFireHitReady.ftime;
          m_dwStartTime := GetTickCount;

          BoHitEffect := TRUE;
          HitEffectNumber := 4;
          MagLight := 2;

          CurGlimmer := 0;
          MaxGlimmer := 6;

          WarMode := TRUE;
          WarModeTime := GetTickCount;
          Shift (Dir, 0, 0, 1);
       end; *)
    SM_STRUCK: begin
        m_nStartFrame := HA.ActStruck.start + m_btDir * (HA.ActStruck.frame + HA.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + HA.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; //HA.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        m_dwGenAnicountTime := GetTickCount;
        m_nCurBubbleStruck := 0;
      end;
    SM_NOWDEATH: begin
        m_nStartFrame := HA.ActDie.start + m_btDir * (HA.ActDie.frame + HA.ActDie.skip);
        m_nEndFrame := m_nStartFrame + HA.ActDie.frame - 1;
        m_dwFrameTime := HA.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

procedure THumActor.DefaultMotion;
begin
  inherited DefaultMotion;
  if (m_btEffect = 50) then begin
    if (m_nCurrentFrame <= 536) then begin
      if (GetTickCount - m_dwFrameTick) > 100 then begin
        if m_nFrame < 19 then Inc(m_nFrame)
        else begin
          if not m_bo2D0 then m_bo2D0 := TRUE
          else m_bo2D0 := FALSE;
          m_nFrame := 0;
        end;
        m_dwFrameTick := GetTickCount();
      end;
      m_HumWinSurface := FrmMain.WEffectImg.GetCachedImage(m_nHumWinOffset + m_nFrame, m_nSpx, m_nSpy);
    end;
  end else
    if (m_btEffect <> 0) then begin
    if m_nCurrentFrame < 64 then begin
      if (GetTickCount - m_dwFrameTick) > m_dwFrameTime then begin
        if m_nFrame < 7 then Inc(m_nFrame)
        else m_nFrame := 0;
        m_dwFrameTick := GetTickCount();
      end;
      m_HumWinSurface := g_WHumWingImages.GetCachedImage(m_nHumWinOffset + (m_btDir * 8) + m_nFrame, m_nSpx, m_nSpy);
    end else begin
      m_HumWinSurface := g_WHumWingImages.GetCachedImage(m_nHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy);
    end;
  end;
end;

function THumActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf, dr: Integer;
  pm: pTMonsterAction;
begin
  //GlimmingMode := FALSE;
  //dr := Dress div 2;            //HUMANFRAME * (dr)
  if m_boDeath then
    Result := HA.ActDie.start + m_btDir * (HA.ActDie.frame + HA.ActDie.skip) + (HA.ActDie.frame - 1)
  else
    if wmode then begin
    //GlimmingMode := TRUE;
    Result := HA.ActWarMode.start + m_btDir * (HA.ActWarMode.frame + HA.ActWarMode.skip);
  end else begin
    m_nDefFrameCount := HA.ActStand.frame;
    if m_nCurrentDefFrame < 0 then cf := 0
    else if m_nCurrentDefFrame >= HA.ActStand.frame then cf := 0 //HA.ActStand.frame-1
    else cf := m_nCurrentDefFrame;
    Result := HA.ActStand.start + m_btDir * (HA.ActStand.frame + HA.ActStand.skip) + cf;
  end;
end;

procedure THumActor.RunFrameAction(frame: Integer);
var
  Meff: TMapEffect;
  event: TClEvent;
  mfly: TFlyingAxe;
begin
  m_boHideWeapon := FALSE;
  if m_nCurrentAction = SM_HEAVYHIT then begin
    if (frame = 5) and (m_boDigFragment) then begin
      m_boDigFragment := FALSE;
      Meff := TMapEffect.Create(8 * m_btDir, 3, m_nCurrX, m_nCurrY);
      Meff.ImgLib := FrmMain.WEffectImg;
      Meff.NextFrameTime := 80;
      PlaySound(s_strike_stone);
      //PlaySound (s_drop_stonepiece);
      PlayScene.m_EffectList.Add(Meff);
      event := EventMan.GetEvent(m_nCurrX, m_nCurrY, ET_PILESTONES);
      if event <> nil then
        event.m_nEventParam := event.m_nEventParam + 1;
    end;
  end;
  if m_nCurrentAction = SM_THROW then begin
    if (frame = 3) and (m_boThrow) then begin
      m_boThrow := FALSE;
      mfly := TFlyingAxe(PlayScene.NewFlyObject(Self,
        m_nCurrX,
        m_nCurrY,
        m_nTargetX,
        m_nTargetY,
        m_nTargetRecog,
        mtFlyAxe));
      if mfly <> nil then begin
        TFlyingAxe(mfly).ReadyFrame := 40;
        mfly.ImgLib := FrmMain.WMon3Img;
        mfly.FlyImageBase := FLYOMAAXEBASE;
      end;
    end;
    if frame >= 3 then
      m_boHideWeapon := TRUE;
  end;
end;

procedure THumActor.DoWeaponBreakEffect;
begin
  m_boWeaponEffect := TRUE;
  m_nCurWeaponEffect := 0;
end;

procedure THumActor.Run;
  function MagicTimeOut: Boolean;
  begin
    if Self = g_MySelf then begin
      Result := GetTickCount - m_dwWaitMagicRequest > 3000;
    end else
      Result := GetTickCount - m_dwWaitMagicRequest > 2000;
    if Result then
      m_CurMagic.ServerMagicCode := 0;
  end;
var
  prv: Integer;
  m_dwFrameTimetime: LongWord;
  bofly: Boolean;
begin
  if GetTickCount - m_dwGenAnicountTime > 120 then begin //ÁÖ¼úÀÇ¸· µî... ¾Ö´Ï¸ÞÀÌ¼Ç È¿°ú
    m_dwGenAnicountTime := GetTickCount;
    Inc(m_nGenAniCount);
    if m_nGenAniCount > 100000 then m_nGenAniCount := 0;
    Inc(m_nCurBubbleStruck);
  end;
  if m_boWeaponEffect then begin //¹«±â Çâ»ó/ºÎ¼­Áü È¿°ú
    if GetTickCount - m_dwWeaponpEffectTime > 120 then begin
      m_dwWeaponpEffectTime := GetTickCount;
      Inc(m_nCurWeaponEffect);
      if m_nCurWeaponEffect >= MAXWPEFFECTFRAME then
        m_boWeaponEffect := FALSE;
    end;
  end;

  if (m_nCurrentAction = SM_WALK) or
    (m_nCurrentAction = SM_BACKSTEP) or
    (m_nCurrentAction = SM_RUN) or
    (m_nCurrentAction = SM_HORSERUN) or
    (m_nCurrentAction = SM_RUSH) or
    (m_nCurrentAction = SM_RUSHKUNG)
    then Exit;

  m_boMsgMuch := FALSE;
  if Self <> g_MySelf then begin
    if m_MsgList.Count >= 2 then m_boMsgMuch := TRUE;
  end;

  //»ç¿îµå È¿°ú
  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if (Self <> g_MySelf) and (m_boUseMagic) then begin
      m_dwFrameTimetime := Round(m_dwFrameTime / 1.8);
    end else begin
      if m_boMsgMuch then m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
      else m_dwFrameTimetime := m_dwFrameTime;
    end;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
      if m_nCurrentFrame < m_nEndFrame then begin

        //¸¶¹ýÀÎ °æ¿ì ¼­¹öÀÇ ½ÅÈ£¸¦ ¹Þ¾Æ, ¼º°ø/½ÇÆÐ¸¦ È®ÀÎÇÑÈÄ
        //¸¶Áö¸·µ¿ÀÛÀ» ³¡³½´Ù.
        if m_boUseMagic then begin
          if (m_nCurEffFrame = m_nSpellFrame - 2) or (MagicTimeOut) then begin //±â´Ù¸² ³¡
            if (m_CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then begin //¼­¹ö·Î ºÎÅÍ ¹ÞÀº °á°ú. ¾ÆÁ÷ ¾È¿ÔÀ¸¸é ±â´Ù¸²
              Inc(m_nCurrentFrame);
              Inc(m_nCurEffFrame);
              m_dwStartTime := GetTickCount;
            end;
          end else begin
            if m_nCurrentFrame < m_nEndFrame - 1 then Inc(m_nCurrentFrame);
            Inc(m_nCurEffFrame);
            m_dwStartTime := GetTickCount;
          end;
        end else begin
          Inc(m_nCurrentFrame);
          m_dwStartTime := GetTickCount;
        end;

      end else begin
        if Self = g_MySelf then begin
          if FrmMain.ServerAcceptNextAction then begin
            m_nCurrentAction := 0;
            m_boUseMagic := FALSE;
          end;
        end else begin
          m_nCurrentAction := 0; //µ¿ÀÛ ¿Ï·á
          m_boUseMagic := FALSE;
        end;
        m_boHitEffect := FALSE;
      end;
      if m_boUseMagic then begin
        if m_nCurEffFrame = m_nSpellFrame - 1 then begin //¸¶¹ý ¹ß»ç ½ÃÁ¡
          //¸¶¹ý ¹ß»ç
          if m_CurMagic.ServerMagicCode > 0 then begin
            with m_CurMagic do
              PlayScene.NewMagic(Self,
                ServerMagicCode,
                EffectNumber,
                m_nCurrX,
                m_nCurrY,
                TargX,
                TargY,
                Target,
                EffectType,
                Recusion,
                AniTime,
                bofly);
            if bofly then
              PlaySound(m_nMagicFireSound)
            else
              PlaySound(m_nMagicExplosionSound);
          end;
          if Self = g_MySelf then
            g_dwLatestSpellTick := GetTickCount;
          m_CurMagic.ServerMagicCode := 0;
        end;
      end;

    end;
    if m_btRace = 0 then m_nCurrentDefFrame := 0
    else m_nCurrentDefFrame := -10;
    m_dwDefFrameTime := GetTickCount;
  end else begin
    if GetTickCount - m_dwSmoothMoveTime > 200 then begin
      if GetTickCount - m_dwDefFrameTime > 500 then begin
        m_dwDefFrameTime := GetTickCount;
        Inc(m_nCurrentDefFrame);
        if m_nCurrentDefFrame >= m_nDefFrameCount then
          m_nCurrentDefFrame := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> m_nCurrentFrame then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
end;

function THumActor.Light: Integer;
var
  l: Integer;
begin
  l := m_nChrLight;
  if l < m_nMagLight then begin
    if m_boUseMagic or m_boHitEffect then
      l := m_nMagLight;
  end;
  Result := l;
end;

procedure THumActor.LoadSurface;
begin
  {
  BodySurface := FrmMain.WHumImg.GetCachedImage (BodyOffset + m_nCurrentFrame, px, py);
  if HairOffset >= 0 then
     HairSurface := FrmMain.WHairImg.GetCachedImage (HairOffset + m_nCurrentFrame, hpx, hpy)
  else HairSurface := nil;
  WeaponSurface := FrmMain.WWeapon.GetCachedImage (WeaponOffset + m_nCurrentFrame, wpx, wpy);
  }

  //BodySurface := FrmMain.WHumImg.GetCachedImage (BodyOffset + m_nCurrentFrame, px, py);
  m_BodySurface := FrmMain.GetWHumImg(m_btDress, m_btSex, m_nCurrentFrame, m_nPx, m_nPy);
  if m_BodySurface = nil then
    m_BodySurface := FrmMain.GetWHumImg(0, m_btSex, m_nCurrentFrame, m_nPx, m_nPy);


  if m_nHairOffset >= 0 then
    m_HairSurface := g_WHairImgImages.GetCachedImage(m_nHairOffset + m_nCurrentFrame, m_nHpx, m_nHpy)
  else m_HairSurface := nil;
  if (m_btEffect = 50) then begin
    if (m_nCurrentFrame <= 536) then begin
      if (GetTickCount - m_dwFrameTick) > 100 then begin
        if m_nFrame < 19 then Inc(m_nFrame)
        else begin
          if not m_bo2D0 then m_bo2D0 := TRUE
          else m_bo2D0 := FALSE;
          m_nFrame := 0;
        end;
        m_dwFrameTick := GetTickCount();
      end;
      m_HumWinSurface := FrmMain.WEffectImg.GetCachedImage(m_nHumWinOffset + m_nFrame, m_nSpx, m_nSpy);
    end;
  end else
    if (m_btEffect <> 0) then begin
    if m_nCurrentFrame < 64 then begin
      if (GetTickCount - m_dwFrameTick) > m_dwFrameTime then begin
        if m_nFrame < 7 then Inc(m_nFrame)
        else m_nFrame := 0;
        m_dwFrameTick := GetTickCount();
      end;
      m_HumWinSurface := g_WHumWingImages.GetCachedImage(m_nHumWinOffset + (m_btDir * 8) + m_nFrame, m_nSpx, m_nSpy);
    end else begin
      m_HumWinSurface := g_WHumWingImages.GetCachedImage(m_nHumWinOffset + m_nCurrentFrame, m_nSpx, m_nSpy);
    end;
  end;

  //WeaponSurface:=FrmMain.WWeapon.GetCachedImage(WeaponOffset + m_nCurrentFrame, wpx, wpy);
  m_WeaponSurface := FrmMain.GetWWeaponImg(m_btWeapon, m_btSex, m_nCurrentFrame, m_nWpx, m_nWpy);
  if m_WeaponSurface = nil then
    m_WeaponSurface := FrmMain.GetWWeaponImg(0, m_btSex, m_nCurrentFrame, m_nWpx, m_nWpy);
end;

procedure THumActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend: Boolean; boFlag: Boolean);
var
  idx, ax, ay: Integer;
  d: TDirectDrawSurface;
  ceff: TColorEffect;
  wimg: TWMImages;
begin
  d := nil; //Jacky
  if not (m_btDir in [0..7]) then Exit;
  if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface; //bodysurface loadsurface
  end;
  ceff := GetDrawEffectValue;
  if m_btRace = 0 then begin
    if (m_nCurrentFrame >= 0) and (m_nCurrentFrame <= 599) then
      m_nWpord := WORDER[m_btSex, m_nCurrentFrame];

    //      if Dress in [1..4] then begin
    //      if Dress in [18..21] then begin
    if m_btEffect <> 0 then begin
      if g_MySelf = Self then begin
        if blend then begin
          if ((m_btDir = 3) or (m_btDir = 4) or (m_btDir = 5)) and
            (m_HumWinSurface <> nil) and not boFlag then begin
            DrawBlend(dsurface,
              dx + m_nSpx + m_nShiftX,
              dy + m_nSpy + m_nShiftY,
              m_HumWinSurface,
              1);
          end else begin
            if ((m_btDir = 3) or (m_btDir = 4) or (m_btDir = 5)) and
              (m_HumWinSurface <> nil) and boFlag then begin
              DrawBlend(dsurface,
                dx + m_nSpx + m_nShiftX,
                dy + m_nSpy + m_nShiftY,
                m_HumWinSurface,
                1);
            end;
          end;
        end;
      end else begin
        if ((g_FocusCret <> nil) or (g_MagicTarget <> nil)) and
          blend and ((m_btDir = 3) or (m_btDir = 4) or (m_btDir = 5)) and
          (m_HumWinSurface <> nil) and not boFlag then begin
          DrawBlend(dsurface,
            dx + m_nSpx + m_nShiftX,
            dy + m_nSpy + m_nShiftY,
            m_HumWinSurface,
            1);
        end else begin
          if ((m_btDir = 3) or (m_btDir = 4) or (m_btDir = 5)) and
            (m_HumWinSurface <> nil) and boFlag then begin
            DrawBlend(dsurface,
              dx + m_nSpx + m_nShiftX,
              dy + m_nSpy + m_nShiftY,
              m_HumWinSurface,
              1);
          end; //0x0047D03F
        end;
      end;
    end; //0x0047D03F

    if (m_nWpord = 0) and (not blend) and (m_btWeapon >= 2) and (m_WeaponSurface <> nil) and (not m_boHideWeapon) then begin
      DrawEffSurface(dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY, blend, ceNone); //Ä®Àº »öÀÌ ¾Èº¯ÇÔ
      DrawWeaponGlimmer(dsurface, dx + m_nShiftX, dy + m_nShiftY);
      //dsurface.Draw (dx + wpx + ShiftX, dy + wpy + ShiftY, WeaponSurface.ClientRect, WeaponSurface, TRUE);
    end;
    //¸öÅë ±×¸®°í
    if m_BodySurface <> nil then
      DrawEffSurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
    if m_HairSurface <> nil then
      DrawEffSurface(dsurface, m_HairSurface, dx + m_nHpx + m_nShiftX, dy + m_nHpy + m_nShiftY, blend, ceff);

    //
    if (m_nWpord = 1) and {(not blend) and}(m_btWeapon >= 2) and (m_WeaponSurface <> nil) and (not m_boHideWeapon) then begin
      DrawEffSurface(dsurface, m_WeaponSurface, dx + m_nWpx + m_nShiftX, dy + m_nWpy + m_nShiftY, blend, ceNone);
      DrawWeaponGlimmer(dsurface, dx + m_nShiftX, dy + m_nShiftY);
      //dsurface.Draw (dx + wpx + ShiftX, dy + wpy + ShiftY, WeaponSurface.ClientRect, WeaponSurface, TRUE);
    end;

    //      if Dress in [1..4] then begin
    //      if Dress in [18..21] then begin
    if (m_btEffect = 50) then begin
      if (m_HumWinSurface <> nil) then
        DrawBlend(dsurface,
          dx + m_nSpx + m_nShiftX,
          dy + m_nSpy + m_nShiftY,
          m_HumWinSurface,
          1);
    end else
      if m_btEffect <> 0 then begin
      if g_MySelf = Self then begin
        if blend then begin
          if ((m_btDir = 0) or (m_btDir = 7) or (m_btDir = 1) or (m_btDir = 6) or (m_btDir = 2)) and
            (m_HumWinSurface <> nil) and not boFlag then begin
            DrawBlend(dsurface,
              dx + m_nSpx + m_nShiftX,
              dy + m_nSpy + m_nShiftY,
              m_HumWinSurface,
              1);
          end else begin //0x0047D27F
            if ((m_btDir = 0) or (m_btDir = 7) or (m_btDir = 1) or (m_btDir = 6) or (m_btDir = 2)) and
              (m_HumWinSurface <> nil) and boFlag then begin
              DrawBlend(dsurface,
                dx + m_nSpx + m_nShiftX,
                dy + m_nSpy + m_nShiftY,
                m_HumWinSurface,
                1);
            end;
          end;
        end;
      end else begin
        if ((g_FocusCret <> nil) or (g_MagicTarget <> nil)) and
          ((m_btDir = 0) or (m_btDir = 7) or (m_btDir = 1) or (m_btDir = 6) or (m_btDir = 2)) and
          (m_HumWinSurface <> nil) and not boFlag then begin
          DrawBlend(dsurface,
            dx + m_nSpx + m_nShiftX,
            dy + m_nSpy + m_nShiftY,
            m_HumWinSurface,
            1);
        end else begin
          if ((m_btDir = 0) or (m_btDir = 7) or (m_btDir = 1) or (m_btDir = 6) or (m_btDir = 2)) and
            (m_HumWinSurface <> nil) and boFlag then begin
            DrawBlend(dsurface,
              dx + m_nSpx + m_nShiftX,
              dy + m_nSpy + m_nShiftY,
              m_HumWinSurface,
              1);
          end;
        end;
      end;
    end;

    //ÏÔÊ¾Ä§·¨¶ÜÊ±Ð§¹û
    if m_nState and $00100000 {STATE_BUBBLEDEFENCEUP} <> 0 then begin //ÁÖ¼úÀÇ¸·
      if (m_nCurrentAction = SM_STRUCK) and (m_nCurBubbleStruck < 3) then
        idx := MAGBUBBLESTRUCKBASE + m_nCurBubbleStruck
      else
        idx := MAGBUBBLEBASE + (m_nGenAniCount mod 3);
      d := g_WMagicImages.GetCachedImage(idx, ax, ay);
      if d <> nil then
        DrawBlend(dsurface,
          dx + ax + m_nShiftX,
          dy + ay + m_nShiftY,
          d, 1);
    end;
  end;

  //ÏÔÊ¾Ä§·¨Ð§¹û
  if m_boUseMagic {and (EffDir[Dir] = 1)} and (m_CurMagic.EffectNumber > 0) then begin
    if m_nCurEffFrame in [0..m_nSpellFrame - 1] then begin
      GetEffectBase(m_CurMagic.EffectNumber - 1, 0, wimg, idx);
      idx := idx + m_nCurEffFrame;
      if wimg <> nil then
        d := wimg.GetCachedImage(idx, ax, ay);
      if d <> nil then
        DrawBlend(dsurface,
          dx + ax + m_nShiftX,
          dy + ay + m_nShiftY,
          d, 1);
    end;
  end;

  //ÏÔÊ¾¹¥»÷Ð§¹û
  if m_boHitEffect and (m_nHitEffectNumber > 0) then begin
    GetEffectBase(m_nHitEffectNumber - 1, 1, wimg, idx);
    idx := idx + m_btDir * 10 + (m_nCurrentFrame - m_nStartFrame);
    if wimg <> nil then
      d := wimg.GetCachedImage(idx, ax, ay);
    if d <> nil then
      DrawBlend(dsurface,
        dx + ax + m_nShiftX,
        dy + ay + m_nShiftY,
        d, 1);
  end;

  //ÏÔÊ¾ÎäÆ÷ÆÆËéÐ§¹û
  if m_boWeaponEffect then begin
    idx := WPEFFECTBASE + m_btDir * 10 + m_nCurWeaponEffect;
    d := g_WMagicImages.GetCachedImage(idx, ax, ay);
    if d <> nil then
      DrawBlend(dsurface,
        dx + ax + m_nShiftX,
        dy + ay + m_nShiftY,
        d, 1);
  end;
end;

end.

