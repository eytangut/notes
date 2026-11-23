#import "preamble.typ": *
#show: hw-setup.with(course: "אלגברה ליניארית 1", number: "7", name: "איתן גוטרייך")

= תרגיל 7

== שאלה 1
#problem[
    מצאו בסיס לחיתוך של תת-המרחבים $U,W$ של $RR^4$, כאשר:
    $ U = {vec(x_1, x_2, x_3, x_4) in RR^4 whe cases(x_1 + x_2 - x_3 = 0, x_1 - x_4 = 0)}, quad W = {vec(x_1, x_2, x_3, x_4) in RR^4 whe cases(x_1 + x_4 = 0, 3x_1 - x_2 - x_3 = 0)} $
]

== שאלה 2
#problem[
    מצאו בסיס לתת-המרחב $U inter W$ של $RR^4$, כאשר:
    $ U = Span({vec(1,1,1,1),vec(1,2,2,1)}), quad W = {vec(x_1, x_2, x_3, x_4) in RR^4 whe x_1 + x_2 + x_3 - x_4 = 0} $
]

== שאלה 3
#problem[
    נתבונן ב - $RR^RR$ כמרחב וקטורי מעל $RR$. הפונקציות $f,g,h in RR^RR$ מוגדרות באופן הבא:
    $ f(x) = 1, quad g(x) = (x-1)(x+1), quad h(x) = x^2 (x+1) $
    יהיו $U,W$ תת-המרחבים של $RR^RR$ המוגדרים ע"י:
    $ U = Span({f, g, h}), quad W = {q in RR^RR whe q(0) = q(1)} $
    מצאו בסיס ל - $UU inter WW$.
]

== שאלה 4
#problem[
    תהי $S = (vec(1,2,0,3), vec(-1,-2,1,1), vec(-1,2,2,5))$ סדרה של וקטורים ב - $RR^4$. מצאו ממ"ל כך ש - $Span(S)$.
]
