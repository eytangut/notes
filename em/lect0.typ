#import "preamble.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#show: setup
#let dif(x) = $upright(d)#x thin$
// END preamble
// Course structure:
// = חשמל ומגנטיות
// == אלקטרוסטטיקה
// === חוק קולון
// === שדה חשמלי
// === חוק גאוס
// === שדה משמר
// === מוליכים
// === דיאלקטרים
// === קבלים
// == מגנטוסטטיקה
// === זרם
// === כוח מגנטי (חוק ביו-סבר)
// === שדה מגנטי
// === חוק אמפר
// == מבוא לאלקטרומגנטיות
// === חוק פאראדיי
#todo[
    Add a cover page, which contains all of the figures used (Or, if there is a absurd number, a random subset, but aim for it to work with big yet normal numbers without looking horrible), randomly rotated and scaled and colored (Use a random number generator seeded with the data, as this is the only entropy in Typst). The figures should all be faded to make the text on the cover page readable. They may be non-uniformaly faded, to blend with each other.
]
= חשמל ומגנטיות
== אלקטרוסטטיקה
=== חוק קולון
==== חזרה על השיעור הקודם
#todo[
    Refactor all figures to a differant files, and reference them here, to avoid mess.
]
חוק קולון, השדה של מטען נקודתי $q$ בראשית הצירים:

$ arrow(E)(arrow(r)) = k q/(r^2) hat(r) quad quad k = 1/(4 pi epsilon_0) $

ובכלל, עבור פיזור מטען כלשהו:

$ arrow(E)(arrow(r)) = k integral (arrow(r) - arrow(r)')/(|arrow(r) - arrow(r)'|^3) dif(q') $

כאשר אלמנט המטען נקבע לפי סוג הפיזור (נפחי, משטחי או קווי):

$ dif(q') = cases(
  rho(arrow(r)') dif("Vol'"),
  sigma(arrow(r)') dif(a'),
  lambda(arrow(r)') dif(l')
) $

==== תרגיל: שדה של מעטפת כדור

פתרון התרגיל מהשיעור הקודם: השדה של מעטפת כדור דקה ברדיוס $R$ וצפיפות מטען משטחית אחידה $sigma$, בנקודה $P$ על ציר $z$, במרחק $z$ מהמרכז.

$ dif(q') = sigma R^2 sin(theta) dif(phi) dif(theta) $

===== הגיאומטריה

ממבט מהצד. הטבעת המנוקדת היא כל הנקודות על המעטפת עם אותו $theta$, ועליה רץ אינטגרל ה-$phi$. $arrow(r)'$ הוא מיקום אלמנט המטען, ו-$P$ היא נקודת השדה, $arrow(r) = z hat(z)$:

#align(center, canvas({
  import draw: *
  let R = 1.5
  let z = 3.6
  let th = 50deg
  // הנקודה על המעטפת, ב-phi = 0
  let q = (R * calc.sin(th), R * calc.cos(th))
  // המעטפת, כמו שרואים אותה מהצד
  circle((0, 0), radius: R, stroke: 1.2pt)
  // הטבעת של theta קבוע
  circle((0, q.at(1)), radius: (q.at(0), 0.25 * q.at(0)), stroke: (dash: "dotted"))
  // ציר z והנקודה P
  line((0, 0), (0, z))
  circle((0, z), radius: 0.05, fill: black)
  content((0, z), $P$, anchor: "south", padding: 4pt)
  content((0, 2.6), $z$, anchor: "east", padding: 4pt)
  // הרדיוס אל הנקודה על המעטפת, והקו ממנה אל P
  line((0, 0), q)
  circle(q, radius: 0.05, fill: black)
  content((q.at(0) / 2, q.at(1) / 2), $R$, anchor: "north-west", padding: 3pt)
  content(q, $arrow(r)'$, anchor: "west", padding: 4pt)
  line(q, (0, z), stroke: (dash: "dashed"))
  content((q.at(0) / 2, (q.at(1) + z) / 2), $arrow(r) - arrow(r)'$, anchor: "west", padding: 4pt)
  // הזווית theta
  line(..range(11).map(i => {
    let t = 90deg - th + i * th / 10
    (0.35 * calc.cos(t), 0.35 * calc.sin(t))
  }))
  content((0.62 * calc.cos(90deg - th / 2), 0.62 * calc.sin(90deg - th / 2)), $theta$)
}))

$ arrow(r)' = R sin(theta) cos(phi) hat(x) + R sin(theta) sin(phi) hat(y) + R cos(theta) hat(z) $

$ arrow(r) - arrow(r)' = -R sin(theta) cos(phi) hat(x) - R sin(theta) sin(phi) hat(y) + (z - R cos(theta)) hat(z) $

$ |arrow(r) - arrow(r)'|^3 &= (R^2 sin^2(theta) + z^2 + R^2 cos^2(theta) - 2 z R cos(theta))^(3/2) \
  &= (R^2 + z^2 - 2 z R cos(theta))^(3/2) $

===== האינטגרל

$ arrow(E)(z) = k integral_0^pi integral_0^(2pi) (sigma R^2 sin(theta) (-R sin(theta) cos(phi) hat(x) - R sin(theta) sin(phi) hat(y) + (z - R cos(theta)) hat(z)))/((R^2 + z^2 - 2 z R cos(theta))^(3/2)) dif(phi) dif(theta) $

אינטגרל ה-$phi$ מאפס את רכיבי $hat(x), hat(y)$, ולכן:

$ arrow(E)(z) = k sigma R^2 2 pi integral_0^pi (sin(theta) (z - R cos(theta)))/((R^2 + z^2 - 2 z R cos(theta))^(3/2)) dif(theta) hat(z) $

===== הצבה

$ u = R^2 + z^2 - 2 z R cos(theta) $

$ dif(u) = 2 z R sin(theta) dif(theta) quad ==> quad dif(u)/(2 z R) = sin(theta) dif(theta) $

$ R cos(theta) = (R^2 + z^2 - u)/(2 z) $

$ theta = 0 ==> u = (R - z)^2 quad quad theta = pi ==> u = (R + z)^2 $

===== חישוב

$ 1/(2 z R) integral_((R-z)^2)^((R+z)^2) (z - (R^2 + z^2 - u)/(2 z))/(u^(3/2)) dif(u)
  &= 1/(4 z^2 R) integral_((R-z)^2)^((R+z)^2) (z^2 - R^2 + u)/(u^(3/2)) dif(u) \
  &= 1/(4 z^2 R) ((z^2 - R^2) (-2/sqrt(u)) + 2 sqrt(u)) mid(|)_((R-z)^2)^((R+z)^2) \
  &= 1/(2 z^2 R) (sqrt(u) - (z^2 - R^2)/sqrt(u)) mid(|)_((R-z)^2)^((R+z)^2) \
  &= 1/(2 z^2 R) (R + z - (z^2 - R^2)/(R + z) - (|R - z| - (z^2 - R^2)/(|R - z|))) \
  &= 1/(2 z^2 R) (2 R - cases(
    R - z + (z + R) quad quad & 0 <= z < R,
    z - R - (z + R) quad quad & R < z
  )) $

$ = cases(
  0 quad quad & 0 <= z < R,
  2/(z^2) quad quad & z > R
) $

===== תוצאה

$ arrow(E)(z) = k sigma R^2 2 pi dot 2/(z^2) hat(z) = (k hl(4 pi R^2 sigma))/(z^2) hat(z) quad quad z > R $

כלומר בתוך המעטפת השדה מתאפס, ומחוצה לה הוא כמו השדה של מטען נקודתי השווה למטען הכולל $Q = 4 pi R^2 sigma$, המרוכז במרכז. בגלל הסימטריה הכדורית זה נכון בכל כיוון, כש-$z$ הוא המרחק מהמרכז. באיור קווי השדה עבור $sigma > 0$ (עבור $sigma < 0$ כיוונם הפוך).

#align(center, canvas(length: 1cm, {
  import draw: *
  let R = 1.35
  circle((0, 0), radius: R, stroke: 1.2pt)
  // בתוך המעטפת אין שדה
  content((0, 0), $arrow(E) = 0$)
  // קווי שדה רדיאליים מחוץ למעטפת עבור sigma חיובי
  for i in range(8) {
    let a = i * 45deg
    line((1.65 * calc.cos(a), 1.65 * calc.sin(a)), (2.4 * calc.cos(a), 2.4 * calc.sin(a)), mark: (end: ">", fill: black))
  }
  content((2.4, 0), $arrow(E)$, anchor: "west", padding: 4pt)
}))

את התוצאה הזו גילה ניוטון עוד לפני שהכירו את חוק קולון, עבור כוח הכבידה, שדועך גם הוא כמו $1/r^2$.

==== תרגיל: שדה של דיסקה

לחשב את השדה החשמלי של דיסקה דקה ברדיוס $R$ וצפיפות מטען משטחית אחידה $sigma$, בנקודה $P$ שמעל מרכז הדיסקה, במרחק $z$ ממנה. בקואורדינטות גליליות אלמנט השטח הוא $dif(a') = r dif(phi) dif(r)$. הגיאומטריה:

#align(center, canvas({
  import draw: *
  // הדיסקה, כמו שרואים אותה מהצד
  circle((0, 0), radius: (2, 0.6), fill: luma(230))
  // הנקודה P מעל המרכז, במרחק z
  line((0, 0), (0, 2))
  circle((0, 2), radius: 0.05, fill: black)
  content((0, 1), $z$, anchor: "east", padding: 4pt)
  content((0, 2), $P$, anchor: "south", padding: 4pt)
  // אלמנט שטח Q במרחק r מהמרכז, והקו ממנו אל P
  line((0, 0), (1.2, -0.25))
  circle((1.2, -0.25), radius: 0.05, fill: black)
  content((0.6, -0.125), $r$, anchor: "north", padding: 3pt)
  line((1.2, -0.25), (0, 2), stroke: (dash: "dashed"))
  content((0.6, 0.875), $arrow(r) - arrow(r)'$, anchor: "west", padding: 4pt)
  // רדיוס הדיסקה
  line((0, 0), (-2, 0))
  content((-1, 0), $R$, anchor: "south", padding: 3pt)
}))

=== שדה חשמלי

==== קווי שדה

קו שדה הוא עקום שהשדה משיק לו בכל נקודה, בכיוון החץ. למטען נקודתי $q$ בראשית הצירים השדה רדיאלי: החוצה אם $q>0$ ופנימה אם $q<0$, וגודלו דועך כמו $1/r^2$. באיור אורך כל חץ הוא גודל השדה בנקודה שבה הוא מתחיל (העיגולים המנוקדים רק מסמנים מרחק קבוע מהמטען):
#align(center, canvas(length: 1.25cm, {
  import draw: *
  for (k, r) in (0.9, 1.55, 2.25).enumerate() {
    circle((0, 0), radius: r, stroke: (dash: "dotted"))
    let len = 0.75 / (r * r)
    for i in range(3) {
      let a = (i * 120 + k * 40) * 1deg
      line(
        (r * calc.cos(a), r * calc.sin(a)),
        ((r + len) * calc.cos(a), (r + len) * calc.sin(a)),
        mark: (end: ">", fill: black, scale: 0.65),
      )
    }
  }
  circle((0, 0), radius: 0.09, fill: black)
  content((0, 0), $q$, anchor: "north-east", padding: 4pt)
}))

שני מטענים, $q$ ו-$-q$, במרחק מסוים זה מזה. קרוב לכל מטען שדהו שולט, ולכן הקווים יוצאים מהמטען החיובי ונכנסים אל השלילי. הקו שעל הציר המחבר בין המטענים ישר, וככל שהקו יוצא בזווית גדולה יותר מהציר הוא מתעקל יותר. קווים שיוצאים כמעט לאחור מתרחקים הרבה לפני שהם חוזרים אל המטען השלילי (באיור הם נחתכים בגבול הציור):

// השדה של מטען q ב-(-1, 0) ומטען -q ב-(1, 0), ביחידות שרירותיות
#let dip-field((x, y)) = {
  let d1 = calc.pow(calc.pow(x + 1, 2) + calc.pow(y, 2), 1.5)
  let d2 = calc.pow(calc.pow(x - 1, 2) + calc.pow(y, 2), 1.5)
  ((x + 1) / d1 - (x - 1) / d2, y / d1 - y / d2)
}

// קו שדה שיוצא מהמטען החיובי בזווית phi, מחושב בצעדים קטנים לאורך כיוון השדה
#let dip-line(phi) = {
  let p = (-1 + 0.15 * calc.cos(phi), 0.15 * calc.sin(phi))
  let pts = (p,)
  let h = 0.05
  for _ in range(600) {
    // צעד אמצעי: קודם חצי צעד, ואז צעד שלם לפי השדה באמצע
    let e = dip-field(p)
    let n = calc.sqrt(e.at(0) * e.at(0) + e.at(1) * e.at(1))
    let m = (p.at(0) + h / 2 * e.at(0) / n, p.at(1) + h / 2 * e.at(1) / n)
    let f = dip-field(m)
    let k = calc.sqrt(f.at(0) * f.at(0) + f.at(1) * f.at(1))
    p = (p.at(0) + h * f.at(0) / k, p.at(1) + h * f.at(1) / k)
    pts.push(p)
    // עוצרים כשמגיעים למטען השלילי או יוצאים מגבולות הציור
    if calc.pow(p.at(0) - 1, 2) + calc.pow(p.at(1), 2) < 0.0225 or calc.abs(p.at(0)) > 3 or calc.abs(p.at(1)) > 2 {
      break
    }
  }
  return pts
}

#align(center, canvas({
  import draw: *
  for phi in (0deg, 40deg, -40deg, 80deg, -80deg, 120deg, -120deg) {
    let pts = dip-line(phi)
    line(..pts)
    // חץ קטן ליד המטען החיובי
    line(pts.at(6), pts.at(9), mark: (end: ">", fill: black, scale: 0.6))
    // אם הקו נכנס למטען השלילי, חץ קטן גם לידו
    let (ex, ey) = pts.last()
    if calc.pow(ex - 1, 2) + calc.pow(ey, 2) < 0.04 {
      let n = pts.len()
      line(pts.at(n - 10), pts.at(n - 7), mark: (end: ">", fill: black, scale: 0.6))
    }
  }
  circle((-1, 0), radius: 0.1, fill: black)
  circle((1, 0), radius: 0.1, fill: black)
  content((-1.45, 0), $q$)
  content((1.45, 0), $-q$)
}))

=== חוק גאוס

==== שטף חשמלי

בכל משטח שטוח נבחר אוריינטציה, כלומר כיוון חיובי: אחד משני וקטורי היחידה הניצבים למשטח, $hat(n)$.
אם נכפיל אותו בשטח $A$, נקבל את *וקטור השטח* $arrow(A) = A hat(n)$, שמייצג את המשטח:

#align(center, canvas({
  import draw: *
  // משטח שטוח, כמו שרואים אותו בפרספקטיבה
  line((0, 0), (3, 0), (4, 1), (1, 1), close: true, fill: luma(230))
  // וקטור השטח: ניצב למשטח, ומתחיל באמצעו
  line((2, 0.5), (2, 2.3), mark: (end: ">", fill: black))
  content((2, 2.3), $arrow(A)$, anchor: "south", padding: 3pt)
}))

השטף של שדה חשמלי $arrow(E)$ דרך משטח שטוח, כשהשדה אחיד עליו, הוא $Phi = arrow(E) dot arrow(A)$. בכלל, את המשטח $Sigma$ מחלקים לאלמנטים קטנים, $dif(arrow(a)) = hat(n) dif(a)$, ומסכמים:

$ Phi = integral_Sigma arrow(E) dot dif(arrow(a)) $

כשהשדה יוצא דרך המשטח (עם האוריינטציה שנבחרה) השטף חיובי, וכשהוא נכנס (נגד האוריינטציה) השטף שלילי:
#align(center, canvas(length: 0.9cm, {
  import draw: *
  // משמאל שדה נגד האוריינטציה, מימין שדה עם האוריינטציה (s = כיוון החצים ביחס ל-n)
  for (dx, s, lab) in ((0, -1, $Phi < 0$), (5, 1, $Phi > 0$)) {
    line((dx, 0), (dx + 3, 0), (dx + 4, 1), (dx + 1, 1), close: true, fill: luma(230))
    for x in (1.2, 2, 2.8) {
      line((dx + x, 0.5 - 1.5 * s), (dx + x, 0.5 + 1.5 * s), mark: (end: ">", fill: black))
    }
    content((dx + 1.2, 2), $arrow(E)$, anchor: "south", padding: 3pt)
    // וקטור האוריינטציה של המשטח
    line((dx + 3.25, 0.5), (dx + 3.25, 1.7), stroke: 1.2pt, mark: (end: ">", fill: black))
    content((dx + 3.25, 1.7), $hat(n)$, anchor: "west", padding: 4pt)
    content((dx + 2, -1), lab, anchor: "north", padding: 4pt)
  }
}))

בגוף קעור אותו קו שדה עשוי להיכנס ולצאת כמה פעמים. באיור, שהוא חתך סכמטי, הקו חוצה את המשטח ארבע פעמים, וסימן התרומה לשטף מתחלף: $-$, $+$, $-$, $+$. בשדה אחיד ובלי מטען בתוך הגוף התרומות מתבטלות בזוגות, והשטף הכולל דרך המשטח הסגור הוא אפס:

#align(center, canvas(length: 0.85cm, {
  import draw: *
  // חתך U של גוף קעור, המוצג כפריזמה כדי לרמוז על הצורה התלת-ממדית
  let front = ((0, 0), (1.15, 0), (1.15, 1.15), (2.25, 1.15), (2.25, 0), (3.4, 0), (3.4, 2.15), (0, 2.15))
  let back = front.map(p => (p.at(0) + 0.55, p.at(1) + 0.4))
  line(..back, close: true, stroke: (dash: "dashed"))
  for i in range(front.len()) {
    line(front.at(i), back.at(i), stroke: (dash: "dashed"))
  }
  line(..front, close: true, fill: luma(235), stroke: 1.4pt)
  // קו שדה ישר חוצה את שתי הזרועות של החתך
  line((-0.65, 0.65), (4.05, 0.65), mark: (end: ">", fill: black, scale: 0.8))
  content((0, 0.65), $-$, anchor: "south", padding: 3pt)
  content((1.15, 0.65), $+$, anchor: "south", padding: 3pt)
  content((2.25, 0.65), $-$, anchor: "south", padding: 3pt)
  content((3.4, 0.65), $+$, anchor: "south", padding: 3pt)
  content((4.05, 0.65), $arrow(E)$, anchor: "south", padding: 4pt)
}))

==== שטף דרך ספירה

עבור ספירה ברדיוס $R$ סביב מטען $q$ במרכזה, עם אוריינטציה החוצה:

$ dif(arrow(a)) = R^2 sin(theta) dif(theta) dif(phi) hat(r) $

על הספירה $arrow(E) = (k q)/R^2 hat(r)$, ולכן $arrow(E) dot dif(arrow(a)) = k q sin(theta) dif(theta) dif(phi)$ והשטף הוא

$ Phi = integral_0 ^(2pi) integral_0 ^pi k q sin(theta) dif(theta) dif(phi) = 4 pi k q = q / epsilon_0 $

התוצאה לא תלויה ב-$R$. גם אם נקיף את הספירה במשטח סגור אחר, השטף דרכו יהיה זהה: אין מטען בין שני המשטחים, ולכן קווי השדה לא מתחילים ולא נגמרים שם, וכל קו שיוצא דרך הספירה חוצה גם את המשטח החיצוני. בשניהם $Phi = q/epsilon_0$, כל עוד המטען הכלוא הוא $q$ (הוכחה מדויקת יותר, בעזרת זווית מרחבית, בהמשך):

#align(center, canvas(length: 0.8cm, {
  import draw: *
  // הצורה החיצונית, עקום סגור לא סימטרי סביב הספירה
  let rb(t) = 2.2 + 0.4 * calc.cos(3 * t) + 0.25 * calc.sin(2 * t)
  line(..range(72).map(i => {
    let t = i * 5deg
    (rb(t) * calc.cos(t), rb(t) * calc.sin(t))
  }), close: true)
  // הספירה והמטען במרכזה
  circle((0, 0), radius: 1)
  circle((0, 0), radius: 0.08, fill: black)
  content((0, 0), $q$, anchor: "south-west", padding: 4pt)
  // קווי שדה, יוצאים מהמטען ועוברים דרך הספירה ודרך הצורה
  for i in range(8) {
    let a = i * 45deg + 20deg
    line(
      (0.12 * calc.cos(a), 0.12 * calc.sin(a)),
      ((rb(a) + 0.5) * calc.cos(a), (rb(a) + 0.5) * calc.sin(a)),
      mark: (end: ">", fill: black, scale: 0.6),
    )
  }
}))


==== זווית מרחבית

זווית במישור נמדדת באורך הקשת $s$ שהיא חותכת ממעגל היחידה, ואורך זה הוא הזווית $theta$ ברדיאנים:

#align(center, canvas(length: 2cm, {
  import draw: *
  let a0 = 10deg
  let th = 55deg
  // מעגל היחידה והזווית theta בין שתי קרניים
  circle((0, 0), radius: 1)
  line((0, 0), (calc.cos(a0), calc.sin(a0)))
  line((0, 0), (calc.cos(a0 + th), calc.sin(a0 + th)))
  // הקשת שנחתכת, באורך s, מודגשת
  line(..range(12).map(i => {
    let t = a0 + i * th / 11
    (calc.cos(t), calc.sin(t))
  }), stroke: 1.5pt)
  // קשת קטנה שמסמנת את הזווית
  line(..range(12).map(i => {
    let t = a0 + i * th / 11
    (0.3 * calc.cos(t), 0.3 * calc.sin(t))
  }))
  content((0.58 * calc.cos(a0 + th / 2), 0.58 * calc.sin(a0 + th / 2)), $theta$)
  content((1.15 * calc.cos(a0 + th / 2), 1.15 * calc.sin(a0 + th / 2)), $s$)
  content((0.5 * calc.cos(a0), 0.5 * calc.sin(a0)), $1$, anchor: "north", padding: 3pt)
  circle((0, 0), radius: 0.03, fill: black)
}))

נגדיר גם *זווית מרחבית*, זווית בתלת-ממד: עבור שטח מסוים $Sigma$ ניקח את ההיטל שלו, לאורך הקרניים מנקודת המבט $O$, על כדור שמרכזו ב-$O$. הזווית המרחבית $Omega$ היא שטח ההיטל חלקי רדיוס הכדור בריבוע, ולכן היא לא תלויה ברדיוס הכדור:
#align(center, canvas(length: 1cm, {
  import draw: *
  // השלכה פרספקטיבית פשוטה של כדור, חרוט הקרניים והמשטח Sigma
  let proj(p) = (p.at(0) + 0.42 * p.at(1), p.at(2) + 0.28 * p.at(1))
  let sph(th, ph) = (calc.sin(th) * calc.cos(ph), calc.sin(th) * calc.sin(ph), calc.cos(th))
  let O = (0, 0, 0)
  // קווי רוחב ואורך על כדור היחידה
  for th in (45deg, 90deg, 135deg) {
    line(..range(37).map(i => proj(sph(th, i * 10deg))), stroke: (dash: "dotted"))
  }
  for ph in (-60deg, 0deg, 60deg, 120deg) {
    line(..range(19).map(i => proj(sph(i * 10deg, ph))), stroke: (dash: "dotted"))
  }
  // טלאי כדורי שמייצג את הזווית המרחבית
  let th0 = 42deg
  let th1 = 78deg
  let ph0 = -34deg
  let ph1 = 34deg
  let patch = () => {
    let pts = ()
    for i in range(9) { pts.push(proj(sph(th0, ph0 + i * (ph1 - ph0) / 8))) }
    for i in range(1, 9) { pts.push(proj(sph(th0 + i * (th1 - th0) / 8, ph1))) }
    for i in range(1, 9) { pts.push(proj(sph(th1, ph1 - i * (ph1 - ph0) / 8))) }
    for i in range(1, 8) { pts.push(proj(sph(th1 - i * (th1 - th0) / 8, ph0))) }
    pts
  }
  let sphere_patch = patch()
  line(..sphere_patch, close: true, fill: luma(215), stroke: 1.4pt)
  // אותו אוסף כיוונים, במרחק גדול יותר, יוצר את המשטח הנראה
  let scaled(p, f) = (f * p.at(0), f * p.at(1), f * p.at(2))
  let target = patch().map(p => (2.35 * p.at(0), 2.35 * p.at(1)))
  line(..target, close: true, fill: luma(232), stroke: 1.4pt)
  for p in (sph(th0, ph0), sph(th0, ph1), sph(th1, ph1), sph(th1, ph0)) {
    line(proj(p), proj(scaled(p, 2.35)), stroke: (dash: "dashed"))
  }
  circle(proj(O), radius: 0.055, fill: black)
  content(proj(O), $O$, anchor: "south-west", padding: 3pt)
  content(target.at(9), $Sigma$, anchor: "south-east", padding: 3pt)
  content(proj(sph(60deg, 0deg)), $Omega$, anchor: "south-west", padding: 3pt)
  let rp = proj(sph(42deg, -34deg))
  line(proj(O), rp, stroke: 1pt)
  content(((rp.at(0)) / 2, (rp.at(1)) / 2), $R$, anchor: "south", padding: 3pt)
}))

על הכדור, אלמנט שטח $dif(a) = R^2 sin(theta) dif(theta) dif(phi)$ תופס זווית מרחבית:
$ dif(Omega) = dif(a)/R^2 = sin(theta) dif(theta) dif(phi) $
אלמנט שטח שטוח $dif(a)$ במרחק $r$ מ-$O$, שהנורמל שלו $hat(n)$ יוצר זווית $alpha$ עם הכיוון הרדיאלי, תופס זווית מרחבית שנקבעת לפי ההיטל שלו הניצב לכיוון הרדיאלי, ששטחו $dif(a) cos(alpha)$:
$ dif(Omega) = (dif(a) cos(alpha))/r^2 $

#align(center, canvas(length: 1cm, {
  import draw: *
  let al = 35deg
  let L = 0.8
  let Q = (3, 0)
  // הכיוון הרדיאלי מ-O אל האלמנט
  line((0, 0), Q, stroke: 1pt, mark: (end: ">", fill: black))
  circle((0, 0), radius: 0.05, fill: black)
  content((0, 0), $O$, anchor: "north-east", padding: 4pt)
  content((1.5, 0), $r$, anchor: "north", padding: 4pt)
  line(Q, (4.1, 0), stroke: (dash: "dotted"))
  // האלמנט, כמו שרואים אותו מהקצה, והנורמל שלו
  let t1 = (3 - L * calc.sin(al), L * calc.cos(al))
  let t2 = (3 + L * calc.sin(al), -L * calc.cos(al))
  line(t1, t2, stroke: 1.6pt)
  line(Q, (3 + 1.1 * calc.cos(al), 1.1 * calc.sin(al)), mark: (end: ">", fill: black))
  content((3 + 1.1 * calc.cos(al), 1.1 * calc.sin(al)), $hat(n)$, anchor: "south-west", padding: 3pt)
  content(t1, $dif(a)$, anchor: "south-east", padding: 3pt)
  // ההיטל הניצב לכיוון הרדיאלי, באורך dif(a) cos(alpha)
  line((3, -L * calc.cos(al)), (3, L * calc.cos(al)), stroke: (dash: "dashed"))
  line(t1, (3, L * calc.cos(al)), stroke: (dash: "dotted"))
  line(t2, (3, -L * calc.cos(al)), stroke: (dash: "dotted"))
  content((3, -L * calc.cos(al)), $dif(a) cos(alpha)$, anchor: "north", padding: 4pt)
  // הזווית alpha בין הכיוון הרדיאלי לנורמל
  line(..range(9).map(i => {
    let a = i * al / 8
    (3 + 0.6 * calc.cos(a), 0.6 * calc.sin(a))
  }))
  content((3 + 0.9 * calc.cos(al / 2), 0.9 * calc.sin(al / 2)), $alpha$)
}))

נחבר את זה להגדרת השטף. השדה של מטען נקודתי $q$ הוא $arrow(E) = (k q)/r^2 hat(r)$, ולכן $arrow(E) dot dif(arrow(a)) = (k q)/r^2 cos(alpha) dif(a)$, כלומר:
$ dif(Phi) = k q dif(Omega) $
אם המשטח $Sigma$ סגור ומקיף את המטען, הוא תופס את כל הכיוונים ממנו, ולכן $integral.cont dif(Omega) = 4 pi$, כמו בספירה. קרן שיוצאת מהמטען חוצה את המשטח פעם אחת נטו, כי חציות נוספות באות בזוגות ומתבטלות בגלל הסימן של $cos(alpha)$ (זו הזווית ה"חתומה"). לכן:
$ Phi = k q integral.cont dif(Omega) = 4 pi k q = q/epsilon_0 $

==== חוק גאוס והדיברגנץ

נסמן ב-$Sigma$ מעטפת סגורה, ב-$V$ את הנפח שהיא סוגרת, וב-$q_("enc")$ את המטען שבתוכה. לפי חוק קולון, כל אלמנט מטען $dif(q')$ תורם לשטף דרך המעטפת:

$ dif(Phi) = k dif(q') integral.cont ((arrow(r) - arrow(r)') dot dif(arrow(a)))/(|arrow(r) - arrow(r)'|^3) $

האינטגרל הפנימי הוא הזווית המרחבית החתומה שהמעטפת תופסת מנקודת המטען: הוא $4 pi$ אם המטען בפנים ואפס אם הוא בחוץ. לכן, בסכימה על כל אלמנטי המטען, המטענים שמחוץ למעטפת אינם תורמים לשטף הכולל, ומתקבל:

$ Phi = integral.cont arrow(E) dot dif(arrow(a)) = 4 pi k q_("enc") = q_("enc")/epsilon_0 = 1/(epsilon_0) integral_V rho dif("Vol") $

זוהי הצורה האינטגרלית של חוק גאוס. את הצורה המקומית נקבל בעזרת הדיברגנץ. לשדה $arrow(F) = F_x hat(x) + F_y hat(y) + F_z hat(z)$:

$ nabla dot arrow(F) = (partial F_x)/(partial x) + (partial F_y)/(partial y) + (partial F_z)/(partial z) $

לדוגמה, עבור וקטור המקום $arrow(r) = x hat(x) + y hat(y) + z hat(z)$ מתקבל $nabla dot arrow(r) = 3$.

לפי משפט הדיברגנץ, השטף דרך מעטפת סגורה שווה לאינטגרל הנפחי של הדיברגנץ:

$ integral.cont arrow(F) dot dif(arrow(a)) = integral_V (nabla dot arrow(F)) dif("Vol") $

נציב $arrow(F) = arrow(E)$ בחוק גאוס, ונקבל לכל נפח $V$:

$ integral_V (nabla dot arrow(E) - rho/epsilon_0) dif("Vol") = 0 $

לכן, בנקודות שבהן השדה והצפיפות רציפים, מתקבלת הצורה המקומית:

$ nabla dot arrow(E) = rho/epsilon_0 $

מעטפת גאוסית היא משטח סגור דמיוני שבוחרים כדי לחשב שטף; היא אינה חייבת להיות זהה לצורת הגוף הטעון. למשל, בסימטריה כדורית נוח לבחור ספירה קונצנטרית, ובסימטריה גלילית גליל קואקסיאלי. באיורים, הגוף הטעון מוצג באפור והמעטפת הגאוסית בקו מקווקו.

#align(center, canvas(length: 0.9cm, {
  import draw: *
  let R = 0.72
  let r = 1.25
  circle((0, 0), radius: R, fill: luma(230), stroke: 1.2pt)
  circle((0, 0), radius: r, stroke: (dash: "dashed", paint: black))
  circle((0, 0), radius: 0.045, fill: black)
  for a in (0deg, 90deg, 180deg, 270deg) {
    line((0.85 * calc.cos(a), 0.85 * calc.sin(a)), (1.55 * calc.cos(a), 1.55 * calc.sin(a)), mark: (end: ">", fill: black, scale: 0.7))
  }
  line((0, 0), (R * calc.cos(225deg), R * calc.sin(225deg)))
  content((0.3 * calc.cos(225deg), 0.3 * calc.sin(225deg)), $R$, anchor: "north-east", padding: 2pt)
  line((0, 0), (r * calc.cos(315deg), r * calc.sin(315deg)))
  content((0.72 * calc.cos(315deg), 0.72 * calc.sin(315deg)), $r$, anchor: "north-west", padding: 2pt)
  content((0, 0.35), $rho$, anchor: "south", padding: 2pt)
}))

חוק גאוס נכון לכל מעטפת סגורה, אך הוא מאפשר לחשב את $arrow(E)$ בקלות רק כאשר הסימטריה של התפלגות המטען קובעת את כיוון השדה ואת גודלו על חלקי המעטפת שבוחרים. אין צורך ש-$arrow(E)$ יהיה מקביל ל-$dif(arrow(a))$ בכל מקום, מספיק שנדע את המכפלה הסקלרית בכל חלק. למשל, בגליל אינסופי השדה רדיאלי: הוא מקביל לנורמל של המעטפת הצדדית ומאונך לנורמל של בסיסי הגליל, ולכן אין דרכם שטף. הסימטריות השכיחות הן כדורית, גלילית ומישורית.

#exercise[
    נתון כדור ברדיוס $R$. צפיפותו:
    $ rho(r) = rho_0 (r/R)^n $
    כאשר $n>0$. חשבו את השדה החשמלי.
]

#example[
    נחשב את השדה החשמלי של גליל אינסופי מלא ברדיוס $R$ ובצפיפות מטען אחידה $rho$. נבחר מעטפת גאוסית גלילית קואקסיאלית, בגובה $h$ וברדיוס $s$. הסימטריה מבטיחה שהשדה רדיאלי, ולכן אין שטף דרך הבסיסים, ושגודלו קבוע על המעטפת הצדדית. באיור, משמאל $s < R$ ומימין $s > R$:

    #align(center, canvas(length: 0.8cm, {
      import draw: *
      let R = 0.52
      for (dx, s, lab) in ((0, 0.34, $s < R$), (3.35, 0.88, $s > R$)) {
        let x1 = dx + 0.45
        let x2 = dx + 2.25
        let xm = (x1 + x2) / 2
        // חץ השדה זז הצידה כדי שלא יחפוף את הרדיוס R
        let xe = xm + 0.5
        let cy = 0.72
        // הגוף הטעון: גליל מלא ברדיוס R
        line((x1, cy - R), (x2, cy - R), (x2, cy + R), (x1, cy + R), close: true, fill: luma(230))
        circle((x1, cy), radius: (0.28, R), fill: luma(230), stroke: 1pt)
        circle((x2, cy), radius: (0.28, R), fill: luma(230), stroke: 1pt)
        // המעטפת הגאוסית הגלילית, בעלת אותו ציר
        line((x1, cy - s), (x2, cy - s), stroke: (dash: "dashed"))
        line((x1, cy + s), (x2, cy + s), stroke: (dash: "dashed"))
        circle((x1, cy), radius: (0.28, s), stroke: (dash: "dashed"))
        circle((x2, cy), radius: (0.28, s), stroke: (dash: "dashed"))
        line((xm, cy), (xm, cy + R))
        content((xm + 0.05, cy + R / 2), $R$, anchor: "west", padding: 2pt)
        content((x1 + 0.05, cy + s + 0.08), $s$, anchor: "south", padding: 2pt)
        line((xe, cy + s), (xe, cy + s + 0.35), mark: (end: ">", fill: black, scale: 0.65))
        content((xe + 0.12, cy + s + 0.28), $arrow(E)$, anchor: "west", padding: 2pt)
        content((xm, -0.12), lab, anchor: "north", padding: 2pt)
      }
    }))

    עבור $0 <= s < R$, המטען הכלוא הוא $rho pi s^2 h$, ולכן:
    $ E 2 pi s h = (rho pi s^2 h)/epsilon_0 quad ==> quad arrow(E) = (rho s)/(2 epsilon_0) hat(s) $

    עבור $s > R$, המעטפת מקיפה את כל חתך הגליל, והמטען הכלוא הוא $rho pi R^2 h$:
    $ E 2 pi s h = (rho pi R^2 h)/epsilon_0 quad ==> quad arrow(E) = (rho R^2)/(2 epsilon_0 s) hat(s) $

    בתוך הגליל השדה גדל ליניארית עם $s$, ומחוצה לו הוא דועך כמו $1/s$, כאילו המטען ליחידת אורך, $rho pi R^2$, היה מרוכז על הציר.
]
#todo[
    $ arrow(E) (arrow(r)) = -1/(4 pi epsilon_0) integral dif(q') nabla(1/(|arrow(r) - arrow(r)'|)) $
    $ = - nabla underbrace((1/(4 pi epsilon_0) integral (dif(q'))/(|arrow(r) - arrow(r)'|)), Phi(arrow(r))) $
    ל - $Phi(arrow(r))$ נקרא *הפוטנציאל* של השדה.
    $ arrow(E) (arrow(r)) = - nabla (Phi(arrow(r)) + c) $
]
