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
= חשמל ומגנטיות
== אלקטרוסטטיקה
=== חוק קולון
==== חזרה על השיעור הקודם

חוק קולון, השדה של מטען נקודתי $q$ בראשית הצירים:

$ arrow(E)(arrow(r)) = k q/(r^2) hat(r) quad quad k = 1/(4 pi epsilon_0) $

ובכלל, עבור פיזור מטען כלשהו:

$ arrow(E)(arrow(r)) = k integral (arrow(r) - arrow(r)')/(|arrow(r) - arrow(r)'|^3) dif(q') $

$ dif(q') = cases(
  rho(arrow(r)') dif("Vol'"),
  sigma(arrow(r)') dif(a'),
  lambda(arrow(r)') dif(l')
) $

==== תרגיל: שדה של מעטפת כדור

פתירת תרגיל מהשיעור הקודם, שדה בצורת מעטפת של כדור.

$ dif(q') = sigma R^2 sin(theta) dif(phi) dif(theta) $

===== הגדרות

הגיאומטריה, ממבט מהצד. הטבעת המנוקדת היא כל הנקודות על המעטפת עם אותו $theta$, ועליה רץ אינטגרל ה-$phi$:

#align(center, canvas({
  import draw: *
  let R = 1.5
  let z = 3.6
  let th = 50deg
  // הנקודה על המעטפת, ב-phi = 0
  let q = (R * calc.sin(th), R * calc.cos(th))
  // המעטפת, כמו שרואים אותה מהצד
  circle((0, 0), radius: R, fill: luma(230))
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

$ = 2/(z^2) quad quad (z > R) $

(בתוך המעטפת, $0 <= z < R$, הביטוי מתאפס.)

===== תוצאה

$ arrow(E)(z) = k sigma R^2 2 pi dot 2/(z^2) hat(z) = (k hl(4 pi R^2 sigma))/(z^2) hat(z) quad quad z > R $

אז אם אתה בתוך המעטפת, השדה לא משפיע עליך, ואם אתה בחוץ, השדה משפיע עליך כאילו כל המטען מרוכז בנקודה יחידה באמצע הכדור.
ניוטון גילה שהעובדה הזו נכונה לשדה כבידתי, לפני שגילו אותה על שדה חשמלי. הוא גם הראה שבתוך מעטפת ספרואידית (Spheroid) השדה מתאפס, לא רק בתוך כדור מושלם.

==== תרגיל: שדה של דיסקה

לחשב את השדה החשמלי של דיסקה שטוחה (בלי גובה) ברדיוס $R$ וצפיפות מטען משטחית $sigma$, בנקודה שמעל אמצע הדיסקה, במרחק $z$ ממנה. בקואורדינטות גליליות אלמנט השטח הוא $dif(a') = r dif(theta) dif(r)$. הגיאומטריה:

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
}))

=== שדה חשמלי

==== קווי שדה

מטען נקודתי בראשית הצירים. על כל עיגול סביבו, שמסמן מרחק קבוע מהמטען, החצים מצביעים החוצה ומסמנים את השדה החשמלי. בגלל שגודל השדה יורד כמו $1/r^2$, החצים הולכים וקטנים כשעוברים בין העיגולים:

#align(center, canvas(length: 0.9cm, {
  import draw: *
  // עיגולים במרחקים 1, 1.8, 2.8 מהמטען
  for (k, r) in (1, 1.8, 2.8).enumerate() {
    circle((0, 0), radius: r, stroke: (dash: "dotted"))
    // אורך החץ פרופורציוני ל-1/r^2
    let len = 1 / (r * r)
    for i in range(8) {
      // מסיטים את החצים בעיגול השני כדי שלא יחפפו לחצים בעיגול הראשון
      let a = (i + k * 0.5) * 45deg
      line(
        (r * calc.cos(a), r * calc.sin(a)),
        ((r + len) * calc.cos(a), (r + len) * calc.sin(a)),
        mark: (end: ">", fill: black, scale: 0.5),
      )
    }
  }
  circle((0, 0), radius: 0.1, fill: black)
  content((0, 0), $q$, anchor: "north-east", padding: 4pt)
}))

אפשר גם לצייר בלי העיגולים, פשוט כשדה וקטורי של חצים.

שני מטענים, אחד חיובי $q$ ואחד שלילי $-q$, במרחק מסויים אחד מהשני. קרוב מאוד למטען החיובי יש חצים חזקים החוצה, כי המטען השלילי רחוק מכדי להשפיע. קרוב מאוד למטען השלילי יש חצים חזקים פנימה, כי המטען החיובי רחוק מכדי להשפיע. ביניהם השדה עובר בקווים מעוקלים, מהמטען החיובי, שדוחף, אל השלילי, שמושך. ככל שהקו יוצא בזווית רחוקה יותר מהציר המחבר בין המטענים, הקשת שלו גדולה יותר, והקו שעל הציר עצמו הוא קו ישר:

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

השטף של שדה חשמלי דרך משטח $Sigma$:

$ Phi = integral_Sigma arrow(E) dot dif(arrow(a)) $

בכל משטח שטוח, נבחר את האוריינטציה שלו, כלומר הכיוון החיובי, ע"י אחד משני וקטורי היחידה הניצבים למשטח, $hat(n)$.
אם נכפיל את וקטור האוריינטציה בגודל השטח, נקבל את *וקטור השטח*, הווקטור שמייצג את המשטח, ונסמן אותו $arrow(A) = A hat(n)$:

#align(center, canvas({
  import draw: *
  // משטח שטוח, כמו שרואים אותו בפרספקטיבה
  line((0, 0), (3, 0), (4, 1), (1, 1), close: true, fill: luma(230))
  // וקטור השטח: ניצב למשטח, ומתחיל באמצעו
  line((2, 0.5), (2, 2.3), mark: (end: ">", fill: black))
  content((2, 2.3), $arrow(A)$, anchor: "south", padding: 3pt)
}))

כשהשדה נכנס ליריעה (נגד האוריינטציה שנבחרה) יש עליה שטף שלילי. כשהוא יוצא (עם האוריינטציה) יש עליה שטף חיובי:

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
    line((dx + 3.8, 0.5), (dx + 3.8, 1.7), stroke: 1.2pt, mark: (end: ">", fill: black))
    content((dx + 3.8, 1.7), $hat(n)$, anchor: "west", padding: 4pt)
    content((dx + 2, -1), lab, anchor: "north", padding: 4pt)
  }
}))

==== שטף דרך ספירה

עבור ספירה ברדיוס $R$ סביב מטען $q$ במרכזה, עם אוריינטציה החוצה:

$ dif(arrow(a)) = R^2 sin(theta) dif(theta) dif(phi) hat(r) $

על הספירה $arrow(E) = (k q)/R^2 hat(r)$, ולכן $arrow(E) dot dif(arrow(a)) = k q sin(theta) dif(theta) dif(phi)$ והשטף הוא

$ Phi = integral_0 ^(2pi) integral_0 ^pi k q sin(theta) dif(theta) dif(phi) = q / epsilon_0 $

אם יש מטען בתוך ספירה, ומסביבה עוד צורה כלשהי (ואין מטען נוסף ביניהן), השטף שעובר דרך הספירה זהה לשטף שעובר דרך הצורה, כי אותם קווי שדה עוברים דרך שתיהן, ולכן גם דרך הצורה $Phi = q/epsilon_0$:

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
אנחנו לא באמת יודעים למדוד זווית. אנחנו פשוט מודדים *אורך* של חלק ממעגל יחידה, שמקביל לזווית שאנחנו רוצים למדוד. אורך הקשת $s$ שווה לזווית $theta$ ברדיאנים:

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

נגדיר גם זווית מרחבית, זווית בתלת ממד: עבור שטח מסויים, ניקח היטל שלו על כדור שמרכזו בנקודת המבט, ואז הזווית המרחבית $Omega$ היא השטח של ההיטל, חלקי רדיוס הכדור בריבוע:

#align(center, canvas({
  import draw: *
  let lo = -7deg
  let hi = 37deg
  let mid = 15deg
  // המשטח המקורי, על הקרניים בקצוות החרוט
  let p1 = (3.4 * calc.cos(lo), 3.4 * calc.sin(lo))
  let p2 = (4.2 * calc.cos(hi), 4.2 * calc.sin(hi))
  // הכדור סביב נקודת המבט
  circle((0, 0), radius: 2)
  circle((0, 0), radius: 0.05, fill: black)
  line((0, 0), p1)
  line((0, 0), p2)
  line(p1, p2, stroke: 1.5pt)
  content(p2, $Sigma$, anchor: "south-west", padding: 4pt)
  // ההיטל על הכדור, מודגש
  line(..range(12).map(i => {
    let t = lo + i * (hi - lo) / 11
    (2 * calc.cos(t), 2 * calc.sin(t))
  }), stroke: 1.5pt)
  content((1.4 * calc.cos(mid), 1.4 * calc.sin(mid)), $Omega$)
  // רדיוס הכדור
  line((0, 0), (2 * calc.cos(200deg), 2 * calc.sin(200deg)), stroke: (dash: "dashed"))
  content((calc.cos(200deg), calc.sin(200deg)), $R$, anchor: "south", padding: 3pt)
}))

הזווית המרחבית של שטח אינפיניטסימלי היא:
$ dif(Omega) = dif(a)/R^2 = sin(theta) dif(theta) dif(phi) $
כאן $dif(a)$ הוא אלמנט שטח על הכדור, ניצב לכיוון הרדיאלי. אלמנט שטח שטוח $dif(A)$ במרחק $r$ מהמרכז, שהניצב שלו בזווית $alpha$ מהכיוון הרדיאלי, תופס זווית מרחבית $dif(Omega) = (dif(A) cos(alpha))/r^2$, כי ההטלה על הכדור מקטינה את השטח פי $cos(alpha)$.
אם נחבר את זה להגדרת השטף, על ספירה סביב המטען, שם $arrow(E) dot dif(arrow(a)) = (k q)/R^2 dif(a)$, קיבלנו:
$ dif(Phi) = k q dif(Omega) $
$ Phi = k q integral dif(Omega) $
$ = 4 pi k q = q/(epsilon_0) $
