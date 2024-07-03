#let raw = csv("ETH-GBP.csv", row-type: dictionary)

#let converted = raw.map((it) =>(:
  ..it,
  Date: datetime(
    ..("year", "month", "day").zip(
      it.Date.matches(
        regex("(\d{4})-(\d{2})-(\d{2})")
      ).first().captures
    ).fold(
      (:), 
      (acc, it) => (
        ..acc, 
        (it.first()): int(it.last())
      )
    )
  )
))

#let converted = converted.map((it)=>(:
  ..it,
  Day: it.Date.ordinal() + (it.Date.year() - 2023) * 365,
  Date-Display: it.Date.display()
))

#let series(key) = converted.map(
  (it) => (
    it.Day,
    float(it.at(key))
  )
)
