# Copyright(c) 2019 TenTakano
# All rights reserved.
# See License in the project root for license information.

ExUnit.start()

defmodule TestHelper do
  def makeSample do
    sampleTime =  %DateTime{year: 2019, month: 7, day: 7,
                        hour: 18, minute: 50, second: 7, microsecond: {0, 0},
                        utc_offset: 0, std_offset: 0,
                        time_zone: "Etc/GMT", zone_abbr: "UTC"}
    
    sampleList = [
      %Issue{status: " ", title: "Test1", add: sampleTime},
      %Issue{status: "x", title: "Test2", add: sampleTime},
      %Issue{status: " ", title: "Test3", add: sampleTime}
    ]

    {sampleTime, sampleList}
  end
end