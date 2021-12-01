Code.require_file "stream_processing.exs"
ExUnit.start

defmodule StreamProcessingTest do
  use ExUnit.Case, async: true

  test ".garbage? <> is true" do
    assert StreamProcessing.garbage?("<>")
  end

  test ".garbage? <random characters> is true" do
    assert StreamProcessing.garbage?("<random characters>")
  end

  test ".garbage? <<<<> is true" do
    assert StreamProcessing.garbage?("<<<<>")
  end

  test ".garbage? <{!>}> is true" do
    assert StreamProcessing.garbage?("<{!>}>")
  end

  test ".garbage? <!!> is true" do
    assert StreamProcessing.garbage?("<!!>")
  end

  test ".garbage? <!!!>> is true" do
    assert StreamProcessing.garbage?("<!!!>>")
  end

  test ".garbage? <{o\"i!a,<{i<a> is true" do
    assert StreamProcessing.garbage?("<{o\"i!a,<{i<a>")
  end

  test ".group_count {} returns 1" do
    assert StreamProcessing.group_count("{}") == 1
  end

  test ".group_count {{{}}} returns 3" do
    assert StreamProcessing.group_count("{{{}}}") == 3
  end

  test ".group_count {{},{}} returns 3" do
    assert StreamProcessing.group_count("{{},{}}") == 3
  end

  # test ".group_count {{{},{},{{}}}} returns 6" do
  #   assert StreamProcessing.group_count("{{{},{},{{}}}}") == 6
  # end

  test ".group_score {} returns 1" do
    assert StreamProcessing.group_score("{}") == 1
  end

  test ".group_score {{}} returns 3" do
    assert StreamProcessing.group_score("{{}}") == 3
  end

  test ".group_score {{{}}} returns 6" do
    assert StreamProcessing.group_score("{{{}}}") == 6
  end

  test ".group_score {{},{}} returns 5" do
    assert StreamProcessing.group_score("{{},{}}") == 5
  end

  test ".group_score {{{},{},{{}}}} returns 5" do
    assert StreamProcessing.group_score("{{{},{},{{}}}}") == 16 
  end
end
