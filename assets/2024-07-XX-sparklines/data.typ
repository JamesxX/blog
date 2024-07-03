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
  Date-Display: it.Date.display()
))

#let series(key) = converted.map(
  (it) => (
    it.Date.ordinal() + (it.Date.year() - 2023) * 365,
    float(it.at(key))
  )
)
