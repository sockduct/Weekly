#! /usr/bin/env python3

# Conditions:
# * A child is playing with a ball on the nth floor of a tall building
# * The height of this floor, h, is known
# * He drops the ball out of the window. The ball bounces (for example),
#   to two-thirds of its height (a bounce of 0.66).
# * His mother looks out of a window 1.5 meters from the ground.
# * How many times will the mother see the ball pass in front of her
#   window (including when it's falling and bouncing?
#
# -- Three conditions must be met for a valid experiment:
# 1) Float parameter "h" in meters must be greater than 0
# 2) Float parameter "bounce" must be greater than 0 and less than 1
# 3) Float parameter "window" must be less than h.
# == If all three conditions above are fulfilled, return a positive
#    integer, otherwise return -1.
#
# Note: The ball can only be seen if the height of the rebounding ball
#       is strictly greater than the window parameter.
#
# Example:
# 1) h = 3, bounce = 0.66, window = 1.5, result is 3
# 2) h = 3, bounce = 1, window = 1.5, result is -1 (*)
# (*) Condition 2 not fulfilled.
#

def bouncing_ball(h, bounce, window):
    if h <= 0 or not (0 < bounce < 1) or window >= h:
        return -1

    count = 0
    while h > window:
        count += 2 if count % 2 == 1 else 1
        h *= bounce

    return count

def test_bouncing_ball():
    assert -1 == bouncing_ball(-1, 0, 0)
    assert -1 == bouncing_ball(0, 0, 0)
    assert -1 == bouncing_ball(1, -1, 0)
    assert -1 == bouncing_ball(1, 0, 0)
    assert -1 == bouncing_ball(1, 1, 0)
    assert -1 == bouncing_ball(1, 2, 0)
    assert -1 == bouncing_ball(1, .5, 1)
    assert -1 == bouncing_ball(1, .5, 2)
    assert 3 == bouncing_ball(3, 0.66, 1.5)
    assert -1 == bouncing_ball(3, 1, 1.5)

if __name__ == '__main__':
    test_bouncing_ball()
