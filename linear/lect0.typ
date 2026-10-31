// BEGIN content
#align(center + horizon)[
  #v(1fr)

  #text(size: 32pt, weight: "bold")[
    אלגברה ליניארית 1
  ]

  #v(2.5em)

  #line(length: 35%, stroke: 1pt + rgb("#4a7bd1"))

  #v(2em)

  #text(size: 14pt)[
    סיכומי הרצאות
  ]

  #v(1fr)

  #text(size: 12pt, fill: rgb("#666666"))[
    איתן גוטרייך
  ]

  #v(0.5em)

  #text(size: 10pt, fill: rgb("#888888"))[
    תשפ"ז
  ]

  #v(2em)
]
#pagebreak()
#outline()
#pagebreak()


= מערכות משוואות ליניאריות <chapter-1>
== פתיחה
מה זה בכלל אלגברה ליניארית?

*הנדסה אנליטית* - תיאור גיאומטריה בעזרת אלגברה ומספרים.

*אלגברה ליניארית* -  _אבסטרקציה_ של הנדסה אנליטית.

הנדסה אנליטית עובדת עם מערכת צירים, וגם בשביל להתחיל לעשות אלגברה ליניארית נצטרך להגדיר מערכת שנעבוד בה. אבל זו מערכת יותר כללית.
== $RR^n$
#definition[#nv][][
  יהי $n in NN$. "#nv" (מבוטא אנ-אי-יה, על משקל "שלישיה", "רביעיה") היא סדרה של $n$ מספרים ממשיים שרשומה בעמודה: $vec(x_1, dots.v, x_n)$, כאשר $x_1, dots.h, x_n in RR$.
]
#definition[$RR^n$][][
  הקבוצה של כל ה-#nvs מסומנת ב - $RR^n$, כלומר:
  $ RR^n = {vec(x_1, dots.v, x_n) | x_1, dots.h, x_n in RR} $
]
== חיבור וכפל בסקלר ב - $RR^n$
#definition[חיבור #nvs][][
  יהיו $vec(x_1, dots.v, x_n), vec(y_1, dots.v, y_n) in RR^n$. נגדיר את הפעולה "+" (חיבור):
  $
    vec(x_1, dov, x_n) + vec(y_1, dov, y_n) = vec(x_1 + y_1, dov, x_n + y_n) in Rn
  $
]
#definition[כפל #nvs בסקלר][][
  יהיו $vec(x_1, dov, x_n) in Rn$, $c in RR$.  נגדיר כפל בסקלר #footnote[מספר ממשי]:
  $ c vec(x_1, dov, x_n) = vec(c x_1, dov, c x_n) in Rn $
]
בשלב הזה, לא נגדיר שום סוג של כפל בין #nvs.

הערה לא פורמלית #footnote[באופן כללי זה מה שהקופסה הזו תייצג מעכשיו.]:
#informal[
  אנחנו יכולים להשתמש ב- #nvs כדי לייצג נקודות במרחב $n$-ממדי. זה נחמד, אבל אנחנו רוצים גם לדבר על צורות יותר מסובכות. אנחנו יכולים לייצג אותם בעזרת משוואות מסוגים שונים, כאשר המשוואה תייצג את הצורה שמורכבת מקבוצת כל ה- #nvs  שמהוות פתרון למשוואה.
]
#definition[משוואה ליניארית ב - $n$ נעלמים #footnote[מכאן ואילך, כל משוואה ליניארית היא ב - $n$ נעלמים, אלא אם כן ייאמר אחרת.]][][
  משוואה ליניארית היא משוואה מהצורה
  $ a_1x_1 + doh + a_n x_n = b $
  כאשר $a_1, ..., a_n, b in RR$, ו - $x_1, doh, x_n$ הם הנעלמים.
]
#definition[פתרונות של משוואה ליניארית][][
  #nv $vec(d_1, dov, d_n) in Rn$
  נקראת פתרון של המשוואה הליניארית $a_1x_1 + doh + a_n x_n = b$ כאשר מתקיים $a_1 d_1 + doh + a_n d_n = b$. *קבוצת הפתרונות* של המשוואה הליניארית היא:
  $ {vec(x_1, dov, x_n) in Rn mid(|) a_1 x_1 + doh + a_n x_n = b } $
]
#definition[הצגה פרמטרית של משוואה ליניארית][][
  הצגה פרמטרית של משוואה ליניארית היא הצגה (שקולה לזאת שאנחנו מכירים) לקבוצת הפתרונות של המשוואה הליניארית, מהצורה:
  $ {u_0 + t_1 u_1 + doh + t_k u_k whe t_1, doh, t_k in RR} $
  כאשר $u_0, u_1, doh, u_k in Rn$.
]
#informal[עכשיו שהגדרנו משוואות, ופתרונות שלהן, באמצעות קבוצה של #nvs, שמייצגות נקודות, נגדיר _מערכת משוואות_, שמייצגת _חיתוך_ בין צורות, בעזרת קבוצה של משוואות.]
#definition[מערכת משוואות ליניאריות][][
  מערכת של $m$ משוואות ליניאריות ב - $n$ נעלמים היא מערכת מהצורה:
  $
    cases(a_(1,1) x_1 + doh + a_(1,n) x_n = b_1, a_(2,1) x_1 + doh + a_(2,n) x_n = b_2, dov, a_(m,1)x_1 + doh + a_(m,n) x_n = b_m)
  $
]
#definition[פתרון של מערכת משוואות ליניאריות][][
  #nv $vec(d_1, dov, d_n) in Rn$
  נקראת פתרון של מערכת משוואות ליניארית כאשר היא מהווה פתרון של *כל אחת* ממשוואות המערכת.
]
עכשיו ננסה למצוא הצגה פרמטרית לפתרון של _מערכת_ משוואות ליניארית. זה יותר מסובך, אז קודם נלמד איך למצוא הצגות פרמטריות של פתרונות של מערכות משוואות ליניאריות במקרים שבהם קל לעשות את זה, ואז נלמד איך אפשר, בכל המקרים האחרים, לשנות את המערכת עד שנגיע למקרה הקל. אבל בגלל שנתעסק הרבה במערכות משוואות, קודם נגדיר דרך פחות מסורבלת לכתוב אותן.
#definition[מטריצה של מערכת משוואות ליניארית][][
  מטריצה של מערכת משוואות ליניארית היא:
  $
    mat(a_(1,1), a_(1,2), doh, a_(1,n); a_(2,1), a_(2,2), doh, a_(2,n); dov; a_(m,1), a_(m,2), doh, a_(m, n))
  $
]
#definition[ מטריצה מורחבת של מערכת משוואות ליניאריות][
  מטריצה *מורחבת* של מערכת משוואות ליניאריות היא:
  $
    mat(a_(1,1), a_(1,2), doh, a_(1,n), b_1; a_(2,1), a_(2,2), doh, a_(2,n), b_2; dov, dov, dov, dov, dov; a_(m,1), a_(m,2), doh, a_(m, n), b_m; augment: #4)
  $
]
מטריצה *מורחבת* של מערכת משוואות ליניאריות מכילה את כל המידע על המערכת, או במילים אחרות היא ייצוג שקול למערכת. עכשיו נראה לאילו פתרונות של מערכות משוואות ליניאריות קל לנו יותר למצוא פתרון, ע"י תנאים על המטריצה של המערכת.
#definition[איבר מוביל][
  האיבר המוביל בשורה של מטריצה הוא המספר השמאלי ביותר (כלומר בעל הערך הנמוך ביותר באינדקס השני שלו) אשר שונה מ - 0.
]
#definition[מטריצה מדורגת מצומצמת][
  מטריצה נקראת מדורגת מצומצמת כאשר היא מקיימת את התנאים הבאים:
  + האיבר המוביל בכל שורה (אם הוא קיים) שווה ל - 1.
  + כל מספר *בעמודה* של איבר מוביל של שורה כלשהי (חוץ ממנו בעצמו) שווה ל - 0.
  + אם בשורה כלשהי יש איבר מוביל, אז בשורה שמעליה גם יש איבר מוביל והוא נמצא בצד שמאל (כלומר בעל ערך נמוך יותר באינדקס השני שלו) מהאיבר המוביל של השורה המקורית.
] <reduced-ranked-matrix-definition>
לפתרונות של מערכות משוואות ליניאריות, שהייצוג שלהם כמטריצה מורחבת הוא מדורג מצומצם, יותר קל לנו למצוא הצגה פרמטרית.
#example[

  $
    mat(0, #hl(1), -2, 0, -1, 3; 0, 0, 0, #hl(1), 2, -1; 0, 0, 0, 0, 0, 0; augment: #5)
  $

]
נשים לב, שאם מטריצה מקיימת את שני התנאים הראשונים של מטריצה מדורגת-מצומצמת אבל לא את השלישי, ניתן ליצור מטריצה אחרת שכן מקיימת אותו על ידי שינוי סדר *בתוך שורות*. אם נעבור למה שהמטריצה מייצגת (כלומר מערכת משוואות ליניאריות), זה מקביל לשינוי סדר איברים *חיבוריים* בתוך הסכום שהם נמצאים בו (וזה תמיד מותר, מקומוטטיביות החיבור). \
אבל, כמובן, לפעמים קבוצת הפתרונות היא קבוצה ריקה. לדוגמא, אם נתונה מערכת משוואות ליניאריות כך שהמטריצה המורחבת שלה היא מדורגת מצומצמת, ובעמודה הימנית (כלומר כשהאינדקס השני הוא $m$) של המטריצה יש איבר מוביל, אז קבוצת הפתרונות של המערכת ריקה.
#definition[איברים חופשיים וקשורים][
  נניח כי נתונה ממ"ל #footnote[מערכת משוואות ליניארית] כך שהמטריצה המורחבת שלה היא מדורגת מצומצמת, ואין איברים מובילים בעמודה הימנית. נעלמים שמתאימים לעמודות המטריצה שמכילות איבר מוביל כלשהו נקראית *קשורים*. שאר הנעלמים נקראים *חופשיים*.
]
#example[נמיר את המטריצה מהדוגמא הקודמת למערכת משוואות:
  $ cases(x_2 - 2x_3 - x_4 = 3, x_4 + 2x_5 = -1, 0 = 0) $
  נשים לב שהנעלם $x_1$ לא מופיע במשוואות אך הוא עדיין נעלם, פשוט אין עליו תנאים. \
  קבוצת הפתרונות של המערכת היא:
  $
    { vec(x_1, x_2, x_3, x_4, x_5) in RR^5 mid(|) cases(x_2 - 2x_3 - x_5 = 3, x_4 + 2x_5 = -1) }
  $
  $
    = { vec(x_1, x_2, x_3, x_4, x_5) in RR^5 mid(|) cases(x_2 = 2x_3 + x_5 + 3, x_4 = -2x_5 - 1) }
  $
  $
    = { vec(x_1, 2x_3 + x_5 + 3, x_3, -2x_5 - 1, x_5) mid(|) x_1, x_3, x_5 in RR }
  $
  בפרמטריזציה נהוג לקרוא למשתנה $t$.
  $
    = { vec(t_1, 2t_2 + t_3 + 3, t_2, -2t_3 - 1, t_3) in RR^5 mid(|) t_1, t_2, t_3 in RR }
  $
  $
    = { vec(0, 3, 0, -1, 0) + t_1 vec(1, 0, 0, 0, 0) + t_2 vec(0, 2, 1, 0, 0) + t_3 vec(0, 1, 0, -2, 1) mid(|) t_1, t_2, t_3 in RR }
  $
]
באופן כללי, מספר הפרמטרים בפרמטריזציה של ממ"ל שווה למספר הנעלמים פחות מספר האיברים המובילים במטריצה (בהנחה שהיא מדורגת מצומצמת, וגם יש פתרון), אשר שווה למספר העמודות ללא איבר מוביל (במטריצה הלא-מורחבת). \
ספציפית, אם בכל עמודה של המטריצה (הלא-מורחבת) יש איבר מוביל, אז לממ"ל יש פתרון יחיד. אחרת לממ"ל יהיו אינסוף פתרונות.
#corollary[][
  אם נתונה ממ"ל כך שהמטריצה המורחבת שלה היא מדורגת מצומצמת, ובנוסף מספר המשוואות של המערכת קטן ממספר הנעלמים, אז קבוצת הפתרונות של הממ"ל היא ריקה או אינסופית.
] <corollary-infinite-or-empty-solutions>
#proof[
  אם יש איבר מוביל בעמודה הימנית של המטריצה, אז לממ"ל אין פתרונות. אחרת, מספר האיברים המוכלים במטריצה קטן או שווה למספר השורות, אשר קטן ממש ממספר הנעלמים. לכן יש עמודה במטריצה הלא-מורחבת של המערכת ללא איבר מוביל, ומכאן לממ"ל יש אינסוף פתרונות.
]
== פעולות שורה אלמנטריות
#notation[][
  תהי $M$ מטריצה בעלת $m$ שורות. לכל $i in [m]$ נסמן ב - $R_i$ את השורה ה - $i$.
]
#definition[פעולות שורה אלמנטריות (פש"א)][פעולות שואה אלמנטריות הן הפעולות הבאות:
  + כפל של השורה $R_i$ בסקלר $c in RR$. נסמן: $R_i -> c R_i$.
  + הוספת כפולה של שורה $R_i$ לשורה $R_j$, $i != j$. נסמן: $R_j -> R_j + c R_i$ ($c in RR$).
  + החלפת השורה $R_i$ עם השורה $R_j$ ($i != j$). נסמן: $R_i <-> R_j$.
]
#property[][
  לכל פש"א קיימת פש"א הופכית.
  #proof[
    תהי $epsilon$ פש"א.
    + אם $epsilon = quote R_i -> c R_i quote$, $c != 0$, אז הפש"א ההופכית היא $epsilon^(-1) = quote R_i -> 1/c R_i quote$ (מותר לעשות את זה כי $c != 0$).
    + אם $epsilon = quote R_j -> R_j + c R_i quote$, אז הפש"א ההופכית היא $epsilon^(-1) = quote R_j -> R_j - c R_i quote$.
    + אם $epsilon = quote R_i <-> R_j quote$, אז הפש"א ההופכית היא $epsilon^(-1) = epsilon = quote R_i <-> R_j quote$.
  ]
] <elementary-row-operation-inverse-property>

#definition[מטריצות שקולות שורה][
  תהיינה $A,B$ מטריצות בעלות $m$ שורות ו - $n$ עמודות. אומרים כי $B$ שקולת שורה ל - $A$ כאשר ניתן לקבל את $B$ מ - $A$ ע"י ביצוע סדרה של פש"א.
]
#property[
  שקילות שורה הוא יחס שקילות.
  #proof[
    + *רפלקסיביות:* $A$ שקולת שורה ל - $A$. נבצע את הפעולה $R_i -> 1 dot R_i$.
    + *סימטריות:* אם $B$ שקולת שורה ל - $A$, אז $A$ שקולת שורה ל - $B$. ע"פ @elementary-row-operation-inverse-property.
    + *טרנזיטיביות:* אם $C$ שקולת שורה ל - $B$, וגם $B$ שקולת שורה ל - $A$, אז $C$ שקולת שורה ל - $A$. נבצע קודם את סדרת הפעולות שמובילה מ - $A$ ל - $B$ (קיימת כי הן שקולות שורה), ואז מ - $B$ ל - $C$ (קיימות כי גם הן שקולות שורה), והגענו מ - $A$ ל - $C$.
  ]
]
#proposition[
  נתונות שתי ממ"ל בעלות $m$ משוואות ו - $n$ נעלמים. אם המטריצות המורחבות שלהן שקולות שורה, אז קבוצות הפתרונות שלהן זהות.
  #proof[
    נסמן את המטריצות המורחבות של הממ"ל הנתונות ב - $A, B$. מספיק להוכיח את הטענה במקרה שבו $B$ מתקבלת מ - $A$ ע"י ביצוע של פש"א אחת (כי אם יש כמה, מטרנזיטיביות, אפשר להפעיל את ההוכחה הזו על כל מטריצה אחרי כל צעד, והקבוצות של כולן זהות, אז גם הקבוצה של המטריצה הסופית זהה). נסמן את הפש"א הזו ב - $epsilon$.

    אם $epsilon = quote R_i <-> R_j quote$, ברור שהטענה נכונה (אין משמעות לשינוי סדר המשוואות).

    אם $epsilon = quote R_i -> c R_i quote$, נסמן $R_i = a_1, a_2, doh, a_n, b$. נראה כי קבוצת הפתרונות של הממ"ל עם מטריצה מורחבת $A$ מוכלת בקבוצת הפתרונות של הממ"ל עם מטריצה מורחבת $B$.

    יהי $vec(d_1, dov, d_n) in Rn$ פתרון של ממ"ל הראשונה. מאחר שכל המשוואות של ממ"ל השנייה זהות למשוואות של ממ"ל הראשונה חוץ מהמשוואה ה - $i$, $vec(d_1, dov, d_n)$ מהווה לכל הפחות פתרון של המשוואות _האלו_. המשוואה ה - $i$ של המערכת הראשונה היא: $a_1 x_1 + a_2 x_2 + doh + a_n x_n = b$. מאחר ש - $vec(d_1, dov, d_n)$ הוא פתרון של משוואה זו, מתקיים: $a_1 d_1 + doh + a_n d_n = b$. מכאן נובע כי $(c a_1) d_1 + doh + (c a_n) d_n = c b$, כלומר $vec(d_1, dov, d_n)$ הוא פתרון של המשוואה $(c a_1)x_1 + doh + (c a_n) x_n = c b$, שזו בדיוק המשוואה ה - $i$ בממ"ל השנייה. לפיכך $vec(d_1, dov, d_n)$ הוא פתרון של ממ"ל השנייה.

    מאחר שניתן לקבל את $A$ מ - $B$ ע"י ביצוע פעולה $epsilon = quote R_i -> 1/c R_i quote$, אז אותו הנימוק מוכיח כי קבוצת הפתרונות של ממ"ל השנייה מוכלת בקבוצת הפתרונות של ממ"ל השנייה, ולפיכך שתי קבוצות הפתרונות זהות.

    #exercise[
      הוכיחו את הטענה גם עבור הסוג הנותר של פש"א.
    ]
  ]
] <proposition-same-solutions-equivalent-matrices>

#proposition[][כל מטריצה היא שקולת שורה למטריצה מדורגת מצומצמת כלשהי.
    #proof[
        תהי $A$ מטריצה כלשהי. נשתמש באלגוריתם הבא:
        
        אם קיים איבר מוביל $a$ בשורה $R_1$, נבצע את הפעולה $R_1 -> 1/a R_1$. עכשיו מתקיים תנאי מספר 1 מ - @reduced-ranked-matrix-definition לגבי שורה 1. אם מתחת (או מעל, בהמשך) לאיבר $a$, בשורה $R_j$, מופיע איבר שונה מ - $0$, נסמן אותו ב - $b$, ונבצע את הפעולה $R_j -> R_j - b R_1$. עכשיו מתקיים תנאי מספר 2 מ - @reduced-ranked-matrix-definition על שורה 1. אחר כך נעשה את שתי הפעולות האלו על כל שורה עד $n$, לא רק על שורה 1, וכך נגיע למצב שתנאים 1,2 מ - @reduced-ranked-matrix-definition מתקיימים על כל המטריצה. נשאר לנו התנאי האחרון מ - @reduced-ranked-matrix-definition. כל פעם שהוא לא מתקיים עבור שורה $i$, נבצע את הפש"א $R_(i-1) <-> R_i$. אחרי מספר פעולות שורה כאלה, המטריצה תתמיין מחדש #footnote[בעצם, פשוט עשינו כאן bubble sort, רק לפי התאמה לתנאי, לא לפי סדר.] כך שהתנאי יתקיים.
        
    ]
    
        #informal[
            גם טענה יותר חזקה היא נכונה: כל מטריצה היא שקולת שורה למטריצה מדורגת מצומצמת *יחידה*, אבל לא נוכיח את הטענה הזו (כי ההוכחה מסורבלת) ולא נשתמש בה.
        ]
]
#example[
    $ mat(0, hl(2), 4, -2; 3, 2, -2, -5; 1, -1, -4, 1) ero(R_1 -> 1/2 R_1) mat(0, hl(1), 2, -1; 3, 2, -2, -5; 1, -1, -4, 1) ero(R_2 -> R_2 -2 R_1) $
    $ mat(0,1,2,-1;3,0,-6,-3;1,-1,-4,1) ero(R_3 -> R_3 + R_1) mat(0,1,2,-1; hl(3),0,-6,-3; 1, 0, -2, 0) ero(R_2 -> 1/3 R_2) $
    $ mat(0,1,2,-1; hl(1),0,-2,-1; 1,0,-2,0;) ero(R_3 -> R_3 - R_2) mat(0, 1, 2, -1; 1, 0 ,-2 ,-1; 0, 0, 0, hl(1)) ero(R_1 -> R_1 + R_3) $
    $ mat(0,1,2,0; 1,0,-2,-1; 0,0,0,1) ero(R_2 -> R_2 + R_3) mat(0,hl(1),2,0; hl(1),0,-2,0; 0,0,0,hl(1)) $
    $ ero(R_1 <-> R_2) #text(dir:ltr)[ #pavemat(
        fills: (
            "[0-0]": yellow.transparentize(50%),
            "[1-1]": yellow.transparentize(50%),
            "[2-3]": yellow.transparentize(50%)
        ),
        pave: (
            (path: "DSDDSD", from: (1,0), stroke: (paint: red, thickness: 1pt))
        )
    )[$mat(1,0,-2,0;0,1,-2,0;0,0,0,1)$] ] $
    
]
#definition[משוואה ליניארית הומוגנית][
    משוואה לינייארית $a_1 x_1 + doh + a_n x_n = b$ נקראת *הומוגנית* כאשר $b=0$.
]
#definition[ממ"ל הומוגנית][
    ממ"ל תיקרא *הומוגנית* כאשר כל אחת מהמשוואות שלה היא הומוגנית, כלומר העמודה הימנית ביותר במטריצה המורחבת של הממ"ל היא $vec(0,dov,0)$.
]
#property[
    ממ"ל ב - $n$ נעלמים היא הומוגנית אמ"מ ה - #nv $vec(0,dov,0) in Rn$ היא פתרון שלה.
]
#fact[
    תהיינה $A,B$ מטריצות שקולות שורה. אם העמודה ה - $j$ של $A$ היא $vec(0,dov, 0)$, אז גם העמודה ה - $j$ של $B$ היא $vec(0,dov,0)$.
]
#corollary[
    נתונה ממ"ל הומוגנית בעלת $m$ משוואות ב - $n$ נעלמים. אם $m<n$, אז למערכת יש אינסוף פתרונות, ובפרט יש לה פתרון שונה מ - $vec(0, dov, 0)$, כלומר פתרון לא טריוויאלי.
]
#proof[
    נסמן ב - $A$ את המטריצה המורחבת של הממ"ל, ונסמן ב - $B$ את המטריצה המדורגת מצומצמת ששקולת שורה ל - $A$. מאחר שהממ"ל היא הומוגנית, העמודה הימנית של $A$ היא $vec(0, dov ,0)$, ולכן גם העמודה הימנית של $B$ היא $vec(0, dov, 0)$. נתבונן בממ"ל עם מטריצה מורחבת $B$. אז לפי @corollary-infinite-or-empty-solutions, לממ"ל זו יש אינסוף פתרונות (כי יש לה לפחות פתרון אחד, שהוא $vec(0, dov, 0)$, ולפי הטענה אנחנו יודעים שיש 0 או אינסוף). אז לפי @proposition-same-solutions-equivalent-matrices, גם לממ"ל הנתונה יש אינסוף פתרונות.
]



== כפל מטריצות ב #nvs
#definition[
    נסמן את קבוצת המטריצות בעלות $m$ שורות ו - $n$ עמודות (על המספרים הממשיים) ב - $M_(m times n) (RR)$.
]
#definition[
        יהיו $C_1, ... C_n in RR^m$, ו - $d_1, ... d_n in RR$. *צירוף ליניארי* של $C_1, ..., C_n$ עם המקדמים $d_1, ..., d_n$ מוגדר להיות:
        $ sum_(i=1)^n d_i C_i = d_1 C_1 + ... + d_n C_n in RR^m $
]
#definition[
    תהי $ammnr$, ותהי $d in Rn$. לכל $i in [n]$, נסמן את העמודה ה - $i$ של המטריצה כ - $C_i$. בנוסף, נסמן $d = vec(d_1, dov, d_n)$. נגדיר את המכפלה:
    $ A d= d_1 C_1 + ... + d_n C_n in RR^m $
]
#example[
    $ A = mat(1,2,3;4,5,6) quad quad d = vec(7, 8, 9) $
    $ A d = 7 vec(1,4) + 8 vec(2,5) + 9 vec(3, 6) $
    $ = vec(7, 28) + vec(16, 40) + vec(27, 54) $
    $ = vec(50, 122) in RR^2 $
]
#corollary[
    יהיו $d = vec(d_1, dov, d_n)$, $A = mat(a_(1,1), ..., a_(1,n); dov, , dov; a_(m,1), ..., a_(m,n))$. אז הקואורדינטה ה - $i$ של $A d$ היא 
    $ d_1 a_(i,1) + ... + d_n a_(i, n) $
]
#corollary[
    נתונה ממ"ל:
    $ cases(
        a_(1,1) x_1 + ... + a_(1,n) x_n = b_1,
        space space space space space space space space space space space space space dov,
        a_(m, 1) x_1 + ... + a_(m,n) x_n = b_m
    ) $
    ותהי $d = vec(d_1, dov, d_m) in Rn$. אז $d$ מהווה פתרון של המערכת אמ"ם
    $ cases(
        a_(1,1) d_1 + ... + a_(1,n) d_n = b_1,
        dov,
        a_(m,1) d_1 + ... + a_(m,n) d_n = b_m
    ) $
    כלומר:
    $ vec(
        a_(1,1) d_1 + ... + a_(1,n) d_n,
        dov,
        a_(m,1) d_1 + ... + a_(m,n) d_n
    ) = vec(b_1, dov, b_n) $
    $ A d = vec(b_1, dov, b_n) = b $
    כאשר $A$ המטריצה הלא-מורחבת של הממ"ל, ו - $b$ היא העמודה הימנית במטריצה המורחבת של הממ"ל. לכן, ניתן לכתוב את הממ"ל בצורה הבאה:
    $ A x = b $
    כאשר $x = vec(x_1, dov, x_n)$. 
]
#property[][
  תהי $A in M_(m times n) (RR)$, $d = vec(0, dov, 0) in Rn$. אז $A d = vec(0, dov, 0) in RR^m$.
]
#proof[
  $A d = 0 dot C_1 + doh + 0 dot C_n = vec(0, dov, 0) + doh + vec(0, dov, 0) = vec(0, dov, 0)$
]
#property[][
  תהי $A in M_(m times n) (RR)$, $d, h in Rn$. אז $A(d + h) = A d + A h$.
]
#proof[
  נסמן $h = vec(h_1, dov, h_n)$, $d = vec(d_1, dov, d_n)$. אז $d+h = vec(d_1 + h_1, dov, d_n + h_n)$. מכאן:
  $ A(d+h) = (d_1 + h_1) C_1 + doh + (d_n + h_n) C_n = $
  $ d_1 C_1 + h_1 C_1 + doh + d_n C_n + h_n C_n = $
  $ = (d_1 C_1 + doh + d_n C_n) + (h_1 C_1 + doh + h_n C_n) = A d +A h $
]
#property[][
  תהי $ammnr$, $d in Rn$, $k in RR$. אז $A(k d) = k(A d)$.
]
#proof[
  נסמן $d = vec(d_1, dov, d_n)$. אז  $k d = vec(k d_1, dov, k d_n)$. מכאן:
  $ A(k d) = k d_1 C_1 + doh + k d_n C_n = k( d_1 C_1+ doh + d_n C_n) = k A d $
]
#corollary[][
  תהי $ammnr$. נתבונן בממ"ל *הומוגנית* $A x = vec(0, dov, 0)$. אז:
  + אם $d, h in Rn$ הם פתרונות של הממ"ל, אז גם $d+h$ הוא פתרון של אותה הממ"ל.
  + אם $d in Rn$ פתרון של המערכת, ו - $k in RR$, אז גם $k d$ הוא פתרון של המערכת.
]
#proof[
  $ A(d+h) = A d + A h = vec(0, dov, 0) + vec(0, dov, 0) = vz $
]
#proof[
  $ A (k d) = k (A d) = k vz = vz $
]
#corollary[
  תהי $ammnr$ כך שהשורה ה - $i$ של $A$ היא  $(0, doh, 0)$.  יהי $d in Rn$. אז הקואורדינטה ה - $i$ של $A d$ היא 0.
]

אנחנו כבר מכירים את #nvof האפסים (כלומר #vz ). נראה כמה #nvs דומות, גם חשובות, אבל לא *לגמרי* מאופסות.
#definition[$e_i$][
  יהיו $n in NN$, $i in [n]$. נסמן $e_i = vec(0, dov, 0, 1, 0, dov, 0) in Rn$, כאשר האיבר שאינו 0 הוא במקום ה - $i$.
]
#example[
  אם $n=3$, אז $e_1 = vec(1, 0, 0)$, $e_2 = vec(0, 1, 0)$, $e_z = vec(0, 0, 1)$.
]

#informal[
  אם נמשיך את האנלוגיה שלנו בין #nvs לנקודות:
  #cetz.canvas({
    import cetz.draw: *

    // Axes
    line((-0.3, 0), (2, 0), mark: (end: ">"))
    line((0, -0.3), (0, 2), mark: (end: ">"))

    // Points
    circle((1, 0), radius: 0.07, fill: blue, stroke: none)
    circle((0, 1), radius: 0.07, fill: blue, stroke: none)

    // Labels
    content((1, 0), $e_1$, anchor: "north", padding: 0.12)
    content((0, 1), $e_2$, anchor: "east", padding: 0.12)

    // Title
    content((0.85, 2), $n=2$, anchor: "south")
  })
]
#property[
  תהי $ammnr$. אז $A e_i = C_i$.
]
#proof[
  $A e_i = A vec(0, dov, 0, 1, 0, dov, 0) = 0 dot C_1 + doh + 0 dot C_(i-1) + 1 dot C_i + 0 dot C_(i + 1) + doh + 0 dot C_n = 1 dot C_i = C_i$
]
#definition[מטריצה ריבועית][
  מטריצה $ammnr$ נקראת "מטריצה ריבועית", אם $m=n$, כלומר כמות השורות שלה שווה לכמות העמודות שלה.
]
#definition[מטריצת היחידה][
  יהי $n in NN$. מטריצת היחידה בגודל $n$ היא $I_n in M_(n times m) (RR)$, כאשר העמודה ה - $i$ של $I_n$ היא $e_i$. כלומר.:
  $
    I_n = mat(1, 0, 0, doh, 0; 0, 1, 0, , 0; 0, 0, 1, , 0; dov, dov, dov, , ; 0, 0, 0, doh, 1)
  $
]
#property[][
  $I_n$ היא מדורגת מצומצמת.
]
#property[][
  תהי $d in Rn$. אז $I_n d = d$.
]
#proof[
  נסמן $d = vec(d_1, dov, d_n)$. אז:
  $
    I_n d = d_1 e_1 + d_2 e_2 + doh + d_n e_n = d_1 vec(1, 0, dov, 0) + d_2 vec(0, 1, dov, 0) + doh + d_n vec(0, 0, dov, 1) =
  $
  $
    = vec(d_1, 0, dov, 0) + vec(0, d_2, dov, 0) + doh + vec(0, 0, dov, d_n) = vec(d_1, d_2, dov, d_n) = d
  $
]

= דברים יותר אבסטרקטיים
== שדות
אנחנו לדבר על מספרים בתור מספרים ממשיים, טבעיים, מרוכבים, $p$-אדים, וכו', אבל אנחנו בעצם משתמשים במופעים שונים של אותו הדבר. אז אפשר לעשות אבסטרקציה לקונספט של *מערכת* מספרית. קוראים לזה שדה, ואנחנו נגדיר את המערכת הכללית הזאת עם 9 אקסיומות, שתקפות לכל מערכת מספרית, גם כאלו שאנחנו מכירים וגם כאלו שלא.
#definition[שדה][
  קבוצה $F$, ושתי פעולות בינאריות על הקבוצה (נקרא להן חיבור וכפל, ונסמן אותן בעזרת $+$, $dot$), ייקראו *שדה*, כאשר מתקיימות האקסיומות הבאות:
  #braced("אקסיומות \n חיבוריות", [
    #axiom[קומוטטיביות][$ forall a, b in F: a+ b = b + a $] <A1>
    #axiom[אסוציאטיביות][$ forall a,b,c in F: a + (b + c) = (a+b)+c $] <A2>
    #axiom[קיום זהות][$ exists 0_F in F forall a in F: a+ 0_F = a $] <A3>
    #axiom[קיום הופכי][$ forall a in F exists -a in F: a + (-a) = 0_F $] <A4>
  ])
  #braced("אקסיומות \n כפליות", [
    #axiom[קומוטטיביות][$ forall a,b in F: a dot b = b dot a $] <M1>
    #axiom[אסוציאטיביות][$
      forall a,b,c in F: a dot (b dot c) = (a dot b) dot c
    $] <M2>
    #axiom[קיום זהות][$ exists 1_F in F forall a in F: a dot 1_F = a $] <M3>
    #axiom[קיום הופכי][$
      forall a != 0_F in F exists a^(-1) in F: a dot a^(-1) = 1_F
    $] <M4>
  ])
  #braced("אקסיומה \n דיסטריביוטיבית", [
    #axiom[דיסטריביוטיביות][$
      forall a,b,c in F: a dot(b + c) = a dot b + a dot c
    $] <D1>
  ])

]
#example[
  דוגמאות לקבוצות שהן שדות (עם חיבור וכפל כמו שאנחנו מכירים אותם):
  + $RR$
  + $CC$
  + ${0,1} = F_2$ (חיבור וכפל מודולו 2)
  + $QQ$
]
#informal[ בכל מקום בפרק הזה, אלא אם כן יהיה ברור מההקשר אחרת, כשאני כותב מספר כמו
  $0$,
  או
  $1$,
  הכוונה היא ל - $0_bold(F)$, או $1_bold(F)$, וכו'.]
== תכונות של שדות
יהי $F$ שדה. מתקיימות התכונות הבאות:
#property[][
  אם $z in F$ כך ש - $a + z = a$ לכל $a in F$, אז $z = 0_F$.
  #proof[
    $
      z limits(=)_(#text(size: 0.7em)[@A3]) z+0 limits(=)_(#text(size: 0.7em)[@A1]) 0 + z limits(=)_(#text(size: 0.7em)[נתון]) 0
    $
  ]
] <fields-property-1>
#property[][
  אם $a,b in F$ כך ש - $a + b = 0$, אז $b = -a$.
  #proof[
    $
      b bcs(#[@A3]) b + 0 bcs(#[@A1]) 0 + b bcs(#[@A4]) (a + (- a)) + b bcs(#[@A1]) ((-a) + a) + b bcs(#[@A2]) - a + (a + b) \ bcs("נתון") (-a) + 0 bcs(#[@A3]) -a
    $
  ]
] <fields-property-2>
#property[][
  אם $a in F$ כך ש - $a + a = a$, אז $a = 0$.
  #proof[
    $
      a bcs(#[@A3]) a + 0 bcs(#[@A4]) a + (a + (-a)) bcs(#[@A2]) (a + a) + (- a) bcs("נתון") a + (-a) bcs(#[@A4]) 0
    $
  ]
  אם $a in F$ כך ש - $a + a = 0$, אז $a$ לא בהכרח שווה ל - 0. לדוגמא: $a = 1, F = ZZ_2$.
] <fields-property-3>
#property[][
  $a dot 0 = 0$,
  לכל $a in F$.
  #proof[
    $ a dot 0 + a dot 0 bcs(#[@D1]) a (0 + 0) bcs(#[@A3]) a dot 0 $
    אז לפי @fields-property-3 מתקיים $a dot 0 = 0$.
  ]
] <fields-property-4>
#property[][
  $a dot (-1) = -a$
  לכל $a in F$.
  #proof[
    $
      a + a dot(-1) bcs(#[@M3]) a dot 1 + a dot (-1) bcs(#[@D1]) a dot (1 + (-1)) bcs(#[@A4]) a dot 0 bcs(#[@fields-property-4]) 0
    $
    אז לפי @fields-property-2 מתקיים $a dot (-1) = -a$.
  ]
] <fields-property-5>
#property[][
  אם $e in F$ כך ש - $a dot e = a$ לכל $a in F$, אז $e = 1$.
  #proof[
    דומה להוכחה של @fields-property-1.
  ]
] <fields-property-6>
#property[][
  אם $a,b in F$ כך ש - $a dot b = 1$, אז $b = a^(-1)$.
  #proof[
    דומה להוכחה של @fields-property-2.
  ]
] <fields-property-7>
#property[][
  אם $a,b in F$ כך ש - $a dot b = 0$, אז $a = 0$ או $b = 0$.
  #proof[
    אם $b=0$ סיימנו. אחרת (@M4) קיים $b^(-1) in F$ כך ש - $b dot b^(-1)$. אז:
    $
      a bcs(#[@M3]) a dot 1 bcs(#[@M4]) a (b dot b^(-1)) bcs(#[@M2]) (a dot b) b^(-1) bcs("נתון") 0 dot b^(-1) bcs(#[@M1]) b^(-1) dot 0 bcs(#[@fields-property-4]) 0
    $
  ]
] <fields-property-8>
#informal[
  כל מה שלמדנו בפרק הראשון של הקורס (@chapter-1) יהיה תקף כאשר מחליפים את $RR$ בשדה כלשהו, חוץ מדבר אחד: בטענות בהן מדובר ב - "אינסוף פתרונות", צריך להחליף את הטענה הזו בטענה (החלשה יותר) לגבי "יותר מפתרון אחד".
]
== מרחבים ווקטוריים
#definition[מרחב וקטורי (מ"ו)][קבוצה $V$ נקראת מרחב וקטורי מעל $F$ כאשר
  ב - $V$ מוגדר חיבור ($+$) אשר לכל $u,v in V$ מתאים  $u+v in V$, וכפל בסקלר מ - $F$, אשר לכל $v in V$ ולכל $c in F$ מתאים $c v in V$ אשר מקיימים את האקסיומות הבאות:
  #axiom[
    $u + v = v + u$ לכל $u,v in V$.
  ] <vector-space-axiom-1>
  #axiom[
    $(u + v) + w = u + (v + w)$ לכל $u,v,w in V$.
  ] <vector-space-axiom-2>
  #axiom[
    קיים $0_V in V$ כך ש - $u + 0_V = u$ לכל $u in V$.
  ] <vector-space-axiom-3>
  #axiom[
    לכל $u in V$ קיים $-u in V$ כך ש - $u + (-u) = 0_V$.
  ] <vector-space-axiom-4>
  #axiom[
    $c (d u) = (c d) u$,
    לכל $u in V$, $c, d in F$.
  ] <vector-space-axiom-5>
  #axiom[
    $1_F u = u$, לכל $u in V$.
  ] <vector-space-axiom-6>
  #axiom[
    $c (u + v) = c u + c v$, לכל $u, v in V$, $c in F$.
  ] <vector-space-axiom-7>
  #axiom[
    $(c + d) u = c u+ d u$, לכל $u in V$, $c,d in F$.
  ] <vector-space-axiom-8>
]
#notation[
  לאיברים במרחב וקטורי, נקרא *וקטור*. לאיברים בשדה, נקרא *סקלר*.
]
#example(title: text[דוגמה: #nvs מעל $F$])[
  $ V = FF^n = {vec(x_1, dov, x_n) mid(|) x_1, doh, x_n in FF} $
  עם חיבור וכפל בסקלר "רגילים" (כמו שאנחנו מכירים אותם).
  #proof[
    נראה כי @vector-space-axiom-1 מתקיימת:

    יהיו $u, v in FF^n$. נסמן $v = vec(y_1, dov, y_n)$, $u = vec(y_1, dov, y_n)$.
    $
      u + v = vec(x_1, dov, x_n) + (y_1, dov, y_n) = vec(x_1 +y_1, dov, x_n + y_n) = vec(y_1 + x_1, dov, y_n + x_n) = vec(y_1, dov, y_n) + vec(x_1, dov, x_n) \ = v+u
    $
    בדומה ניתן להוכיח את שאר האקסיומות (הוכחות קלות ומשעממות).

  ]
]
#example(title: text[דוגמה: מטריצות מעל $F$])[
  יהיו $m, n in NN$.
  $
    M_(m times n) (F) = {mat(a_(1,1), doh, a_(1,n); dov, , dov; a_(m,1), doh, a_(m,n)) mid(|) forall j in [n], i in [n]: a_(i,j) in F}
  $
  נגדיר חיבור וכפל בסקלר ב - $M_(m times n)(F)$:
  $
    mat(a_(1,1), doh, a_(1,n); dov, , dov; a_(m,1), doh, a_(m,n)) + mat(b_(1,1), doh, b_(1,n); dov, , dov; b_(m,1), doh, b_(m,n)) = mat(a_(1,1) + b_(1,1), doh, a_(1,n) + b_(1,n); dov, , dov; a_(m,1) + b_(m,1), doh, a_(m,n) + b_(m,n))
  $
  $
    c mat(a_(1,1), doh, a_(1,n); dov, , dov; a_(m,1), doh, a_(m,n)) = mat(c a_(1,1), doh, c a_(1,n); dov, , dov; c a_(m,1), doh, c a_(m,n))
  $
  #proof[
    ניתן להראות שכל האקסיומות מתקיימות, אבל זה ממש קל וממש משעמם, אז לא נעשה את זה. אז זו הוכחה על ידי "קל לראות ש -".
  ]
]
#example(title: text[דוגמה: פולינומים מעל $F$])[
  $
    V = F[x] = {a_n x^n + doh + a_1 x + a_0 so n in NN_+ and a_n, doh, a_0 in F and a_n != 0 } union {0}
  $
  נגדיר חיבור ב - $F[x]$ באופן הבא:

  אם $g = b_m x^m + doh + b_0$, $f = a_n x^n + doh + a_0$, נסמן:
  $ k = max({t in NN_+ so t <= max(n, k) and (a_k + b_k != 0)}) $ ונגדיר:
  $ f+ g = (a_k + b_k)x^k + doh + (a_1, b_1)x + a_0 + b_0 $
  כאשר $a_i = 0$ עבור $i>n$, $b_j = 0$ עבור $j > m$.

  נגדיר כפל בסקלר ב - $F[x]$ באופן הבא:

  אם $f = a_n x^n + doh + a_0$, $c in F$, אז $c f = c a_n x^n + doh + c a_0$.
  #proof[
    ניתן להראות שכל האקסיומות מתקיימות, אבל זה ממש קל וממש משעמם, אז לא נעשה את זה. אז זו הוכחה על ידי "קל לראות ש -".
  ]
]
#example[
  $ V = F^NN = {(a_1, a_2, doh) so forall i in NN: a_i in F} $
  נגדיר חיבור וכפל בסקלר ב - $F^NN$ באופן הבא:
  $ (a_1, a_2, doh) + (b_1, b_2, doh) = (a_1 + b_1, a_2 + b_2, doh) $
  $ c (a_1, a_2, doh) = (c a_1, c a_2, doh) $
  #proof[
    ניתן להראות שכל האקסיומות מתקיימות, אבל זה ממש קל וממש משעמם, אז לא נעשה את זה. אז זו הוכחה על ידי "קל לראות ש -".
  ]
]
#example[
  $ V = {0_V} $
  הגדרת הפעולות טריוויאלית (כי אנחנו יודעים מראש מה התוצאה לכל פעולה שהיא).
  #proof[
    ניתן להראות שכל האקסיומות מתקיימות, אבל זה ממש קל וממש משעמם, אז לא נעשה את זה. אז זו הוכחה על ידי "קל לראות ש -".
  ]
]
== תכונות של מרחבים וקטוריים
יהי $V$ מ"ו מעל שדה $F$.
#property[
  אם $w in V$ כך ש - $u+w = u$ לכל $u in V$, אז $w = 0_V$.
]
#property[
  אם $u,v in V$ כך ש - $u + v = 0_V$, אז $v = -u$.
]
#property[
  $c 0_V = 0_V$
  לכל $c in F$.
]
#property[
  $0 u = 0_V$
  לכל $u in V$.
]
#property[
  $(-1) u = -u$
  לכל $u in V$.
]
#property[
  אם $c u = 0_V$, אז $c = 0$ או $u = 0_V$.
]
== תת-מרחבים
#definition[תת-מרחב וקטורי
  #footnote[
    בקיצור, פשוט תת-מרחב.
  ]
][
  יהי $V$ מ"ו מעל שדה $F$. תת-קבוצה $U$ של $V$ נקראת תת-מרחב
  אם מתקיימות התכונות הבאות #footnote[כלומר, כאשר מתקיים *באמצעות החיבור והמכפלה בסקלר שהוגדרו על $V$*, לא עבור פעולה חדשה כלשהי.]:
  #property[][
    $0_V in u$
  ] <subspace-property-1>
  #property[סגירות ביחס לחיבור][
    לכל $u,v in U$ מתקיים $u+v in U$.
  ] <subspace-property-2>
  #property[סגירות ביחס למכפלה בסקלר][
    לכל $c in F$, $u in U$, מתקיים $c u in U$.
  ] <subspace-property-3>
]
#property[
  אם $U$ הוא תת-מרחב של מ"ו $V$, אז $U$ בעצמו מ"ו מעל אותו השדה.
  #proof[
    בזכות @subspace-property-2, @subspace-property-3, האקסיומות @vector-space-axiom-1, @vector-space-axiom-2 @vector-space-axiom-5, @vector-space-axiom-6, @vector-space-axiom-7, @vector-space-axiom-8 מתקיימות באופi טריוויאלי. בזכות @subspace-property-1 גם אקסיומה @vector-space-axiom-3 מתקיימת. נשארה רק @vector-space-axiom-4.

    יהי $u in U$. אז בזכות @subspace-property-3 מתקיים $-u = (-1) u in U$. לכן אקסיומה @vector-space-axiom-4 מתקיימת.
  ]
]
#example(title: "דוגמה: תת-מרחבים טריוויאליים.")[
  יהי $V$ מ"ו כלשהו. אז $V$ הוא תת-מרחב של $V$, וגם ${0_V}$ הוא תת-מרחב של $V$.
]
#informal[
  בדוגמה הבאה, נוכל לחשוב על מערכת צירים דו-ממדית בתור המרחב הווקטורי, ועל ציר ה-$x$ בתור תת-מרחב (וזה לא קשור לדוגמה, אבל האמת שגם רק ראשית הצירים לבד היא תת-מרחב. כלומר כל כמות מימדים שמוכלת במרחב המקורי היא תת-מרחב).
  #import "@preview/cetz:0.4.2": canvas, draw

  #canvas(length: 1cm, {
    import draw: *

    // Colors
    let accent = rgb("#4a7bd1")
    let bg = rgb("#eef3fc")

    // Coordinate range
    let x-min = -4.5
    let x-max = 4.5
    let y-min = -2.8
    let y-max = 2.8

    // Very light background for the whole coordinate system
    rect(
      (x-min, y-min),
      (x-max, y-max),
      fill: bg,
      stroke: none,
      radius: 0.12,
    )

    // y-axis
    line(
      (0, y-min),
      (0, y-max),
      stroke: (paint: black, thickness: 1.1pt),
      mark: (
        end: (
          symbol: "stealth",
          fill: black,
        ),
      ),
    )

    // x-axis — prominently highlighted
    line(
      (x-min, 0),
      (x-max, 0),
      stroke: (
        paint: accent,
        thickness: 2.8pt,
      ),
      mark: (
        end: (
          symbol: "stealth",
          fill: accent,
        ),
      ),
    )

    // Origin halo
    circle(
      (0, 0),
      radius: 0.18,
      fill: bg,
      stroke: (paint: accent, thickness: 1.5pt),
    )

    // Origin point
    circle(
      (0, 0),
      radius: 0.055,
      fill: accent,
      stroke: none,
    )

    // x label
    content(
      (x-max - 0.15, 0),
      $x$,
      anchor: "north",
      fill: accent,
    )

    // y label
    content(
      (0, y-max + 0.05),
      $y$,
      anchor: "south",
    )

    // Origin label
    content(
      (0.25, -0.28),
      $0_V$,
      anchor: "north-west",
      fill: accent,
    )
  })
]
#example[
  ניקח את $V = F^2$, $U = {vec(x_1, x_2) in F^2 so x_2 = 0}$.
  #proof[
    נוכיח שכל אחת משלושת התכונות מתקיימות.
    + @subspace-property-1: $0_(F^2) = vec(0, 0) in U$.
    + @subspace-property-2:
    אם $u,v in U$, נסמן $u = vec(x_1, x_2)$, $v = vec(y_1, y_2)$, ואז $x_2 = y_2 = 0$. מכאן:
    $
      u+ v = vec(x_1, x_2) + vec(y_1, y_2) = vec(x_1 + y_1, x_2 + y_2) = vec(x_1 + y_1, 0 + 0) = vec(x_1 + y_1, 0) in U
    $
    3. @subspace-property-3: אם $u in U$, $c in F$, נסמן $u = vec(x_1, x_2)$, ואז $x_2 = 0$. מכאן:
    $
      c u = c vec(x_1, x_2) = vec(c x_1, c x_2) = vec(c x_1, 0 c) = vec(c x_1, 0) in U
    $
  ]
]
#informal[

  נשים לב, למרות שכל ציר בנפרד הוא תת-מרחב, שניהם ביחד אינם תת-מרחב: התכונה @subspace-property-2 לא מתקיימת, כי יש איברים בצירים שאפשר לחבר, והתוצאה לא נמצאת בצירים, כמו בתמונה הבאה.

  #let now = datetime.today()
  #let seed = now.year() * 10000 + now.month() * 100 + now.day()

  #cetz.canvas({
    import cetz.draw: *

    // ---------------------------------------------------------------
    // Colors
    // ---------------------------------------------------------------

    let accent = rgb("#4a7bd1")
    let background = rgb("#f4f7fd")
    let guide = rgb("#b9c9e8")

    // ---------------------------------------------------------------
    // Coordinate range
    // ---------------------------------------------------------------

    let x-min = -4.5
    let x-max = 4.5
    let y-min = -3.0
    let y-max = 3.0

    // ---------------------------------------------------------------
    // Random points
    // ---------------------------------------------------------------

    let rng = gen-rng-f(seed)

    // Keep both points comfortably away from the edges.
    // u lies on the x-axis, v lies on the y-axis.
    let (rng, values) = uniform-f(
      rng,
      low: 1,
      high: 2,
      size: 2,
    )

    let u = values.at(0)
    let v = values.at(1)

    // Point with x-coordinate u and y-coordinate v.
    let uv = (u, v)

    // ---------------------------------------------------------------
    // Background
    // ---------------------------------------------------------------

    rect(
      (x-min, y-min),
      (x-max, y-max),
      fill: background,
      stroke: none,
    )

    // ---------------------------------------------------------------
    // Axes
    // ---------------------------------------------------------------

    // x-axis
    line(
      (x-min, 0),
      (x-max, 0),
      stroke: (
        paint: accent,
        thickness: 2.8pt,
      ),
      mark: (
        end: (
          symbol: "stealth",
          fill: accent,
        ),
      ),
    )

    // y-axis
    line(
      (0, y-min),
      (0, y-max),
      stroke: (
        paint: accent,
        thickness: 2.8pt,
      ),
      mark: (
        end: (
          symbol: "stealth",
          fill: accent,
        ),
      ),
    )

    // ---------------------------------------------------------------
    // Projection lines
    // ---------------------------------------------------------------

    line(
      (u, 0),
      uv,
      stroke: (
        paint: guide,
        thickness: 1pt,
        dash: "dashed",
      ),
    )

    line(
      (0, v),
      uv,
      stroke: (
        paint: guide,
        thickness: 1pt,
        dash: "dashed",
      ),
    )

    // ---------------------------------------------------------------
    // Highlighted-point helper
    // ---------------------------------------------------------------

    let highlight-point(p) = {
      // Outer ring
      circle(
        p,
        radius: 0.20,
        fill: white,
        stroke: (
          paint: accent,
          thickness: 1.5pt,
        ),
      )

      // Center
      circle(
        p,
        radius: 0.06,
        fill: accent,
        stroke: none,
      )
    }

    // Origin
    highlight-point((0, 0))

    // u on x-axis
    highlight-point((u, 0))

    // v on y-axis
    highlight-point((0, v))

    // u + v = (u, v)
    highlight-point(uv)

    // ---------------------------------------------------------------
    // Labels
    // ---------------------------------------------------------------

    // Origin
    content(
      (0.25, -0.32),
      $0_V$,
      anchor: "north-west",
      fill: accent,
    )

    // u
    content(
      (u, -0.32),
      $u$,
      anchor: "north",
      fill: accent,
    )

    // v
    content(
      (-0.25, v),
      $v$,
      anchor: "east",
      fill: accent,
    )

    // u + v
    content(
      (u + 0.25, v + 0.22),
      $u + v$,
      anchor: "south-west",
      fill: accent,
    )

    // Axis labels
    content(
      (x-max + 0.12, 0),
      $x$,
      anchor: "west",
      fill: accent,
    )

    content(
      (0, y-max + 0.12),
      $y$,
      anchor: "south",
      fill: accent,
    )
  })
]

#todo[*להשלים את הסוף של השיעור הזה*.]

#corollary[
    תהי $A in M_(m times n) (F)$. נתבונן בממ"ל ההומוגנית $ (*) quad A x = vec(0, dov, 0) $
    אז קבוצת הפתרונות של $(*) $ היא תת-מרחב של $F^n$.
]
#proposition[
    יהי $V$ מ"ו מעל $F$. יהיו $U, W$ תת-מרחבים של $V$. אז $U inter V$ הוא גם תת-מרחב של $V$.
    #proof[
        נבדוק שכל התכונות של תת-מרחבים מתקיימות:
        - @subspace-property-1: $0_V in U and 0_V in W => 0_V in  U inter W$
        - ‏ @subspace-property-2: אם $u,v in U inter W$, אז $u, v in U$ וגם $u, v in W$, מכאן $u+v in U$ וגם $u + v in W$, ולכן $u + v in U inter W$.
        - ‏ @subspace-property-3 אם $v in U inter W$, $c in F$, אז $v in U$ וגם $v in W$, מכאן $c v in U$ וגם $c v in W$, לכן $c v in U inter W$.
    ]
]
#informal[
    כמו שראינו בפעם הקודמת שהיה ריבוע אפור כזה, איחוד של תת-מרחבים הוא לא בהכרח תת-מרחב.
]
#proposition[
    יהי $V$ מ"ו מעל $F$. $U$ תת-מרחב של $V$, $v_1, doh, v_n in U$, $c_1, doh, c_n in F$, אז $c_1 v_1 + doh + c_n v_n in U$.
    
    כלומר, כל צירוף ליניארי של #nvs מתת-המרחב וסקלרים מהשדה, הוא גם בתת-המרחב.
    #proof[
        בזכות @subspace-property-3 מתקיים $c_1 v_1, doh, c_n v_n in U$, ובזכות @subspace-property-2 מתקיים $c_1 v_1 + doh + c_n v_n in U$.
    ]
] <subspace-prop-linear-combination>
== פרוש
#definition[
    יהי $V$ מ"ו מעל $F$, $emptyset != S subset.eq V$. הפרוש של $S$ מוגדר ע"י:
$ "Span" S = { c_1 v_1 + doh + c_n v_n whe  n in NN, c_1, doh, c_n in F, v_1, doh, v_n in S } $
בנוסף נגדיר $"Span" emptyset = {0_V }$. 
]
#proposition[
    יהי $V$ מ"ו מעל $F$, $S subset.eq V $, אז $"Span" S$ הוא תת-מרחב של $V$. 
    #proof[
        אם $S = emptyset$, אז הכל ברור #footnote[#emoji.sparkles #emoji.sparkles #emoji.sparkles]. אז תהי $S != emptyset$. אז:
        + @subspace-property-1: קיים $v in S$. אז עבור $c = 0$ נקבל $0_V = 0 dot v = c v in "Span" S$. 
        + @subspace-property-2: יהיו $u,v in "Span" S$. אז קיימים $m in NN$, $c_1,doh, c_m in F$, $u_1, doh, u_m in S$, כך ש - $u = c_1 u_1 + doh + c_, u_,$. בנוסף קיימים $n in NN$, $d_1, doh d_n in F$, $v_1, doh, v_n in S$ כך ש - $v = d_1 v_1 + doh + d_n v_n$. מכאן $u + v = c_1 u_1 + doh + c_m u_m + d_1 v_1 + doh + d_n v_n in "Span" S$.
        + ‏@subspace-property-3: $u in "Span" S, c in F$. אז קיים $n in NN$, $c_1, doh, c_n in F$, $u_1, doh, u_n in S$, כך ש - $u = c_1 u_1 + doh + c_n u_n$. אז $c u = (c c_1) u_1 + doh + (c c_n) u_n in "Span"$.
        
    ]
]
#property[
    יהי $V$ מ"ו מעל $F$, $S subset.eq V$. אז $S subset.eq "Span" S$.
    #proof[
 יהי $v in S$. עבור $c = 1$ נקבל $v = 1v = c v in "Span" S$.
    ]
] <span-property-1>
#property[תכונה עיקרית של פרוש][
    יהי $V$ מ"ו מעל $F$, $S subset.eq V$. יהי $U$ תת-מרחב של $V$ כך ש - $S subset.eq U$. אז $"Span" S subset.eq U$. 
    #proof[
        יהי $u in "Span" S$. קיימים $n in NN$, $c_1, doh, c_n in F$, $v_1, doh, v_n in S$, כך ש - $u = c_1 v_1 + doh + c_n v_n$. מאחר ש - $S subset.eq U$ מתקיים $v_1, doh, v_n in U$. אז לפי @subspace-prop-linear-combination מתקיים $u = c_1 v_1 + doh + c_n v_n in U$.
    ]
] <span-property-2>
#informal[
    אם נסתכל על הפרוש כעל קבוצת נקודות, הוא פשוט המרחב הרב-ממדי שנוצר מכל הווקטורים בתת-המרחב ההווקטורי.
    #todo[
        ליצור תמונה.
    ]
]
#property[
    יהי $V$ מ"ו מעל $F$, $S$ תת-מרחב של $V$. אז $"Span" S = S$.
    #proof[
        לפי @span-property-1, מתקיים $S subset.eq "Span" S$. נוכיח כי $"Span" S subset.eq S$. יהי $u in "Span" S$. אז קיימים $n in NN$, $c_1, doh, c_n in F$, $v_1, doh, v_n in S$ כך ש - $u = c_1 v_1 + doh c_n v_n$. מאחר ש - $S$ ,תת-מרחב, לפי @span-property-2 מתקיים $u = c_1 v_1 + doh + c_n v_n in S$.
    ]
    #proof[
        מאחר ש - $S$ הוא תת-מרחב וגם $S subset.eq S$, לפי @span-property-2 מתקיים $"Span" S subset.eq S$.
    ]
]
#property[
    יהי $V$ מ"ו מעך $F$, ותהיינה $S_1, S_2 subset.eq V$, כך ש - $S_1 subset.eq S_2$. אז $"Span" S_1 subset.eq "Span" S_2$.
    #proof[
        יהי $u in "Span" S_1$. אז קיים $n in NN$, $c_1, doh, c_n in F$, $v_1, doh, v_n in S_1$, כך ש - $u = c_1 v_1 + doh + c_n v_n$. מאחר ש - $S_1 subset.eq S_2$ מתקיים $v_1, doh, v_n in S_2$. מכאן $u = c_1 v_1 + doh + c_n v_n in "Span" S_2$.
    ]
    #proof[
        מתקיים $S_1 subset.eq S_2 subset.eq "Span" S_2$. בנוסף $"Span" S_2$ הוא תת-מרחב. אז לפי @span-property-2 מתקיים $"Span" S_1 subset.eq "Span" S_2$.
    ]
]
#proposition[
    יהי $V$ מ"ו מעל $F$, ויהיו $s_1, doh, s_k in V$ שונים זה מזה. נסמן $S = {s_1, doh, s_k}$. אז $"Span" S = {c_1 s_1 + doh + c_k s_k whe c_1 doh c_k in F }$.
    #proof[
        נסמן $U = {c_1 s_1 + doh + c_k s_k whe c_1, doh, c_k in F}$. אז $U subset.eq "Span" S$, כי לכל $u in U$ קיימים $c_1, doh, c_k in F$ כך ש - $u = c_1 s_1 + doh + c_k s_k$. מאחר ש - $s_1, doh, s_k in S$, מתקיים $u = c_1 s_1 + doh + c_k s_k in "Span" S$. כדי להוכיח ש - $"Span" S subset.eq U$, נוכיח כי $S subset.eq U$ וגם $U$ הוא תת-מרחב. לכל $i in [k]$ נגדיר $c_1 = doh = c_(i-1) 
        = c_(i+1) = doh = c_k = 0, c_i = 1$. אז $s_i = 1 dot s_i = c_1 s_1 + doh + c_k s_k in U$. לכן $S subset.eq  U$. נגדיר $c_1 = doh = c_k = 0$. אז $0_V = c_1 s_1 + doh + c_k s_k in U$. יהיו $u, v in U$. אז קיימים $c_1, doh, c_k, d_1, doh, d_k in F$ כך ש - $u = c_1 s_1 + doh + c_k s_k, v = d_1 s_1 + doh + d_k s_k$. אז $u + v = c_1 s_1 + doh + c_k s_k + d_1 s_1 + doh + d_k s_k = (c_1 + d_1) s_1 + doh + (c_k + d_k) s_k in U$. יהיו $u in U, c in F$. אז קיימים $c_1, doh, c_k in F$ כך ש - $u = c_1 s_1 + doh + c_k s_k$. אז $c u = c(c_1 s_1 + doh + c_k s_k) = (c c_1) s_1 + doh + (c c_k) s_k in U$. לפיכך $U$ הוא תת-מרחב. לכן לפי @span-property-2, מתקיים $"Span" S subset.eq U$.    ]
]
#definition[
    יהי $V$ מ"ו מעל $F$. סדרה באורך $k$ של וקטורים מ -$V$ היא סדרה מהצורה $(s_1, doh, s_k)$ כאשר $s_i in V$ לכל $i in [k]$.
]
#definition[
    יהי $V$ מ"ו מעל $F$, $(s_1, doh, s_k)$ סדרה של וקטורים מ - $V$. נגדיר $"Span" (s_1, doh, s_k) = "Span" {S_1, doh, S_k}$
]
#env-list(title: "דוגמאות", numbered: true, 
    example[
    יהי $V$ מ"ו מעל $F$, $v in V$. אז $"Span"(v) = {a v whe a in F}$.
    #todo[
        ליצור תמונה. אלו בעצם כל הווקטורים שתלויים ליניארית בווקטור.
    ]    
    ],
    example[
        יהי $V = F^n$. אז:
        $ "Span"(e_1, e_2, doh, e_n) = F^n $
        #proof[
            יהי $vec(c_1, dov, c_n) in F^n$. אז:
            $ vec(c_1, dov, c_n) = c_1 e_1 + doh + c_n e_n in "Span" (e_1, doh, e_n) $
        ]
    ]
)
#divider()
#proposition[
    תהי $A in M_(m times n) (F)$. נסמן את העמודות של $A$ ב - $C_1, doh, C_n in F^m$. יהי $b in F^m$. אז לממ"ל $A x = b$ יש פתרון אמ"מ $b in "Span" (C_1, doh, C_n)$.
    #proof[
        $(⁦arrow.l.double⁩)$ יהי $d = vec(d_1, dov, d_n) in F^n$ פתרון של $A x = b$. אז $b = A d = d_1 C_1 + doh + d_n C_n in "Span"(C_1, doh, C_n)$.
        
         $(=>)$ מאחר ש - $b in "Span"(C_1, doh, C_n)$, קיים $d_1, doh, d_n in F$ כך ש - $b = d_1 C_1 + doh + d_n C_n = A vec(d_1, dov, d_n)$. לכן $vec(d_1, dov, d_n)$ הוא פתרון של ממ"ל $A x = b$. 
    ]
]
#proposition[
    יהי $C_1, doh, C_n in F^m$. נסמן ב - $A$ את המטריצה $m times n$ כך שהעמודה ה - $i$ שלה היא $C_i$. אז $"Span"(C_1, doh, C_n) = {b in F^m whe exists x in F^m: A x = b} $.
    #proof[
        $(subset.eq)$
        יהי $b in "Span"(C_1, doh, C_n)$. לכן לפי הטענה הקודמת, לממ"ל $A x = b$ קיים פתרון. 
        
        $(supset.eq)$
        יהי $b in F^m$ כך שלממ"ל $A x = b$ קיים פתרון. אז לפי הטענה הקודמת $b in "Span"(C_1, doh, C_n)$.
    ]
]
