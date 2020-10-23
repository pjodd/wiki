---
title: Trälåderoutern
---

![](images/wooden_box_prototype_electronics_on_black_floor.jpg)

Above is an image of the first prototype. Wires will go away and it will
be built in layers rather than a large pile of stuff. Some more
electronics might be added to warn when running on battery.

-   DC-DC buck converter -> 3.9V
-   TP4056 based Li-Ion charger with passthrough
-   500mAh Li-Ion battery
-   DC-DC boost converter -> 5V
-   TP-Link TL-MR3020 PCB

The TP4056 charge the battery to 4.2V. Keeping the battery fully charged
24/7 will not only kill it in a couple of months, the risk of fire and
explosion is rather great.

The buck converter feeds 3.9V to the TP4056 charger, limiting the charge
of the Li-Ion battery to ~3.8V. This cripples the capacity but make the
battery lifetime more or less unlimited.

The boost converter ensure that the router get a stable 5V power no
matter if the power comes from the battery or the 3.8V source. It also
ensure that small spikes in the power is regulated.

This setup gives a UPS with about 1.2Wh capacity. At 0.6W and 20% power
loss in the extra electronics (in reality it's more like 5%) we end up
at 90 minutes of battery power. Not enough to handle the mean black out,
but more than enough to handle someone unplugging the power from the
outlet when vacuuming the floor or what not.
