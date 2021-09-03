require_relative "test_helper"

class BreakoutTest < Minitest::Test
  def test_hash
    today = Date.today
    series = self.series.map.with_index.to_h { |v, i| [today + i, v] }
    assert_equal [10, 15, 20].map { |i| today + i }, Breakout.detect(series, min_size: 5)
  end

  def test_array
    assert_equal [10, 15, 20], Breakout.detect(series, min_size: 5)
  end

  def test_percent
    assert_equal [8, 19], Breakout.detect(series, min_size: 5, percent: 0.5)
  end

  def test_amoc
    assert_equal [19], Breakout.detect(series, min_size: 5, method: "amoc")
  end

  def test_tail
    assert_equal [20], Breakout.detect(series, min_size: 5, method: "amoc", exact: false)
  end

  def test_empty
    assert_empty Breakout.detect([])
    assert_empty Breakout.detect([], method: "amoc")
  end

  def test_constant
    series = [1.0]*100
    assert_empty Breakout.detect(series)
    assert_empty Breakout.detect(series, percent: 1)
    assert_empty Breakout.detect(series, method: "amoc")
    assert_empty Breakout.detect(series, method: "amoc", exact: false)
  end

  def test_almost_constant
    series = [1.0]*100
    series[50] = 2.0
    assert_empty Breakout.detect(series)
    assert_empty Breakout.detect(series, percent: 1)
    assert_empty Breakout.detect(series, method: "amoc")
    assert_empty Breakout.detect(series, method: "amoc", exact: false)
  end

  def test_simple
    series = [
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
      1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
    ]
    assert_equal [10], Breakout.detect(series, min_size: 5)
    assert_empty Breakout.detect(series, min_size: 11)
    assert_empty Breakout.detect(series, min_size: 11, method: "amoc")
  end

  def test_bad_method
    error = assert_raises(ArgumentError) do
      Breakout.detect([], method: "bad")
    end
    assert_equal "Bad method", error.message
  end

  def series
    [
      3.0, 1.0, 2.0, 3.0, 2.0, 1.0, 1.0, 2.0, 2.0, 3.0,
      6.0, 4.0, 4.0, 5.0, 6.0, 4.0, 4.0, 4.0, 6.0, 5.0,
      9.0, 8.0, 7.0, 9.0, 8.0, 9.0, 9.0, 9.0, 7.0, 9.0
    ]
  end
end
