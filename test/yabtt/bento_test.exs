defmodule Yabtt.BentoTest do
  use ExUnit.Case, async: true

  doctest Bento.Encoder.Tuple
  doctest Bento.Encoder.YaBTT.Tracked
end