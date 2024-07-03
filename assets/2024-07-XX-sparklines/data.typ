#let raw = csv("ETH-GBP.csv", row-type: dictionary)

#let converted = raw.map(
  (it)=>(
    datetime(
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
    ).ordinal(),
    float(it.at("Adj Close"))
  )
)