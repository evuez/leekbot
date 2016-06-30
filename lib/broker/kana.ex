defmodule Broker.Kana do
  @behaviour Leekbot.Broker

  def handle(message) do
    hiragana = %{
      a: "あ", ka: "か", sa: "さ", ta: "た", na: "な", ha: "は", ma: "ま", ya: "や", ra: "ら", wa: "わ",
      i: "い", ki: "き", si: "し", ti: "ち", ni: "に", hi: "ひ", mi: "み", yi: "※ ", ri: "り", wi: "ゐ",
      u: "う", ku: "く", su: "す", tu: "つ", nu: "ぬ", hu: "ふ", mu: "む", yu: "ゆ", ru: "る", wu: "※ ",
      e: "え", ke: "け", se: "せ", te: "て", ne: "ね", he: "へ", me: "め", ye: "※ ", re: "れ", we: "ゑ",
      o: "お", ko: "こ", so: "そ", to: "と", no: "の", ho: "ほ", mo: "も", yo: "よ", ro: "ろ", wo: "を",
    }

    case hiragana[String.to_atom(message)] do
      nil  -> {:error, "This Kana does not exist."}
      kana -> {:ok, kana}
    end
  end
end
