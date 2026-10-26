#import "preamble.typ": *
#show: setup
// END preamble
= תרגיל 2 - אלגברה ליניארית
#exercise(title: "== תרגיל 3")[
  3. יהי $FF$ שדה, ויהיו $a,b in FF$. הוכיחו או הפריכו:

    א. אם $a^2 = b^2$ אזי בהכרח $a = b$ או $a = -b$.

    ב. אם $a^2 + b^2 = (2 + b^2)$ אזי בהכרח $b = 0_FF$ או $a = 0_FF$.
]
[
א.
$ a^2 = b^2 => a^2 - b^2 = 0 => (a+b)(a-b) = 0 $
והוכחנו בשיעור שאם $u v =0_FF$ אז או ש- $u = 0_FF$ או ש - $v = 0_FF$. לכן במקרה שלנו:
$ (a+b = 0) or (a-b = 0) => (a = -b) or (a = b) quad quad qed $
ב.
אנחנו יודעים ש:
$ (a+b)^2 = a^2 + b^2 + 2 a b $
לכן הטענה היא בעצם:
$ a^2 + b^2 + 2a b = a^2 + b^2 $
נצמצם, ונקבל:
$ 2 a b = 0 => a b = 0 $
ואנחנו יודעים שזה אומר ש - $a=0$ או $b=0$, שזה בדיוק מה שרצינו להוכיח.
]

#pagebreak()
#exercise(title: "== תרגיל 4")[
  הראו שאקסיומת קיבוציות הכפל מתקיימת במספרים המרוכבים.
]
[
$ a,b,c in CC => exists a_r, a_i, b_r, b_i, c_r, c_i in RR: $
$ (a b) c = ((a_r + i a_i)(b_r + i b_i)) (c_r + i c_i) = (a_r b_r - a_i b_i + i a_i b_r + i b_i a_r)(c_r + i c_i) = $
$ a_r b_r c_r -a_i b_i c_r + i a_i b_r c_r + i b_i a_r c_r + i a_r b_r c_i - i a_i b_i c_i - a_i b_r c_i - b_i a_r c_i $
$ a (b c) = (a_r + i a_i) ((b_r + i b_i) (c_r + i c_i)) = (a_r + i a_i) (b_r c_r - b_i c_i + i b_i c_r + i c_i b_r) = $
$ a_r b_r c_r - a_r b_i c_i + i a_r b_i c_r +i a_r c_i b_r + i a_i b_r c_r - i a_i b_i c_i - a_i b_i c_r - a_i c_i b_r $
לפי הקומוטטיביות של החיבור והכפל, נשנה את סדר האיברים:
$ a_r b_r c_r - a_i b_i c_r + i a_i b_r c_r + i b_i a_r c_r +i a_r b_i c_i - i a_i b_i c_i - a_i b_r c_i - b_i a_r c_i $
וזה בדיוק אותו ביטוי. לכן הביטויים האלו שווים, כלומר $(a b)c = a(b c)$, כלומר האקסיומה נכונה. ]
#pagebreak()
#exercise(title: "== תרגיל 5")[
  א. חשבו את שארית החלוקה של $45^47 + 46^46 + 47^45$ ב - $23$.

  ב. חשבו את שארית החלוקה של $10^11 + 1011^10$ ב - $101$.

  ג. חשבו את שארית החלוקה של $170^170$ ב - $7$.
]
[

א)
$
  47^45 + 46^46 + 45^47 = (2 dot 23 + 1)^45 + (2 dot 23)^46 + (2 dot 23 - 1)^47 equiv 1^45 + 0^46 + (-1)^47 = 1 + 0 -1 = 0 (mod 23)
$
ב)
$ 10^11 + 1011^10 = 100^5 dot 10 + (101 dot 10 + 1)^10 equiv (-1)^5 dot 10 + 1^10 = -10 + 1 = -9 equiv 92 (mod 101) $
ג)
$ 170^170 = (7 dot 24 + 2)^170 equiv 2^170 = (2^3)^56 dot 2^2 = 4 dot (7+1)^56 equiv 4 dot 1^56 = 4 (mod 7) $
]
#pagebreak()
#exercise(title: "== תרגיל 6")[
  בכל סעיף, מצאו את כל המספרים השלמים $x in ZZ$ אשר מקיימים את המשוואה.

  א. $ 10x equiv 7 (mod 11) $

  ב. $ 10x equiv 7 mod 15 $

  ג. $ 10x equiv 7 (mod 19) $
]
[
א.
$ 10x equiv -1x equiv 7 equiv -4 mod 11 => x equiv 4 mod 11 $
ב.

ג.
$ 10x equiv -9x equiv 7 equiv -12 => 3x equiv 4 equiv -15 => x equiv -5 equiv 14 mod 19 $
]
#pagebreak()

#exercise(title: "== תרגיל 7")[
  בכל סעיף נתון מספר טבעי $n in NN$. מצאו את כל המספרים ב - $ZZ/n$ אשר יש להם הופכי מודולו $n$.

  א. $ n = 7 $.

  ב. $ n = 12 $.
]
#pagebreak()
#exercise(title: "== תרגיל 8")[
  א. יהי $n in NN$ מספר אי-זוגי (כלומר קיים $k in NN$ כך ש - $n = 2k + 1$). הראו כי ל - 2 יש הופכי מודולו $n$ ומצאו אותו.

  ב. יהי $n in NN$ מספר זוגי (כלומר קיים $k in NN$ כך ש - $n = 2k$). הראו כי ל - $2$ אין הופכי מודולו $n$.
]
#pagebreak()
#exercise(title: "== תרגיל 9")[
  יהי $p in NN$ ראשוני אי-זוגי. הראו שלמשוואה $x^2 = 1$ יש בדיוק שני פתרונות מעל $FF_p$, ומצאו אותם.
]
#pagebreak()
#exercise(title: "== תרגיל 10")[
  א. פתרו את המשוואה $5x = 2$ מעל השדה $FF_7$.

  ב. פתרו את המשוואה $6x = 1$ מעל השדה $FF_11$.
]
#pagebreak()
#exercise(title: "== תרגיל 11")[
  פתרו את מערכת המשוואות הבאה, מעל השדה $FF$ הנתון בכל אחד מהסעיפים:
  $
    cases(
      x_1 + x_2 = 1,
      x_2 + x_3 = 0,
      x_1 + x_3 = 1
    )
  $
  א. $FF = FF_2$.

  ב. $FF = FF_3$
]
